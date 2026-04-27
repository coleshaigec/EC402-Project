function runTrajectoryPlottingWorkflow(simulationResults, allRunsMetrics, outputPlan, plottingPlan);
    % RUNTRAJECTORYPLOTTINGWORKFLOW Plots observed trajectories, if applicable
    %
    % AUTHOR: Cole H. Shaigec
    % 
    % INPUTS
    %  simulationResults array of structs, each with fields
    %      .linearPlant struct with fields
    %          .A (2 x 2 double) - state Jacobian, evaluated at operating point
    %          .B (2 x 2 double) - input Jacobian, evaluated at operating point
    %          .E (2 x 3 double) - disturbance Jacobian, evaluated at operating point
    %          .metadata struct with fields
    %              .operatingPoint struct with fields
    %                  .K        (double)    - plant-specific proportionality constant
    %                  .vW       (double)    - computed withdrawal speed at operating point
    %                  .hT       (double)    - computed tundish height
    %                  .hM       (double)    - prescribed mold height at operating point
    %                  .Qladle   (double)    - computed ladle -> tundish flow rate
    %                  .uM       (double)    - prescribed tundish -> mold flow regulation setting
    %              .plantGeometry struct with fields
    %                  .moldCrossSectionWidth      (double)
    %                  .moldCrossSectionLength     (double)
    %                  .moldCrossSectionalArea     (double)
    %                  .moldAxialLength            (double)
    %                  .nozzleCrossSectionalArea   (double)
    %                  .tundishCrossSectionalArea  (double)
    %              .physicalConstants struct with fields
    %                  .g (double)    - acceleration due to gravity
    %
    %      .nonlinearPlant struct with fields
    %          .f (function handle) - passed into ODE45 as nonlinear dynamics
    %          .metadata struct with fields
    %              .operatingPoint struct with fields
    %                  .K        (double)    - plant-specific proportionality constant
    %                  .vW       (double)    - computed withdrawal speed at operating point
    %                  .hT       (double)    - computed tundish height
    %                  .hM       (double)    - prescribed mold height at operating point
    %                  .Qladle   (double)    - computed ladle -> tundish flow rate
    %                  .uM       (double)    - prescribed tundish -> mold flow regulation setting
    %              .plantGeometry struct with fields
    %                  .moldCrossSectionWidth      (double)
    %                  .moldCrossSectionLength     (double)
    %                  .moldCrossSectionalArea     (double)
    %                  .moldAxialLength            (double)
    %                  .nozzleCrossSectionalArea   (double)
    %                  .tundishCrossSectionalArea  (double)
    %              .physicalConstants struct with fields
    %                  .g (double)    - acceleration due to gravity
    %
    %      .measurementModel struct with fields
    %          .observabilityCase (string) - 'full' or 'moldOnly'
    %          .C (matrix of doubles, size depends on observability case)
    %          .D (2 x 2 double) - zeros here
    %
    %      .openLoopResult struct with fields
    %          .eigenstructure struct with fields
    %              .eigenvalues (2 x 1 double)
    %              .isStable (boolean)
    %          .controllability struct with fields
    %              .controllabilityMatrix (matrix)
    %              .controllabilityMatrixRank (double)
    %              .isControllable (boolean)
    %          .observability struct with fields
    %              .observabilityMatrix (matrix)
    %              .observabilityMatrixRank (double)
    %              .isObservable (boolean)
    % 
    %      .controller struct with fields
    %          .type (string) - either 'stateFeedback' or 'lqr'
    %          .gains (2 x 2 double) 
    %          .equilibrium struct with fields
    %              .xe (state equilibrium)
    %              .ue (input equilibrium)
    %          .designMetadata struct with controller-specific fields
    %
    %      .nonlinearClosedLoopResult struct with fields
    %          .timestamps (numTimestamps x 1 double)
    %          .state struct with fields
    %              .x (numTimestamps x 2 double) - simulated state trajectory
    %              .xDot (numTimestamps x 2 double) - simulated state derivative trajectory
    %          .u (numTimestamps x 2 double) - simulated input trajectory
    %          .d (numTimestamps x 3 double) - simulated disturbance trajectory
    %      
    %      .linearClosedLoopResult struct with fields
    %          .timestamps (numTimestamps x 1 double)
    %          .state struct with fields
    %              .x (numTimestamps x 2 double) - simulated state trajectory
    %              .xHat (numTimestamps x 2 double) - state estimate trajectory (only in partial observability case)
    %              .xDot (numTimestamps x 2 double) - simulated state derivative trajectory
    %          .u (numTimestamps x 2 double) - simulated input trajectory
    %          .d (numTimestamps x 3 double) - simulated disturbance trajectory
    %
    %      .observabilityCase (string) - 'full' or 'moldOnly'
    %
    %  allRunsMetrics array of structs, each with fields
    %      .linear struct with fields
    %          .absoluteMoldLevelOvershoot (double)
    %          .controlEnergy (double)
    %          .fractionOutsidePrimaryBand (double)
    %          .fractionInSevereBandViolation (double)
    %          .fractionNearActuatorSaturation (double)
    %          .maxAbsoluteMoldLevelDeviation (double)
    %          .moldLevelSettlingTime struct with fields
    %              .settlingTime (double)  - NaN if never settled
    %              .isSettled (logical)
    %          .peakInputDeviationNorm (double)
    %          .moldLevelSteadyStateError (double)
    %          .safetyViolations struct with fields
    %              .hasMoldOverflowOccurred (logical)
    %              .isMoldLevelEverNegative (logical)
    %              .isTundishLevelEverNegative (logical)
    %              .isTrueSafeWithdrawalSpeedEverExceeded (logical)
    %              .isAdjustedSafeWithdrawalSpeedEverExceeded (logical)
    %          .observerMetrics struct with simulation-specific fields
    %
    %      .nonlinear struct with fields
    %          .absoluteMoldLevelOvershoot (double)
    %          .controlEnergy (double)
    %          .fractionOutsidePrimaryBand (double)
    %          .fractionInSevereBandViolation (double)
    %          .fractionNearActuatorSaturation (double)
    %          .maxAbsoluteMoldLevelDeviation (double)
    %          .moldLevelSettlingTime struct with fields
    %              .settlingTime (double)  - NaN if never settled
    %              .isSettled (logical)
    %          .peakInputDeviationNorm (double)
    %          .moldLevelSteadyStateError (double)
    %          .safetyViolations struct with fields
    %              .hasMoldOverflowOccurred (logical)
    %              .isMoldLevelEverNegative (logical)
    %              .isTundishLevelEverNegative (logical)
    %              .isTrueSafeWithdrawalSpeedEverExceeded (logical)
    %              .isAdjustedSafeWithdrawalSpeedEverExceeded (logical)
    %          .observerMetrics struct with simulation-specific fields
    %
    %  outputPlan struct with fields
    %      .projectRoot (string)
    %      .outputsRoot (string)
    %      .experimentRoot (string)
    %      .summary struct with fields
    %          .root (string)
    %          .tableDirectory (string)
    %          .tableFileName (string)
    %          .tableFilePath (string)
    %          .plotsDirectory (string) - iff summary plots enabled
    %      .comparisons struct with fields
    %          .root (string)
    %          .plotsDirectory (string) - iff comparison plots enabled
    %      .runsRoot (string)
    %      .runs array of structs, each with fields
    %          .runFolderName (string)
    %          .root (string)
    %          .plotPaths struct with fields
    %              .trajectoriesDirectory (string) - iff trajectory plots enabled
    %              .observerDirectory (string) - iff observer plots enabled
    %              .phasePortraitsDirectory (string) - iff phase portraits enabled
    %
    %  plottingPlan struct with fields
    %      .trajectories struct with fields
    %          .enabled (logical)
    %          .moldLevel (logical)
    %          .tundishLevel (logical)
    %          .input (logical)
    %          .disturbance (logical)
    %      .comparisons struct with fields
    %          .enabled (logical)
    %          .stateFeedbackVsLQR (logical)
    %          .linearVsNonlinear (logical)
    %      .observer struct with fields
    %          .enabled (logical)
    %          .xHatTrajectory (logical)
    %          .estimationErrorNormTrajectory (logical)
    %      .phasePortraits struct with fields
    %          .enabled (logical)
    %          .linear (logical)
    %          .nonlinear (logical)
    %      .summary struct with fields
    %          .enabled (logical)
    %          .fractionOutsidePrimaryBand (logical)
    %          .fractionOutsideSevereBand (logical)
    %          .peakMoldDeviation (logical)
    %          .controlEnergy (logical)
    %          .peakDeviationControlEnergyScatter (logical) 
    % 
    % SIDE EFFECTS
    %  Writes chosen plots (if any) as PNGs to trajectories subfolder in 
    %  outputs directory.

    % -- If trajectory plotting is disabled, exit and do not plot --
    if ~plottingPlan.trajectories.enabled
        return;
    end

    numRuns = numel(simulationResults);

    for i = 1:numRuns
        fprintf('Plotting trajectories for run %i of %i.\n', i, numRuns);
        runOutputPlan = outputPlan.runs(i);
        trajectoriesTargetDirectory = runOutputPlan.plotPaths.trajectoriesDirectory;

        linearOperatingPoint = simulationResults(i).linearPlant.metadata.operatingPoint;
        nonlinearOperatingPoint = simulationResults(i).nonlinearPlant.metadata.operatingPoint;

        % ================================================================
        % Mold level trajectories
        % ================================================================
        if plottingPlan.trajectories.moldLevel
            tolerances = getMoldHeightDeviationTolerances();

            % -- Linear plant mold level trajectory --
            linearMoldLevelTrajectory = struct();
            linearMoldLevelTrajectory.x = simulationResults(i).linearClosedLoopResult.state.x(:, 1);
            linearMoldLevelTrajectory.t = simulationResults(i).linearClosedLoopResult.timestamps;

            linearMoldLevelSetpoints = struct();
            linearMoldLevelSetpoints.hMStar = linearOperatingPoint.hM;
            linearMoldLevelSetpoints.tolerances = tolerances;

            linearMoldLevelDisplaySpec = struct();
            linearMoldLevelDisplaySpec.title = "Mold level trajectory for linear plant";
            linearMoldLevelDisplaySpec.xLabel = "Time";
            linearMoldLevelDisplaySpec.yLabel = "Mold level (m)";
            linearMoldLevelDisplaySpec.legendEntries = {"Mold level", "Setpoint", "Primary Band", "Severe Band"};

            linearMoldLevelPlot = plotMoldLevelTrajectory( ...
                linearMoldLevelTrajectory, ...
                linearMoldLevelSetpoints, ...
                linearMoldLevelDisplaySpec);

            writeFigureToOutput(linearMoldLevelPlot, trajectoriesTargetDirectory, ...
                "linearPlantMoldLevelTrajectory");

            % -- Nonlinear plant mold level trajectory --
            nonlinearMoldLevelTrajectory = struct();
            nonlinearMoldLevelTrajectory.x = simulationResults(i).nonlinearClosedLoopResult.state.x(:, 1);
            nonlinearMoldLevelTrajectory.t = simulationResults(i).nonlinearClosedLoopResult.timestamps;

            nonlinearMoldLevelSetpoints = struct();
            nonlinearMoldLevelSetpoints.hMStar = nonlinearOperatingPoint.hM;
            nonlinearMoldLevelSetpoints.tolerances = tolerances;

            nonlinearMoldLevelDisplaySpec = struct();
            nonlinearMoldLevelDisplaySpec.title = "Mold level trajectory for nonlinear plant";
            nonlinearMoldLevelDisplaySpec.xLabel = "Time";
            nonlinearMoldLevelDisplaySpec.yLabel = "Mold level (m)";
            nonlinearMoldLevelDisplaySpec.legendEntries = {"Mold level", "Setpoint", "Primary Band", "Severe Band"};

            nonlinearMoldLevelPlot = plotMoldLevelTrajectory( ...
                nonlinearMoldLevelTrajectory, ...
                nonlinearMoldLevelSetpoints, ...
                nonlinearMoldLevelDisplaySpec);

            writeFigureToOutput(nonlinearMoldLevelPlot, trajectoriesTargetDirectory, ...
                "nonlinearPlantMoldLevelTrajectory");
        end

        % ================================================================
        % Tundish level trajectories
        % ================================================================
        if plottingPlan.trajectories.tundishLevel
            % -- Linear plant tundish level trajectory --
            linearTundishLevelTrajectory = struct();
            linearTundishLevelTrajectory.x = simulationResults(i).linearClosedLoopResult.state.x(:, 2);
            linearTundishLevelTrajectory.t = simulationResults(i).linearClosedLoopResult.timestamps;

            linearTundishLevelSetpoints = struct();
            linearTundishLevelSetpoints.hTStar = linearOperatingPoint.hT;

            linearTundishLevelDisplaySpec = struct();
            linearTundishLevelDisplaySpec.title = "Tundish level trajectory for linear plant";
            linearTundishLevelDisplaySpec.xLabel = "Time";
            linearTundishLevelDisplaySpec.yLabel = "Tundish level (m)";
            linearTundishLevelDisplaySpec.legendEntries = {"Tundish level", "Setpoint"};

            linearTundishLevelPlot = plotTundishLevelTrajectory( ...
                linearTundishLevelTrajectory, ...
                linearTundishLevelSetpoints, ...
                linearTundishLevelDisplaySpec);

            writeFigureToOutput(linearTundishLevelPlot, trajectoriesTargetDirectory, ...
                "linearPlantTundishLevelTrajectory");

            % -- Nonlinear plant tundish level trajectory --
            nonlinearTundishLevelTrajectory = struct();
            nonlinearTundishLevelTrajectory.x = simulationResults(i).nonlinearClosedLoopResult.state.x(:, 2);
            nonlinearTundishLevelTrajectory.t = simulationResults(i).nonlinearClosedLoopResult.timestamps;

            nonlinearTundishLevelSetpoints = struct();
            nonlinearTundishLevelSetpoints.hTStar = nonlinearOperatingPoint.hT;

            nonlinearTundishLevelDisplaySpec = struct();
            nonlinearTundishLevelDisplaySpec.title = "Tundish level trajectory for nonlinear plant";
            nonlinearTundishLevelDisplaySpec.xLabel = "Time";
            nonlinearTundishLevelDisplaySpec.yLabel = "Tundish level (m)";
            nonlinearTundishLevelDisplaySpec.legendEntries = {"Tundish level", "Setpoint"};

            nonlinearTundishLevelPlot = plotTundishLevelTrajectory( ...
                nonlinearTundishLevelTrajectory, ...
                nonlinearTundishLevelSetpoints, ...
                nonlinearTundishLevelDisplaySpec);

            writeFigureToOutput(nonlinearTundishLevelPlot, trajectoriesTargetDirectory, ...
                "nonlinearPlantTundishLevelTrajectory");
        end

        % ================================================================
        % Input trajectories
        % ================================================================
        if plottingPlan.trajectories.input
            % -- Linear plant input trajectory --
            linearInputTrajectory = struct();
            linearInputTrajectory.u = simulationResults(i).linearClosedLoopResult.u;
            linearInputTrajectory.t = simulationResults(i).linearClosedLoopResult.timestamps;

            linearInputSetpoints = struct();
            linearInputSetpoints.uStar = [linearOperatingPoint.uM; linearOperatingPoint.vW];

            linearInputDisplaySpec = struct();
            linearInputDisplaySpec.title = "Input trajectory for linear plant";
            linearInputDisplaySpec.xLabel = "Time";
            linearInputDisplaySpec.yLabel = "Input value";
            linearInputDisplaySpec.legendEntries = { ...
                "Flow control input", ...
                "Withdrawal speed input", ...
                "Flow control setpoint", ...
                "Withdrawal speed setpoint"};

            linearInputPlot = plotInputVectorTrajectory( ...
                linearInputTrajectory, ...
                linearInputSetpoints, ...
                linearInputDisplaySpec);

            writeFigureToOutput(linearInputPlot, trajectoriesTargetDirectory, ...
                "linearPlantInputTrajectory");

            % -- Nonlinear plant input trajectory --
            nonlinearInputTrajectory = struct();
            nonlinearInputTrajectory.u = simulationResults(i).nonlinearClosedLoopResult.u;
            nonlinearInputTrajectory.t = simulationResults(i).nonlinearClosedLoopResult.timestamps;

            nonlinearInputSetpoints = struct();
            nonlinearInputSetpoints.uStar = [nonlinearOperatingPoint.uM; nonlinearOperatingPoint.vW];

            nonlinearInputDisplaySpec = struct();
            nonlinearInputDisplaySpec.title = "Input trajectory for nonlinear plant";
            nonlinearInputDisplaySpec.xLabel = "Time";
            nonlinearInputDisplaySpec.yLabel = "Input value";
            nonlinearInputDisplaySpec.legendEntries = { ...
                "Flow control input", ...
                "Withdrawal speed input", ...
                "Flow control setpoint", ...
                "Withdrawal speed setpoint"};

            nonlinearInputPlot = plotInputVectorTrajectory( ...
                nonlinearInputTrajectory, ...
                nonlinearInputSetpoints, ...
                nonlinearInputDisplaySpec);

            writeFigureToOutput(nonlinearInputPlot, trajectoriesTargetDirectory, ...
                "nonlinearPlantInputTrajectory");
        end

        % ================================================================
        % Disturbance trajectories
        % ================================================================
        if plottingPlan.trajectories.disturbance
            % -- Linear plant disturbance trajectory --
            linearDisturbanceTrajectory = struct();
            linearDisturbanceTrajectory.d = simulationResults(i).linearClosedLoopResult.d;
            linearDisturbanceTrajectory.t = simulationResults(i).linearClosedLoopResult.timestamps;

            linearDisturbanceDisplaySpec = struct();
            linearDisturbanceDisplaySpec.title = "Disturbance trajectory for linear plant";
            linearDisturbanceDisplaySpec.xLabel = "Time";
            linearDisturbanceDisplaySpec.yLabel = "Disturbance value";
            linearDisturbanceDisplaySpec.legendEntries = { ...
                "Disturbance 1", ...
                "Disturbance 2", ...
                "Disturbance 3"};

            linearDisturbancePlot = plotDisturbanceTrajectory( ...
                linearDisturbanceTrajectory, ...
                linearDisturbanceDisplaySpec);

            writeFigureToOutput(linearDisturbancePlot, trajectoriesTargetDirectory, ...
                "linearPlantDisturbanceTrajectory");

            % -- Nonlinear plant disturbance trajectory --
            nonlinearDisturbanceTrajectory = struct();
            nonlinearDisturbanceTrajectory.d = simulationResults(i).nonlinearClosedLoopResult.d;
            nonlinearDisturbanceTrajectory.t = simulationResults(i).nonlinearClosedLoopResult.timestamps;

            nonlinearDisturbanceDisplaySpec = struct();
            nonlinearDisturbanceDisplaySpec.title = "Disturbance trajectory for nonlinear plant";
            nonlinearDisturbanceDisplaySpec.xLabel = "Time";
            nonlinearDisturbanceDisplaySpec.yLabel = "Disturbance value";
            nonlinearDisturbanceDisplaySpec.legendEntries = { ...
                "Disturbance 1", ...
                "Disturbance 2", ...
                "Disturbance 3"};

            nonlinearDisturbancePlot = plotDisturbanceTrajectory( ...
                nonlinearDisturbanceTrajectory, ...
                nonlinearDisturbanceDisplaySpec);

            writeFigureToOutput(nonlinearDisturbancePlot, trajectoriesTargetDirectory, ...
                "nonlinearPlantDisturbanceTrajectory");
        end
    end
end