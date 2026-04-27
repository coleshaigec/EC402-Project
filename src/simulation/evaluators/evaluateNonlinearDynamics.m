function xDot = evaluateNonlinearDynamics(x, u, d, plantGeometry, operatingPoint, physicalConstants)
    % EVALUATENONLINEARDYNAMICS Evaluates nonlinear plant dynamics for use by ODE45.
    %
    % AUTHOR: Dani Schwartz
    %
    % INPUTS
    %  x (2 x 1 double) - state vector
    %  u (2 x 1 double) - input vector
    %  d (3 x 1 double) - disturbance vector
    %
    %  plantGeometry struct with fields
    %      .moldCrossSectionWidth      (double)
    %      .moldCrossSectionLength     (double)
    %      .moldCrossSectionalArea     (double)
    %      .moldAxialLength            (double)
    %      .nozzleCrossSectionalArea   (double)
    %      .tundishCrossSectionalArea  (double)
    %
    %  operatingPoint struct with fields
    %  physicalConstants struct with fields
    %      .g                          (double) - gravity
    %
    % OUTPUTS
    %  xDot (2 x 1 double) - time derivative of state, evaluated at
    %  supplied input

    % -- Extract state --
    hM = x(1);
    hT = x(2);

    % -- Enforce actuator saturation --
    uM = min(max(u(1), 0), 1);
    vW = max(u(2), 0);

    % -- Extract disturbances in canonical form [d_l; d_n; d_w] --
    d_l = d(1); % ladle flow disturbance Qladle + d_l
    d_n = d(2); % nozzle flow degradation (1 - d_n) * Q_TM_nominal
    d_w = d(3); % withdrawal disturbance  (1 + d_w) * vW

    % -- Clamp physically bounded disturbance factors --
    nozzleFlowFactor = min(max(1 - d_n, 0), 1);
    withdrawalFactor = max(1 + d_w, 0);

    % -- Extract geometry and constants --
    AM = plantGeometry.moldCrossSectionalArea;
    AN = plantGeometry.nozzleCrossSectionalArea;
    AT = plantGeometry.tundishCrossSectionalArea;
    g = physicalConstants.g;

    % -- Extract nominal ladle flow from operating point --
    Qladle = operatingPoint.Qladle;

    % -- Compute physically admissible tundish-to-mold flow --
    head = hT - hM;

    if head <= 0
        Q_TM_eff = 0;
    else
        Q_TM_eff = uM * nozzleFlowFactor * AN * sqrt(2 * g * head);
    end

    % -- Nonlinear dynamics --
    hM_dot = (Q_TM_eff - withdrawalFactor * vW * AM) / AM;
    hT_dot = (Qladle + d_l - Q_TM_eff) / AT;

    xDot = [hM_dot; hT_dot];
end