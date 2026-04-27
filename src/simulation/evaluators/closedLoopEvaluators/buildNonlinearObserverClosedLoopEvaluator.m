function evaluator = buildNonlinearObserverClosedLoopEvaluator( ...
    nonlinearPlant, linearPlant, controller, observer, disturbanceEvaluator)
    % BUILDNONLINEAROBSERVERCLOSEDLOOPEVALUATOR Builds evaluator for nonlinear plant with linear observer.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % NOTES
    % - Actual plant dynamics are nonlinear.
    % - Observer dynamics use the linearized model around the operating point.

    A = linearPlant.A;
    B = linearPlant.B;
    C = observer.measurementModel.C;

    K = controller.gains;
    xe = controller.equilibrium.xe;
    ue = controller.equilibrium.ue;
    L = observer.gain;

    assert(isfield(nonlinearPlant, 'f') && isa(nonlinearPlant.f, 'function_handle'), ...
        'nonlinearPlant.f must be a function handle.');

    assert(isequal(size(A), [2, 2]), 'A must be 2 x 2.');
    assert(isequal(size(B), [2, 2]), 'B must be 2 x 2.');
    assert(isequal(size(K), [2, 2]), 'K must be 2 x 2.');
    assert(isequal(size(xe), [2, 1]), 'xe must be 2 x 1.');
    assert(isequal(size(ue), [2, 1]), 'ue must be 2 x 1.');
    assert(size(C, 2) == 2, 'C must have 2 columns.');
    assert(size(L, 1) == 2 && size(L, 2) == size(C, 1), ...
        'L must be 2 x numMeasurements.');
    assert(isa(disturbanceEvaluator, 'function_handle'), ...
        'disturbanceEvaluator must be a function handle.');

    evaluateDisturbance = @(t) disturbanceEvaluator(t);

    evaluateControlInput = @(t, xHat) ue - K * (xHat - xe);

    evaluateStateDerivative = @(t, x, xHat) nonlinearPlant.f( ...
        x, ...
        evaluateControlInput(t, xHat), ...
        evaluateDisturbance(t));

    evaluateStateEstimateDerivative = @(t, x, xHat) ...
        A * (xHat - xe) ...
        + B * (evaluateControlInput(t, xHat) - ue) ...
        + L * (C * x - C * xHat);

    evaluateAugmentedStateDerivative = @(t, z) [
        evaluateStateDerivative(t, z(1:2), z(3:4));
        evaluateStateEstimateDerivative(t, z(1:2), z(3:4))
    ];

    evaluator = struct();
    evaluator.evaluateAugmentedStateDerivative = evaluateAugmentedStateDerivative;
    evaluator.evaluateStateDerivative = evaluateStateDerivative;
    evaluator.evaluateStateEstimateDerivative = evaluateStateEstimateDerivative;
    evaluator.evaluateControlInput = evaluateControlInput;
    evaluator.evaluateDisturbance = evaluateDisturbance;
end