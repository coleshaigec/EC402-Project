function evaluator = buildNonlinearFullStateClosedLoopEvaluator(nonlinearPlant, controller, disturbanceEvaluator)
    % BUILDNONLINEARFULLSTATECLOSEDLOOPEVALUATOR Builds utility to evaluate nonlinear closed-loop dynamics for ODE45 under full-state observability.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  nonlinearPlant struct with fields
    %      .f (anonymous function) - passed into ODE45 as nonlinear dynamics
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
    % OUTPUT
    %  evaluator struct with fields
    %      .evaluateStateDerivative (function handle) - computes xDot(t, x)
    %      .evaluateDisturbance (function handle) - computes d(t)
    %      .evaluateControlInput (function handle) - computes u(t, x)

    % -- Nonlinear dynamics utility already baked into plant --
    f = nonlinearPlant.f;

    % -- Extract controller parameters --
    K = controller.gains;
    xe = controller.equilibrium.xe;
    ue = controller.equilibrium.ue;

    % -- Build evaluators --
    evaluateDisturbance = disturbanceEvaluator;
    evaluateControlInput = @(t, x) ue - K * (x - xe);
    evaluateStateDerivative = @(t, x) f(x, evaluateControlInput(t, x), evaluateDisturbance(t));

    % -- Package results into output struct -- 
    evaluator = struct();
    evaluator.evaluateStateDerivative = evaluateStateDerivative;
    evaluator.evaluateControlInput = evaluateControlInput;
    evaluator.evaluateDisturbance = evaluateDisturbance;

end