function runPhasePortraitWorkflow(simulationResults, outputPlan, plottingPlan)
    % RUNPHASEPORTRAITWORKFLOW Builds enabled phase portrait plots.
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
    %  Writes enabled phase portrait plots as PNGs to phase portraits
    %  directory for each run.

    if ~plottingPlan.phasePortraits.enabled
        return;
    end

    numRuns = numel(simulationResults);

    for i = 1:numRuns
        fprintf('Plotting phase portraits for run %i of %i.\n', i, numRuns);
        phasePortraitTargetDirectory = outputPlan.runs(i).plotPaths.phasePortraitsDirectory;

        linearOperatingPoint = simulationResults(i).linearPlant.metadata.operatingPoint;
        nonlinearOperatingPoint = simulationResults(i).nonlinearPlant.metadata.operatingPoint;

        if plottingPlan.phasePortraits.linear
            linearPhasePortraitData = struct();
            linearPhasePortraitData.x = simulationResults(i).linearClosedLoopResult.state.x;
            linearPhasePortraitData.xe = [linearOperatingPoint.hM; linearOperatingPoint.hT];

            linearPhasePortraitDisplaySpec = struct();
            linearPhasePortraitDisplaySpec.title = "Linear plant phase portrait";
            linearPhasePortraitDisplaySpec.xLabel = "Mold level h_M (m)";
            linearPhasePortraitDisplaySpec.yLabel = "Tundish level h_T (m)";
            linearPhasePortraitDisplaySpec.legendEntries = { ...
                "State trajectory", ...
                "Initial state", ...
                "Final state", ...
                "Equilibrium"};

            linearPhasePortraitPlot = plotLinearPlantPhasePortrait( ...
                linearPhasePortraitData, ...
                linearPhasePortraitDisplaySpec, ...
                simulationResults(i).linearClosedLoopResult.evaluator);

            writeFigureToOutput( ...
                linearPhasePortraitPlot, ...
                phasePortraitTargetDirectory, ...
                "linearPlantPhasePortrait");
        end

        if plottingPlan.phasePortraits.nonlinear
            nonlinearPhasePortraitData = struct();
            nonlinearPhasePortraitData.x = simulationResults(i).nonlinearClosedLoopResult.state.x;
            nonlinearPhasePortraitData.xe = [nonlinearOperatingPoint.hM; nonlinearOperatingPoint.hT];

            nonlinearPhasePortraitDisplaySpec = struct();
            nonlinearPhasePortraitDisplaySpec.title = "Nonlinear plant phase portrait";
            nonlinearPhasePortraitDisplaySpec.xLabel = "Mold level h_M (m)";
            nonlinearPhasePortraitDisplaySpec.yLabel = "Tundish level h_T (m)";
            nonlinearPhasePortraitDisplaySpec.legendEntries = { ...
                "State trajectory", ...
                "Initial state", ...
                "Final state", ...
                "Equilibrium"};

            nonlinearPhasePortraitPlot = plotNonlinearPlantPhasePortrait( ...
                nonlinearPhasePortraitData, ...
                nonlinearPhasePortraitDisplaySpec, ...
                simulationResults(i).nonlinearClosedLoopResult.evaluator);

            writeFigureToOutput( ...
                nonlinearPhasePortraitPlot, ...
                phasePortraitTargetDirectory, ...
                "nonlinearPlantPhasePortrait");
        end
    end
end