function safetyViolationResult = checkForSafetyViolations(x, u, plantGeometry, safetyRequirements, operatingPoint)
    % CHECKFORSAFETYVIOLATIONS Evaluates simulation trajectory against safety requirements and physical feasibility to ensure that the controller does not cause a catastrophic incident or do something impossible.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  x (numTimestamps x 2 double) - simulated state trajectory
    % 
    %  u (numTimestamps x 2 double) - simulated input trajectory
    %
    %  plantGeometry struct with fields
    %      .moldCrossSectionWidth      (double)
    %      .moldCrossSectionLength     (double)
    %      .moldCrossSectionalArea     (double)
    %      .moldAxialLength            (double)
    %      .nozzleCrossSectionalArea   (double)
    %      .tundishCrossSectionalArea  (double)
    %
    %  safetyRequirements struct with fields
    %      .safeShellThickness         (double)
    %      .safetyFactor               (double in (0,1])
    %
    %  operatingPoint struct with fields
    %      .K        (double)    - plant-specific proportionality constant
    %      .vW       (double)    - computed withdrawal speed at operating point
    %      .hT       (double)    - computed tundish height
    %      .hM       (double)    - prescribed mold height at operating point
    %      .Qladle   (double)    - computed ladle -> tundish flow rate
    %      .uM       (double)    - prescribed tundish -> mold flow regulation setting
    % 
    % OUTPUTS
    %  safetyViolationResult struct with fields
    %      .hasMoldOverflowOccurred (logical)
    %      .isMoldLevelEverNegative (logical)
    %      .isTundishLevelEverNegative (logical)
    %      .isTrueSafeWithdrawalSpeedEverExceeded (logical)
    %      .isAdjustedSafeWithdrawalSpeedEverExceeded (logical)
    %
    % NOTES
    % - Our plant model assumes that the tundish is a large-capacity
    % container that can absorb significant fluctuations in height without
    % overflow. Thus, we do not check for tundish overflow. 
    % - The "true safe withdrawal speed" represents the theoretical limit
    % on safe withdrawal speed, computed from the safe shell thickness.
    % - The "adjusted safe withdrawal speed" represents this theoretical
    % limit, adjusted downward by the specified safety factor.

    % -- Check for mold overflow --
    hasMoldOverflowOccurred = any(x(:, 1) > plantGeometry.moldAxialLength);

    % -- Check for negative mold and tundish levels --
    isMoldLevelEverNegative = any(x(:, 1) < 0);
    isTundishLevelEverNegative = any(x(:, 2) < 0);

    % -- Compute safe withdrawal-speed bounds --
    trueSafeWithdrawalSpeed = operatingPoint.K^2 ...
        * plantGeometry.moldAxialLength ...
        / safetyRequirements.safeShellThickness^2;

    adjustedSafeWithdrawalSpeed = safetyRequirements.safetyFactor ...
        * trueSafeWithdrawalSpeed;

    % -- Check if safe withdrawal speed is ever exceeded --
    isAdjustedSafeWithdrawalSpeedEverExceeded = any(u(:, 2) > adjustedSafeWithdrawalSpeed);
    isTrueSafeWithdrawalSpeedEverExceeded = any(u(:, 2) > trueSafeWithdrawalSpeed);

    % -- Populate output struct --
    safetyViolationResult = struct();
    safetyViolationResult.hasMoldOverflowOccurred = hasMoldOverflowOccurred;
    safetyViolationResult.isMoldLevelEverNegative = isMoldLevelEverNegative;
    safetyViolationResult.isTundishLevelEverNegative = isTundishLevelEverNegative;
    safetyViolationResult.isTrueSafeWithdrawalSpeedEverExceeded = isTrueSafeWithdrawalSpeedEverExceeded;
    safetyViolationResult.isAdjustedSafeWithdrawalSpeedEverExceeded = isAdjustedSafeWithdrawalSpeedEverExceeded;
end