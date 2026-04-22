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

    % -- Proceed plot-wise through trajectories at run level --
    numRuns = numel(simulationResults);

    

    for i = 1 : numRuns
        runOutputPlan = outputPlan.runs(i);
        trajectoriesTargetDirectory = runOutputPlan.plotPaths.trajectoriesDirectory;

        if plottingPlan.trajectories.moldLevel
            % -- Plot mold level trajectory for linear plant -- 
            % Extract setpoints
            linearPlantMoldLevelSetpoints = struct();
            linearPlantMoldLevelSetpoints.hMStar = simulationResults(i).linearPlant.metadata.operatingPoint.hM;
            linearPlantMoldLevelSetpoints.tolerances = getMoldHeightDeviationTolerances();

            % Package trajectory into struct
            linearPlantMoldLevelTrajectory = struct();
            linearPlantMoldLevelTrajectory.x = simulationResults(i).linearClosedLoopResult.state.x(:,1);
            linearPlantMoldLevelTrajectory.t = simulationResults(i).linearClosedLoopResult.timestamps;

            % Establish display specifications
            linearPlantMoldLevelTrajectoryDisplaySpec = struct();
            linearPlantMoldLevelTrajectoryDisplaySpec.title = 'Mold level trajectory for linear plant';
            linearPlantMoldLevelTrajectoryDisplaySpec.xLabel = 'Time';
            linearPlantMoldLevelTrajectoryDisplaySpec.yLabel = 'Mold level (m)';
            linearPlantMoldLevelTrajectoryDisplaySpec.legendEntries = {"Mold level", "Setpoint", "Primary Band", "Severe Band"};
            
            % Build plot and write to file
            linearPlantMoldLevelTrajectoryPlot = plotMoldLevelTrajectory(linearPlantMoldLevelTrajectory, ...
                linearPlantMoldLevelSetpoints, linearPlantMoldLevelTrajectoryDisplaySpec);

            writeFigureToOutput(linearPlantMoldLevelTrajectoryPlot, trajectoriesTargetDirectory, 'linearPlantMoldLevelTrajectory');

            % -- Plot mold level trajectory for nonlinear plant --
            moldLevelSetpoints.hMStarNonlinearPlant = simulationResults(i).nonlinearPlant.metadata.operatingPoint.hM;
            nonlinearMoldLevelTrajectoryPlot = plotMoldLevelTrajectory();
        end
    end


end