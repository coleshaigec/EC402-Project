function tableRow = buildTableRowFromRunResults(simulationResult, runMetrics, templateRow, runNumber)
    % BUILDTABLEROWFROMRUNRESULTS Builds row in summary table from run results.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  simulationResult struct - simulation result bundle for a single run
    %  runMetrics struct       - run-level performance metrics for a single run
    %  templateRow struct      - fixed-schema template row
    %  runNumber (double)
    %
    % OUTPUT
    %  tableRow struct         - populated scalar struct matching templateRow schema
    %
    % NOTES
    % - This utility populates a flat summary-table row from nested
    % simulation-result and run-metrics structs.
    % - The template row is used as the fixed schema / single source of
    % truth for field names.
    % - Non-scalar controller gains are serialized using MAT2STR so they
    % can be stored in a flat table column.
    % - Observer metrics are set to NaN when no observer is used.

    % -- Start from fixed schema --
    tableRow = templateRow;

    % -- Pull commonly used metadata --
    linearMetadata = simulationResult.linearPlant.metadata;
    nonlinearMetadata = simulationResult.nonlinearPlant.metadata;

    linearOperatingPoint = linearMetadata.operatingPoint;
    nonlinearOperatingPoint = nonlinearMetadata.operatingPoint;

    linearGeometry = linearMetadata.plantGeometry;
    nonlinearGeometry = nonlinearMetadata.plantGeometry;

    openLoopResult = simulationResult.openLoopResult;
    controller = simulationResult.controller;

    linearMetrics = runMetrics.linear;
    nonlinearMetrics = runMetrics.nonlinear;

    tableRow.runNumber = runNumber;

    % -- Linear plant metadata --
    tableRow.linearPlant_K = linearOperatingPoint.K;
    tableRow.linearPlant_vW = linearOperatingPoint.vW;
    tableRow.linearPlant_hT = linearOperatingPoint.hT;
    tableRow.linearPlant_hM = linearOperatingPoint.hM;
    tableRow.linearPlant_Qladle = linearOperatingPoint.Qladle;
    tableRow.linearPlant_uM = linearOperatingPoint.uM;

    tableRow.linearPlant_moldCSWidth = linearGeometry.moldCrossSectionWidth;
    tableRow.linearPlant_moldCSLength = linearGeometry.moldCrossSectionLength;
    tableRow.linearPlant_moldCSArea = linearGeometry.moldCrossSectionalArea;
    tableRow.linearPlant_moldAxialLength = linearGeometry.moldAxialLength;
    tableRow.linearPlant_nozzleCSArea = linearGeometry.nozzleCrossSectionalArea;
    tableRow.linearPlant_tundishCSArea = linearGeometry.tundishCrossSectionalArea;

    % -- Nonlinear plant metadata --
    tableRow.nonlinearPlant_K = nonlinearOperatingPoint.K;
    tableRow.nonlinearPlant_vW = nonlinearOperatingPoint.vW;
    tableRow.nonlinearPlant_hT = nonlinearOperatingPoint.hT;
    tableRow.nonlinearPlant_hM = nonlinearOperatingPoint.hM;
    tableRow.nonlinearPlant_Qladle = nonlinearOperatingPoint.Qladle;
    tableRow.nonlinearPlant_uM = nonlinearOperatingPoint.uM;

    tableRow.nonlinearPlant_moldCSWidth = nonlinearGeometry.moldCrossSectionWidth;
    tableRow.nonlinearPlant_moldCSLength = nonlinearGeometry.moldCrossSectionLength;
    tableRow.nonlinearPlant_moldCSArea = nonlinearGeometry.moldCrossSectionalArea;
    tableRow.nonlinearPlant_moldAxialLength = nonlinearGeometry.moldAxialLength;
    tableRow.nonlinearPlant_nozzleCSArea = nonlinearGeometry.nozzleCrossSectionalArea;
    tableRow.nonlinearPlant_tundishCSArea = nonlinearGeometry.tundishCrossSectionalArea;

    % -- Open-loop / measurement / controller metadata --
    tableRow.observabilityCase = string(simulationResult.observabilityCase);
    tableRow.openLoopIsStable = openLoopResult.eigenstructure.isStable;
    tableRow.controllabilityMatrixRank = openLoopResult.controllability.controllabilityMatrixRank;
    tableRow.isControllable = openLoopResult.controllability.isControllable;
    tableRow.observabilityMatrixRank = openLoopResult.observability.observabilityMatrixRank;
    tableRow.isObservable = openLoopResult.observability.isObservable;
    tableRow.controllerType = string(controller.type);
    tableRow.controllerGains = string(mat2str(controller.gains));

    % -- Linear closed-loop performance metrics --
    tableRow.linearAbsoluteMoldLevelOvershoot = linearMetrics.absoluteMoldLevelOvershoot;
    tableRow.linearControlEnergy = linearMetrics.controlEnergy;
    tableRow.linearFractionOutsidePrimaryBand = linearMetrics.fractionOutsidePrimaryBand;
    tableRow.linearFractionInSevereBandViolation = linearMetrics.fractionInSevereBandViolation;
    tableRow.linearFractionNearActuatorSaturation = linearMetrics.fractionNearActuatorSaturation;
    tableRow.linearMaxAbsoluteMoldLevelDeviation = linearMetrics.maxAbsoluteMoldLevelDeviation;
    tableRow.linearMoldLevelSettlingTime = linearMetrics.moldLevelSettlingTime.settlingTime;
    tableRow.linearIsMoldLevelSettled = linearMetrics.moldLevelSettlingTime.isSettled;
    tableRow.linearPeakInputDeviationNorm = linearMetrics.peakInputDeviationNorm;
    tableRow.linearMoldLevelSteadyStateError = linearMetrics.moldLevelSteadyStateError;

    tableRow.linearHasMoldOverflowOccurred = linearMetrics.safetyViolations.hasMoldOverflowOccurred;
    tableRow.linearIsMoldLevelEverNegative = linearMetrics.safetyViolations.isMoldLevelEverNegative;
    tableRow.linearIsTundishLevelEverNegative = linearMetrics.safetyViolations.isTundishLevelEverNegative;
    tableRow.linearIsTrueSafeWithdrawalSpeedEverExceeded = ...
        linearMetrics.safetyViolations.isTrueSafeWithdrawalSpeedEverExceeded;
    tableRow.linearIsAdjustedSafeWithdrawalSpeedEverExceeded = ...
        linearMetrics.safetyViolations.isAdjustedSafeWithdrawalSpeedEverExceeded;

    tableRow.linearAnySafetyViolationsOccurred = ...
        tableRow.linearHasMoldOverflowOccurred || ...
        tableRow.linearIsMoldLevelEverNegative || ...
        tableRow.linearIsTundishLevelEverNegative || ...
        tableRow.linearIsTrueSafeWithdrawalSpeedEverExceeded || ...
        tableRow.linearIsAdjustedSafeWithdrawalSpeedEverExceeded;

    % -- Nonlinear closed-loop performance metrics --
    tableRow.nonlinearAbsoluteMoldLevelOvershoot = nonlinearMetrics.absoluteMoldLevelOvershoot;
    tableRow.nonlinearControlEnergy = nonlinearMetrics.controlEnergy;
    tableRow.nonlinearFractionOutsidePrimaryBand = nonlinearMetrics.fractionOutsidePrimaryBand;
    tableRow.nonlinearFractionInSevereBandViolation = nonlinearMetrics.fractionInSevereBandViolation;
    tableRow.nonlinearFractionNearActuatorSaturation = nonlinearMetrics.fractionNearActuatorSaturation;
    tableRow.nonlinearMaxAbsoluteMoldLevelDeviation = nonlinearMetrics.maxAbsoluteMoldLevelDeviation;
    tableRow.nonlinearMoldLevelSettlingTime = nonlinearMetrics.moldLevelSettlingTime.settlingTime;
    tableRow.nonlinearIsMoldLevelSettled = nonlinearMetrics.moldLevelSettlingTime.isSettled;
    tableRow.nonlinearPeakInputDeviationNorm = nonlinearMetrics.peakInputDeviationNorm;
    tableRow.nonlinearMoldLevelSteadyStateError = nonlinearMetrics.moldLevelSteadyStateError;

    tableRow.nonlinearHasMoldOverflowOccurred = nonlinearMetrics.safetyViolations.hasMoldOverflowOccurred;
    tableRow.nonlinearIsMoldLevelEverNegative = nonlinearMetrics.safetyViolations.isMoldLevelEverNegative;
    tableRow.nonlinearIsTundishLevelEverNegative = nonlinearMetrics.safetyViolations.isTundishLevelEverNegative;
    tableRow.nonlinearIsTrueSafeWithdrawalSpeedEverExceeded = ...
        nonlinearMetrics.safetyViolations.isTrueSafeWithdrawalSpeedEverExceeded;
    tableRow.nonlinearIsAdjustedSafeWithdrawalSpeedEverExceeded = ...
        nonlinearMetrics.safetyViolations.isAdjustedSafeWithdrawalSpeedEverExceeded;

    tableRow.nonlinearAnySafetyViolationsOccurred = ...
        tableRow.nonlinearHasMoldOverflowOccurred || ...
        tableRow.nonlinearIsMoldLevelEverNegative || ...
        tableRow.nonlinearIsTundishLevelEverNegative || ...
        tableRow.nonlinearIsTrueSafeWithdrawalSpeedEverExceeded || ...
        tableRow.nonlinearIsAdjustedSafeWithdrawalSpeedEverExceeded;

    % -- Observer metrics --
    if strcmp(simulationResult.observabilityCase, 'moldOnly')
        tableRow.linearMaxEstimationErrorNorm = linearMetrics.observerMetrics.peakEstimationError;
        tableRow.linearFinalEstimationErrorNorm = linearMetrics.observerMetrics.steadyStateEstimationError;

        tableRow.nonlinearMaxEstimationErrorNorm = nonlinearMetrics.observerMetrics.peakEstimationError;
        tableRow.nonlinearFinalEstimationErrorNorm = nonlinearMetrics.observerMetrics.steadyStateEstimationError;
    else
        tableRow.linearMaxEstimationErrorNorm = NaN;
        tableRow.linearFinalEstimationErrorNorm = NaN;
        tableRow.nonlinearMaxEstimationErrorNorm = NaN;
        tableRow.nonlinearFinalEstimationErrorNorm = NaN;
    end
end