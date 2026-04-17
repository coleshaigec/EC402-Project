function evaluator = buildLinearClosedLoopEvaluator(linearPlant, controller, disturbanceEvaluator)
    % BUILDLINEARCLOSEDLOOPEVALUATOR Builds anonymous function to evaluate linear closed-loop dynamics for ODE45 under full-state observability.
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
    %              .hM       (double)    - prescribed molds height at operating point
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
    %  controller struct with fields
    %      .type (string) - either 'stateFeedback' or 'lqr'
    %      .gains (2 x 2 double) 
    %      .equilibrium struct with fields
    %          .xe (state equilibrium)
    %          .ue (input equilibrium)
    %      .designMetadata struct with controller-specific fields
    %
    %  disturbanceEvaluator (anonymous function)
    %
    % OUTPUTS
    %  evaluator struct with fields
    %      .evaluateStateDerivative (function handle) - computes xDot(t, x)
    %      .evaluateDisturbance (function handle) - computes d(t)
    %      .evaluateControlInput (function handle) - computes control input u(t, x)
    %
    % NOTES
    % - This function assumes that state, input, and disturbance values are supplied in original
    % coordinates, NOT deviation coordinates. It backs out the deviation
    % coordinates from equilibria packaged within its inputs. 


    % -- Extract relevant quantities from inputs --
    A = linearPlant.A;
    B = linearPlant.B;
    E = linearPlant.E;
    
    K = controller.gains;
    xe = controller.equilibrium.xe;
    ue = controller.equilibrium.ue;
    
    % -- Construct evaluators --
    evaluateDisturbance = disturbanceEvaluator;
    
    evaluateControlInput = @(t, x) ue - K * (x - xe);
    
    evaluateStateDerivative = @(t, x) ...
        A * (x - xe) + B * (evaluateControlInput(t, x) - ue) + E * evaluateDisturbance(t);
    
    % -- Package results into output struct --
    evaluator = struct();
    evaluator.evaluateStateDerivative = evaluateStateDerivative;
    evaluator.evaluateControlInput = evaluateControlInput;
    evaluator.evaluateDisturbance = evaluateDisturbance;
end