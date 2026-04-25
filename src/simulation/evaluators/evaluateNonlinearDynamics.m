function xDot = evaluateNonlinearDynamics(x, u, d, plantGeometry, physicalConstants)
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
    %  physicalConstants struct with fields
    %      .g                          (double) - gravity
    %
    % OUTPUTS
    %  xDot (2 x 1 double) - time derivative of state, evaluated at
    %  supplied input


    %%%%%%%%%%%%%%%%%%%%%%%%
    % IMPLEMENTATION NOTES %
    %%%%%%%%%%%%%%%%%%%%%%%%
    % Please don't delete the docstring above. 
    %
    % This function is used by ODE45 to simulate the nonlinear plant dynamics.  
    % The full nonlinear state space model used to evaluate xDot is
    % supplied in the project plan document. 

    % -- Your implementation here --
    % state canonical form [hT;hM]
    hT = x(1);
    hM = x(2);

    % input canonical form [uM;vW]
    uM = u(1);
    vW = u(2);

    % disturbances in canonical form [d_l ; d_n; d_w]
    d_l = d(1); %ladle flow disturbance Qladle + d_l
    d_n = d(2); %nozzle flow degradation (1 - d_n) * Q_TM_nominal
    d_w = d(3); %withdrawal disturbance  (1 + d_w) * vW

    AM = plantGeometry.moldCrossSectionalArea;
    AN = plantGeometry.nozzleCrossSectionalArea;
    AT = plantGeometry.tundishCrossSectionalArea;

    % g is a physical constant
    g = physicalConstants.g;

    %nominal ladle flow from operating point --CONSTANT/FIXED
    Qladle = operatingPoint.Qladle;

    %tundish-to-mold flow
    Q_TM_eff = uM * (1-d_n) * AN * sqrt(2*g*(hT-hM));

    %nonlinear dynamics 
    hM_dot = (1/AM) * (Q_TM_eff - (1+d_w) * vW * AM);
    hT_dot = (1/AT) * ((Qladle + d_l) - Q_TM_eff);
    xDot = [hM_dot;hT_dot];
    
end


