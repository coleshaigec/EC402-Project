function lqrController = buildLQRController(linearPlant)
    % BUILDLQRCONTROLLER Constructs LQR controller from linearized model. 
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  linearPlant struct with fields
    %      .A (2 x 2 double) - state Jacobian, evaluated at operating point
    %      .B (2 x 2 double) - input Jacobian, evaluated at operating point
    %      .E (2 x 3 double) - disturbance Jacobian, evaluated at operating point
    %      .metadata struct with fields
    %          .operatingPoint struct with fields
    %              .K        (double)    - plant-specific proportionality constant
    %              .vW       (double)    - computed withdrawal speed at operating point
    %              .hT       (double)    - computed tundish height
    %              .hM       (double)    - prescribed mold height at operating point
    %              .Qladle   (double)    - computed ladle -> tundish flow rate
    %              .uM       (double)    - prescribed tundish -> mold flow regulation setting
    %          .plantGeometry struct with fields
    %              .moldCrossSectionWidth      (double)
    %              .moldCrossSectionLength     (double)
    %              .moldCrossSectionalArea     (double)
    %              .moldAxialLength            (double)
    %              .nozzleCrossSectionalArea   (double)
    %              .tundishCrossSectionalArea  (double)
    %          .physicalConstants struct with fields
    %              .g (double)    - acceleration due to gravity
    %
    % 
    % OUTPUTS
    %  lqrController struct with fields
    %      .type (string)              - set to 'lqr'
    %      .gains (2 x 2 double)
    %      .equilibrium struct with fields
    %          .xe (state equilibrium)
    %          .ue (input equilibrium)
    %      .designMetadata struct with fields
    %          .Q (matrix) - state cost weight matrix
    %          .R (matrix) - input cost weight matrix
    %          .placedPoles (2 x 1 double)
    %
    % NOTES
    % - The costs in Q and R are chosen to disproportionately punish
    % fluctuation in mold level and control effort in the withdrawal
    % mechanism, as these are deemed to be of greater operational
    % consequence.
    % - The matrices Q and R are defined to be diagonal, as interactions
    % across states and across control inputs are beyond the scope of this
    % analysis. 
    % - The costs in Q and R are defined via the inverse square of
    % allowable deviation tolerances.

    % -- Extract relevant data from linearPlant --
    operatingPoint = linearPlant.metadata.operatingPoint;

    % -- Get mold deviation tolerance, compute tundish tolerance, and build Q --
    moldHeightTolerances = getMoldHeightDeviationTolerances();
    deltaHM = moldHeightTolerances.primary;
    deltaHT = 10 * deltaHM; % tolerate 10x more variation in tundish level than mold level

    Q = [ 
        1/deltaHM^2, 0;
        0, 1/deltaHT^2
    ];

    % -- Get input tolerances --
    inputTolerances = getInputTolerancesForLQR();
    deltaUM = inputTolerances.deltaUM;
    deltaVW = operatingPoint.vW * inputTolerances.relativeDeltaVW;

    R = [
        1/deltaUM^2, 0;
        0, 1/deltaVW^2
        ];

    % -- Construct LQR controller using MATLAB built-in --
    [K, ~, poles] = lqr(linearPlant.A, linearPlant.B, Q, R);

    % -- Populate output struct --
    lqrController = struct();
    lqrController.type = 'lqr';
    lqrController.gains = K;
    lqrController.equilibrium = getEquilibriumFromOperatingPoint(operatingPoint);
    lqrController.designMetadata = struct();
    lqrController.designMetadata.Q = Q;
    lqrController.designMetadata.R = R;
    lqrController.designMetadata.poles = poles;
end