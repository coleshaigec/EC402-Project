function operatingPoint = buildOperatingPoint(plantGeometry, safetyRequirements, K, physicalConstants)
    % BUILDOPERATINGPOINT Defines operating point for simulation using plant attributes.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
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
    %      .safetyFactor               (double in [0,1])
    %
    %  K (double)
    %
    % OUTPUT
    %  operatingPoint struct with fields
    %      .K        (double)    - plant-specific proportionality constant
    %      .vW       (double)    - computed withdrawal speed at operating point
    %      .hT       (double)    - computed tundish height
    %      .hM       (double)    - prescribed mold height at operating point
    %      .Qladle   (double)    - computed ladle -> tundish flow rate
    %      .uM       (double)    - prescribed tundish -> mold flow regulation setting
    %
    % NOTES
    %  - This function defines and implements operating point policy.
    %  - Nominal mold height, tundish head, and uM setting are fixed as
    %  hard-coded setpoints.
    %  - To our knowledge, there is no universal formula in the literature
    %  for an optimal mold height setpoint. We thus set the mold height at
    %  75mm from the top. This quantity is a loose approximation to a pattern
    %  observed in the literature rather than the result of any rigorous
    %  analysis.
    %  - Similar reasoning is applied for the uM setpoint and nominal tundish
    %  head.
    %  - Required ladle flow and withdrawal speed are computed by applying
    %  equilibrium conditions to the specified setpoints.
    %  - The withdrawal speed implied by these setpoints is checked against
    %  the solidification safety bound derived in the report.
    %  - This nominal operating point is computed under the assumption that
    %  all disturbances are zero. If desired, nonzero disturbances may be
    %  applied downstream during simulation.

    % -- Apply setpoints for nominal mold height, tundish head, and uM setting --
    uM = 0.6;
    hM = plantGeometry.moldAxialLength - 0.075; % use m as unit of measurement
    nominalTundishHead = 1.0;                   % hT - hM, measured in m
    hT = hM + nominalTundishHead;

    % -- Compute compatible steady-state flow and withdrawal speed --
    Qladle = plantGeometry.nozzleCrossSectionalArea ...
        * uM ...
        * sqrt(2 * physicalConstants.g * (hT - hM));

    vW = Qladle / plantGeometry.moldCrossSectionalArea;

    % -- Check solidification safety constraint --
    maxAllowableWithdrawalSpeed = K^2 ...
        * plantGeometry.moldAxialLength ...
        / safetyRequirements.safeShellThickness^2;

    assert(vW <= safetyRequirements.safetyFactor * maxAllowableWithdrawalSpeed, ...
        'buildOperatingPoint:UnsafeWithdrawalSpeed', ...
        ['Computed withdrawal speed violates the safety-factored ', ...
         'solidification speed bound.']);

    % -- Populate output struct --
    operatingPoint = struct();
    operatingPoint.K = K;
    operatingPoint.vW = vW;
    operatingPoint.hT = hT;
    operatingPoint.hM = hM;
    operatingPoint.Qladle = Qladle;
    operatingPoint.uM = uM;

    % -- Store diagnostics for report/debugging traceability - uncomment if needed --
    % operatingPoint.diagnostics = struct();
    % operatingPoint.diagnostics.nominalTundishHead = nominalTundishHead;
    % operatingPoint.diagnostics.maxAllowableWithdrawalSpeed = maxAllowableWithdrawalSpeed;
    % operatingPoint.diagnostics.safetyFactoredWithdrawalSpeedBound = ...
    %     safetyRequirements.safetyFactor * maxAllowableWithdrawalSpeed;
end