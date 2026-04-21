function singleRunPerformanceMetrics = computeSingleRunPerformanceMetrics(simulationResult)
    % COMPUTESINGLERUNPERFORMANCEMETRICS Computes performance metrics for a single simulation run.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  simulationResult struct with fields
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
    %    
    %          .controllability struct with fields
    %              .controllabilityMatrix (matrix)
    %              .controllabilityMatrixRank (double)
    %              .isControllable (boolean)
    %    
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
    %              .xHat (numTimestamps x 2 double) - state estimate trajectory (only in partial observability case)
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
    % OUTPUT
    %  singleRunPerformanceMetrics struct with fields
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
    % NOTES
    % - The semantic meaning of each performance metric is defined within
    % the utility responsible for computing it.

    % -- Compute metrics for linear closed-loop result -
    xLinear = simulationResult.linearClosedLoopResult.state.x;
    uLinear = simulationResult.linearClosedLoopResult.u;
    linearTimestamps = simulationResult.linearClosedLoopResult.timestamps;
    linearOperatingPoint = simulationResult.linearPlant.metadata.operatingPoint;
    
    uStarLinear = [linearOperatingPoint.uM; linearOperatingPoint.vW];

    linearAbsoluteMoldLevelOvershoot = computeAbsoluteMoldLevelOvershoot(xLinear, linearOperatingPoint.hM);
    linearControlEnergy = computeControlEnergy(uLinear, uStarLinear, linearTimestamps);
    linearFractionOutsidePrimaryBand = computeFractionOutsidePrimaryBand(xLinear, linearOperatingPoint.hM);
    linearFractionInSevereBandViolation = computeFractionInSevereBandViolation(xLinear, linearOperatingPoint.hM);
    linearFractionNearActuatorSaturation = computeFractionNearActuatorSaturation(uLinear);
    linearMaxAbsoluteMoldLevelDeviation = computeMaxAbsoluteMoldLevelDeviation(xLinear, linearOperatingPoint.hM);
    linearMoldLevelSettlingTimeResult = computeSettlingTimeForMoldLevel(xLinear, linearTimestamps, linearOperatingPoint.hM);
    linearPeakInputDeviationNorm = computePeakInputDeviationNorm(uLinear, uStarLinear);
    linearMoldLevelSteadyStateError = computeMoldLevelSteadyStateError(xLinear, linearOperatingPoint.hM);
    linearSafetyViolations = checkForSafetyViolations(xLinear, uLinear, ...
        simulationResult.linearPlant.metadata.plantGeometry, buildSafetyRequirements(), ...
        linearOperatingPoint ...
    );

    % -- Compute metrics for nonlinear closed-loop result --
    xNonlinear = simulationResult.nonlinearClosedLoopResult.state.x;
    uNonlinear = simulationResult.nonlinearClosedLoopResult.u;
    nonlinearTimestamps = simulationResult.nonlinearClosedLoopResult.timestamps;
    nonlinearOperatingPoint = simulationResult.nonlinearPlant.metadata.operatingPoint;
    uStarNonlinear = [nonlinearOperatingPoint.uM; nonlinearOperatingPoint.vW];

    nonlinearAbsoluteMoldLevelOvershoot = computeAbsoluteMoldLevelOvershoot(xNonlinear, nonlinearOperatingPoint.hM);
    nonlinearControlEnergy = computeControlEnergy(uNonlinear, uStarNonlinear, nonlinearTimestamps);
    nonlinearFractionOutsidePrimaryBand = computeFractionOutsidePrimaryBand(xNonlinear, nonlinearOperatingPoint.hM);
    nonlinearFractionInSevereBandViolation = computeFractionInSevereBandViolation(xNonlinear, nonlinearOperatingPoint.hM);
    nonlinearFractionNearActuatorSaturation = computeFractionNearActuatorSaturation(uNonlinear);
    nonlinearMaxAbsoluteMoldLevelDeviation = computeMaxAbsoluteMoldLevelDeviation(xNonlinear, nonlinearOperatingPoint.hM);
    nonlinearMoldLevelSettlingTimeResult = computeSettlingTimeForMoldLevel(xNonlinear, nonlinearTimestamps, nonlinearOperatingPoint.hM);
    nonlinearPeakInputDeviationNorm = computePeakInputDeviationNorm(uNonlinear, uStarNonlinear);
    nonlinearMoldLevelSteadyStateError = computeMoldLevelSteadyStateError(xNonlinear, nonlinearOperatingPoint.hM);
    nonlinearSafetyViolations = checkForSafetyViolations(xNonlinear, uNonlinear, ...
        simulationResult.nonlinearPlant.metadata.plantGeometry, buildSafetyRequirements(), ...
        nonlinearOperatingPoint ...
    );
    
    % -- If observer is used, compute relevant metrics --
    % If full-state observability, just return the empty structs
    observerMetrics = struct();
    observerMetrics.nonlinear = struct();
    observerMetrics.linear = struct();

    if strcmp(simulationResult.observabilityCase, 'moldOnly')
        xHatLinear = simulationResult.linearClosedLoopResult.state.xHat;
        xHatNonlinear = simulationResult.nonlinearClosedLoopResult.state.xHat;

        linearPeakEstimationErrorNorm = computePeakEstimationErrorNorm(xLinear, xHatLinear);
        nonlinearPeakEstimationErrorNorm = computePeakEstimationErrorNorm(xNonlinear, xHatNonlinear);

        linearSteadyStateEstimationErrorNorm = computeFinalEstimationErrorNorm(xLinear, xHatLinear);
        nonlinearSteadyStateEstimationErrorNorm = computeFinalEstimationErrorNorm(xNonlinear, xHatNonlinear);

        observerMetrics.linear.peakEstimationError = linearPeakEstimationErrorNorm;
        observerMetrics.linear.steadyStateEstimationError = linearSteadyStateEstimationErrorNorm;

        observerMetrics.nonlinear.peakEstimationError = nonlinearPeakEstimationErrorNorm;
        observerMetrics.nonlinear.steadyStateEstimationError = nonlinearSteadyStateEstimationErrorNorm;
    end

    % -- Populate output struct -- 
    singleRunPerformanceMetrics = struct();

    singleRunPerformanceMetrics.linear = struct();
    singleRunPerformanceMetrics.linear.absoluteMoldLevelOvershoot = linearAbsoluteMoldLevelOvershoot;
    singleRunPerformanceMetrics.linear.controlEnergy = linearControlEnergy;
    singleRunPerformanceMetrics.linear.fractionOutsidePrimaryBand = linearFractionOutsidePrimaryBand;
    singleRunPerformanceMetrics.linear.fractionInSevereBandViolation = linearFractionInSevereBandViolation;
    singleRunPerformanceMetrics.linear.fractionNearActuatorSaturation = linearFractionNearActuatorSaturation;
    singleRunPerformanceMetrics.linear.maxAbsoluteMoldLevelDeviation = linearMaxAbsoluteMoldLevelDeviation;
    singleRunPerformanceMetrics.linear.moldLevelSettlingTime = linearMoldLevelSettlingTimeResult;
    singleRunPerformanceMetrics.linear.peakInputDeviationNorm = linearPeakInputDeviationNorm;
    singleRunPerformanceMetrics.linear.moldLevelSteadyStateError = linearMoldLevelSteadyStateError;
    singleRunPerformanceMetrics.linear.safetyViolations = linearSafetyViolations;
    singleRunPerformanceMetrics.linear.observerMetrics = observerMetrics.linear;
    
    singleRunPerformanceMetrics.nonlinear = struct();
    singleRunPerformanceMetrics.nonlinear.absoluteMoldLevelOvershoot = nonlinearAbsoluteMoldLevelOvershoot;
    singleRunPerformanceMetrics.nonlinear.controlEnergy = nonlinearControlEnergy;
    singleRunPerformanceMetrics.nonlinear.fractionOutsidePrimaryBand = nonlinearFractionOutsidePrimaryBand;
    singleRunPerformanceMetrics.nonlinear.fractionInSevereBandViolation = nonlinearFractionInSevereBandViolation;
    singleRunPerformanceMetrics.nonlinear.fractionNearActuatorSaturation = nonlinearFractionNearActuatorSaturation;
    singleRunPerformanceMetrics.nonlinear.maxAbsoluteMoldLevelDeviation = nonlinearMaxAbsoluteMoldLevelDeviation;
    singleRunPerformanceMetrics.nonlinear.moldLevelSettlingTime = nonlinearMoldLevelSettlingTimeResult;
    singleRunPerformanceMetrics.nonlinear.peakInputDeviationNorm = nonlinearPeakInputDeviationNorm;
    singleRunPerformanceMetrics.nonlinear.moldLevelSteadyStateError = nonlinearMoldLevelSteadyStateError;
    singleRunPerformanceMetrics.nonlinear.safetyViolations = nonlinearSafetyViolations;
    singleRunPerformanceMetrics.nonlinear.observerMetrics = observerMetrics.nonlinear;
end