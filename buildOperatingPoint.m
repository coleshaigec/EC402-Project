function operatingPoint = buildOperatingPoint(plantGeometry, safetyRequirements, k, physicalConstants)
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
    %      .safeSolidificationFront    (double)
    %      .safetyFactor               (double in [0,1])
    %
    %  k (double)
    %
    % OUTPUT
    %  operatingPoint struct with fields
    %      .k        (double)    - plant-specific proportionality constant
    %      .vW       (double)    - computed withdrawal speed at operating point
    %      .hT       (double)    - computed tundish height
    %      .hM       (double)    - prescribed mold height at operating point
    %      .Qladle   (double)    - computed ladle -> tundish flow rate
    %      .uM       (double)    - prescribed tundish -> mold flow regulation setting
    %
    % NOTES
    %  - This function defines and implements operating point policy.
    %  - Withdrawal speed is computed according to the safety factor rule derived
    %  in the report.
    %  - Nominal mold height and uM setting are fixed as hard-coded setpoints.
    %  - To our knowledge, there is no universal formula in the literature
    %  for an optimal mold height setpoint. We thus set the mold height at 75mm from the top. 
    %  This quantity is a loose approximation to a pattern observed in the literature rather 
    %  than the result of any rigorous analysis. 
    %  - Similar reasoning is applied for the uM setpoint.
    %  - Required ladle flow and tundish height are computed by applying
    %  equilibrium conditions to the specified setpoints. 
    %  - This nominal operating point is computed under the assumption that
    %  all disturbances are zero. If desired, nonzero disturbances may be
    %  applied downstream during simulation. 

    % -- Compute allowable withdrawal speed --
    maxAllowableWithdrawalSpeed = k^2 * plantGeometry.moldAxialLength / safetyRequirements.safeSolidificationFront ^ 2; 
    vW = safetyRequirements.safetyFactor * maxAllowableWithdrawalSpeed;

    % -- Apply setpoints for nominal mold height and uM setting --
    uM = 0.9;
    hM = plantGeometry.moldAxialLength - 0.075; % use m as unit of measurement

    % -- Compute ladle flow and tundish height from setpoints using equilibrium conditions -- 
    Qladle = vW * plantGeometry.moldCrossSectionalArea;
    hT = 1/(2*physicalConstants.g) * (vW * plantGeometry.moldCrossSectionalArea / (plantGeometry.nozzleCrossSectionalArea * uM))^2 + hM;

    % -- Populate output struct --
    operatingPoint = struct();
    operatingPoint.k = k;
    operatingPoint.vW = vW;
    operatingPoint.hT = hT;
    operatingPoint.hM = hM;
    operatingPoint.Qladle = Qladle;
    operatingPoint.uM = uM;
end