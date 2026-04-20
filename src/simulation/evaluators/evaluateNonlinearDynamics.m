function xDot = evaluateNonlinearDynamics(x, u, d, plantGeometry, physicalConstants)
    % EVALUATENONLINEARDYNAMICS Evaluates nonlinear plant dynamics for use by ODE45.
    %
    % AUTHOR: Richie Kim/Dani Schwartz
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
    
end


