function runComparisonPlottingWorkflow(simulationResults, outputPlan, plottingPlan)
    % RUNCOMPARISONPLOTTINGWORKFLOW Builds enabled comparison plots.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  simulationResults struct array
    %  allRunsMetrics struct array
    %  outputPlan struct
    %  plottingPlan struct
    %
    % SIDE EFFECTS
    %  Writes enabled comparison plots as PNGs to comparisons plots directory.

    if ~plottingPlan.comparisons.enabled
        return;
    end

    comparisonTargetDirectory = outputPlan.comparisons.plotsDirectory;
    numRuns = numel(simulationResults);

    % ================================================================
    % Linear vs nonlinear comparisons
    % ================================================================
    if plottingPlan.comparisons.linearVsNonlinear
        for i = 1:numRuns
            linearOperatingPoint = simulationResults(i).linearPlant.metadata.operatingPoint;
            nonlinearOperatingPoint = simulationResults(i).nonlinearPlant.metadata.operatingPoint;

            tolerances = getMoldHeightDeviationTolerances();

            linearVsNonlinearMoldLevelData = struct();

            linearVsNonlinearMoldLevelData.linearTrajectory = struct();
            linearVsNonlinearMoldLevelData.linearTrajectory.x = ...
                simulationResults(i).linearClosedLoopResult.state.x(:, 1);
            linearVsNonlinearMoldLevelData.linearTrajectory.t = ...
                simulationResults(i).linearClosedLoopResult.timestamps;

            linearVsNonlinearMoldLevelData.nonlinearTrajectory = struct();
            linearVsNonlinearMoldLevelData.nonlinearTrajectory.x = ...
                simulationResults(i).nonlinearClosedLoopResult.state.x(:, 1);
            linearVsNonlinearMoldLevelData.nonlinearTrajectory.t = ...
                simulationResults(i).nonlinearClosedLoopResult.timestamps;

            linearVsNonlinearMoldLevelData.hMStarLinear = linearOperatingPoint.hM;
            linearVsNonlinearMoldLevelData.hMStarNonlinear = nonlinearOperatingPoint.hM;
            linearVsNonlinearMoldLevelData.tolerances = tolerances;

            linearVsNonlinearMoldLevelDisplaySpec = struct();
            linearVsNonlinearMoldLevelDisplaySpec.title = ...
                "Linear versus nonlinear mold level trajectory for " + outputPlan.runs(i).runFolderName;
            linearVsNonlinearMoldLevelDisplaySpec.xLabel = "Time";
            linearVsNonlinearMoldLevelDisplaySpec.yLabel = "Mold level (m)";
            linearVsNonlinearMoldLevelDisplaySpec.legendEntries = { ...
                "Linear mold level", ...
                "Nonlinear mold level", ...
                "Linear setpoint", ...
                "Nonlinear setpoint", ...
                "Primary Band", ...
                "Severe Band"};

            linearVsNonlinearMoldLevelPlot = plotLinearVsNonlinearMoldLevelComparison( ...
                linearVsNonlinearMoldLevelData, ...
                linearVsNonlinearMoldLevelDisplaySpec);

            writeFigureToOutput( ...
                linearVsNonlinearMoldLevelPlot, ...
                comparisonTargetDirectory, ...
                "linearVsNonlinearMoldLevel_" + outputPlan.runs(i).runFolderName);
        end
    end

    % ================================================================
    % State feedback vs LQR comparisons
    % ================================================================
    if plottingPlan.comparisons.stateFeedbackVsLQR
        controllerTypes = strings(numRuns, 1);
        observabilityCases = strings(numRuns, 1);
        KValues = zeros(numRuns, 1);

        for i = 1:numRuns
            controllerTypes(i) = string(simulationResults(i).controller.type);
            observabilityCases(i) = string(simulationResults(i).observabilityCase);
            KValues(i) = simulationResults(i).linearPlant.metadata.operatingPoint.K;
        end

        stateFeedbackIndices = find(strcmp(controllerTypes, "stateFeedback"));
        lqrIndices = find(strcmp(controllerTypes, "lqr"));

        usedLQR = false(numRuns, 1);
        comparisonCounter = 0;

        for iStateFeedback = 1:numel(stateFeedbackIndices)
            sfIndex = stateFeedbackIndices(iStateFeedback);

            matchingLQRIndex = [];
            for iLQR = 1:numel(lqrIndices)
                candidateIndex = lqrIndices(iLQR);

                if usedLQR(candidateIndex)
                    continue;
                end

                sameObservability = observabilityCases(candidateIndex) == observabilityCases(sfIndex);
                sameK = KValues(candidateIndex) == KValues(sfIndex);

                if sameObservability && sameK
                    matchingLQRIndex = candidateIndex;
                    break;
                end
            end

            if isempty(matchingLQRIndex)
                continue;
            end

            usedLQR(matchingLQRIndex) = true;
            comparisonCounter = comparisonCounter + 1;

            sfOperatingPoint = simulationResults(sfIndex).linearPlant.metadata.operatingPoint;
            lqrOperatingPoint = simulationResults(matchingLQRIndex).linearPlant.metadata.operatingPoint;
            tolerances = getMoldHeightDeviationTolerances();

            stateFeedbackVsLQRMoldLevelData = struct();

            stateFeedbackVsLQRMoldLevelData.stateFeedbackTrajectory = struct();
            stateFeedbackVsLQRMoldLevelData.stateFeedbackTrajectory.x = ...
                simulationResults(sfIndex).nonlinearClosedLoopResult.state.x(:, 1);
            stateFeedbackVsLQRMoldLevelData.stateFeedbackTrajectory.t = ...
                simulationResults(sfIndex).nonlinearClosedLoopResult.timestamps;

            stateFeedbackVsLQRMoldLevelData.lqrTrajectory = struct();
            stateFeedbackVsLQRMoldLevelData.lqrTrajectory.x = ...
                simulationResults(matchingLQRIndex).nonlinearClosedLoopResult.state.x(:, 1);
            stateFeedbackVsLQRMoldLevelData.lqrTrajectory.t = ...
                simulationResults(matchingLQRIndex).nonlinearClosedLoopResult.timestamps;

            stateFeedbackVsLQRMoldLevelData.hMStarStateFeedback = sfOperatingPoint.hM;
            stateFeedbackVsLQRMoldLevelData.hMStarLQR = lqrOperatingPoint.hM;
            stateFeedbackVsLQRMoldLevelData.tolerances = tolerances;

            stateFeedbackVsLQRMoldLevelDisplaySpec = struct();
            stateFeedbackVsLQRMoldLevelDisplaySpec.title = ...
                "State feedback versus LQR mold level trajectory comparison " + sprintf('%03d', comparisonCounter);
            stateFeedbackVsLQRMoldLevelDisplaySpec.xLabel = "Time";
            stateFeedbackVsLQRMoldLevelDisplaySpec.yLabel = "Mold level (m)";
            stateFeedbackVsLQRMoldLevelDisplaySpec.legendEntries = { ...
                "State feedback mold level", ...
                "LQR mold level", ...
                "State feedback setpoint", ...
                "LQR setpoint", ...
                "Primary Band", ...
                "Severe Band"};

            stateFeedbackVsLQRMoldLevelPlot = plotStateFeedbackVsLQRMoldLevelComparison( ...
                stateFeedbackVsLQRMoldLevelData, ...
                stateFeedbackVsLQRMoldLevelDisplaySpec);

            writeFigureToOutput( ...
                stateFeedbackVsLQRMoldLevelPlot, ...
                comparisonTargetDirectory, ...
                "stateFeedbackVsLQRMoldLevelComparison_" + sprintf('%03d', comparisonCounter));
        end
    end
end