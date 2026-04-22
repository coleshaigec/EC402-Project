function runObserverPlottingWorkflow(simulationResults, outputPlan, plottingPlan)
    % RUNOBSERVERPLOTTINGWORKFLOW Builds enabled observer plots.
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
    %  Writes enabled observer plots as PNGs to observer directory for each
    %  run that uses partial observability.

    % allRunsMetrics reserved for future observer annotations if needed

    if ~plottingPlan.observer.enabled
        return;
    end

    numRuns = numel(simulationResults);

    for i = 1:numRuns
        % -- Observer plots are only meaningful for partial observability runs --
        if ~strcmp(simulationResults(i).observabilityCase, 'moldOnly')
            continue;
        end

        observerTargetDirectory = outputPlan.runs(i).plotPaths.observerDirectory;

        % ================================================================
        % xHat trajectory plots
        % ================================================================
        if plottingPlan.observer.xHatTrajectory
            % -- Linear plant xHat trajectory --
            linearXHatTrajectoryData = struct();
            linearXHatTrajectoryData.x = simulationResults(i).linearClosedLoopResult.state.x;
            linearXHatTrajectoryData.xHat = simulationResults(i).linearClosedLoopResult.state.xHat;
            linearXHatTrajectoryData.t = simulationResults(i).linearClosedLoopResult.timestamps;

            linearXHatTrajectoryDisplaySpec = struct();
            linearXHatTrajectoryDisplaySpec.title = "True versus estimated state trajectories for linear plant";
            linearXHatTrajectoryDisplaySpec.xLabel = "Time";
            linearXHatTrajectoryDisplaySpec.yLabel = "State value";
            linearXHatTrajectoryDisplaySpec.legendEntries = { ...
                "True mold level", ...
                "Estimated mold level", ...
                "True tundish level", ...
                "Estimated tundish level"};

            linearXHatTrajectoryPlot = plotXHatTrajectory( ...
                linearXHatTrajectoryData, ...
                linearXHatTrajectoryDisplaySpec);

            writeFigureToOutput( ...
                linearXHatTrajectoryPlot, ...
                observerTargetDirectory, ...
                "linearPlantXHatTrajectory");

            % -- Nonlinear plant xHat trajectory --
            nonlinearXHatTrajectoryData = struct();
            nonlinearXHatTrajectoryData.x = simulationResults(i).nonlinearClosedLoopResult.state.x;
            nonlinearXHatTrajectoryData.xHat = simulationResults(i).nonlinearClosedLoopResult.state.xHat;
            nonlinearXHatTrajectoryData.t = simulationResults(i).nonlinearClosedLoopResult.timestamps;

            nonlinearXHatTrajectoryDisplaySpec = struct();
            nonlinearXHatTrajectoryDisplaySpec.title = "True versus estimated state trajectories for nonlinear plant";
            nonlinearXHatTrajectoryDisplaySpec.xLabel = "Time";
            nonlinearXHatTrajectoryDisplaySpec.yLabel = "State value";
            nonlinearXHatTrajectoryDisplaySpec.legendEntries = { ...
                "True mold level", ...
                "Estimated mold level", ...
                "True tundish level", ...
                "Estimated tundish level"};

            nonlinearXHatTrajectoryPlot = plotXHatTrajectory( ...
                nonlinearXHatTrajectoryData, ...
                nonlinearXHatTrajectoryDisplaySpec);

            writeFigureToOutput( ...
                nonlinearXHatTrajectoryPlot, ...
                observerTargetDirectory, ...
                "nonlinearPlantXHatTrajectory");
        end

        % ================================================================
        % Estimation error norm trajectory plots
        % ================================================================
        if plottingPlan.observer.estimationErrorNormTrajectory
            % -- Linear plant estimation error norm trajectory --
            linearEstimationErrorNormData = struct();
            linearEstimationErrorNormData.x = simulationResults(i).linearClosedLoopResult.state.x;
            linearEstimationErrorNormData.xHat = simulationResults(i).linearClosedLoopResult.state.xHat;
            linearEstimationErrorNormData.t = simulationResults(i).linearClosedLoopResult.timestamps;

            linearEstimationErrorNormDisplaySpec = struct();
            linearEstimationErrorNormDisplaySpec.title = "Estimation error norm trajectory for linear plant";
            linearEstimationErrorNormDisplaySpec.xLabel = "Time";
            linearEstimationErrorNormDisplaySpec.yLabel = "Estimation error norm";
            linearEstimationErrorNormDisplaySpec.legendEntries = {"Estimation error norm"};

            linearEstimationErrorNormPlot = plotEstimationErrorNormTrajectory( ...
                linearEstimationErrorNormData, ...
                linearEstimationErrorNormDisplaySpec);

            writeFigureToOutput( ...
                linearEstimationErrorNormPlot, ...
                observerTargetDirectory, ...
                "linearPlantEstimationErrorNormTrajectory");

            % -- Nonlinear plant estimation error norm trajectory --
            nonlinearEstimationErrorNormData = struct();
            nonlinearEstimationErrorNormData.x = simulationResults(i).nonlinearClosedLoopResult.state.x;
            nonlinearEstimationErrorNormData.xHat = simulationResults(i).nonlinearClosedLoopResult.state.xHat;
            nonlinearEstimationErrorNormData.t = simulationResults(i).nonlinearClosedLoopResult.timestamps;

            nonlinearEstimationErrorNormDisplaySpec = struct();
            nonlinearEstimationErrorNormDisplaySpec.title = "Estimation error norm trajectory for nonlinear plant";
            nonlinearEstimationErrorNormDisplaySpec.xLabel = "Time";
            nonlinearEstimationErrorNormDisplaySpec.yLabel = "Estimation error norm";
            nonlinearEstimationErrorNormDisplaySpec.legendEntries = {"Estimation error norm"};

            nonlinearEstimationErrorNormPlot = plotEstimationErrorNormTrajectory( ...
                nonlinearEstimationErrorNormData, ...
                nonlinearEstimationErrorNormDisplaySpec);

            writeFigureToOutput( ...
                nonlinearEstimationErrorNormPlot, ...
                observerTargetDirectory, ...
                "nonlinearPlantEstimationErrorNormTrajectory");
        end
    end
end