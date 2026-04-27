function evaluator = buildNonlinearFullStateClosedLoopEvaluator( ...
    nonlinearPlant, controller, disturbanceEvaluator)
    % BUILDNONLINEARFULLSTATECLOSEDLOOPEVALUATOR Builds evaluator utility for nonlinear full-state closed-loop simulation.
    %
    % AUTHOR: Cole H. Shaigec


    evaluator = struct();

    evaluator.evaluateDisturbance = @(t) disturbanceEvaluator.evaluate(t);

    evaluator.evaluateControlInput = @(t, x) ...
        controller.evaluateControlInput(t, x);

    evaluator.evaluateStateDerivative = @(t, x) ...
        nonlinearPlant.f(x, ...
            evaluator.evaluateControlInput(t, x), ...
            evaluator.evaluateDisturbance(t));
end