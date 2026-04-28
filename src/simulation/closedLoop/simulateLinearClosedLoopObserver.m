function simulationResult = simulateLinearClosedLoopObserver(closedLoopAnalysisPlan)
    % SIMULATELINEARCLOSEDLOOPOBSERVER Simulates linear closed-loop dynamics with Luenberger observer.
    %
    % AUTHOR: Cole H. Shaigec

    evaluator = closedLoopAnalysisPlan.evaluator;
    duration = closedLoopAnalysisPlan.duration;
    x0 = closedLoopAnalysisPlan.initialConditions.x0;
    xHat0 = closedLoopAnalysisPlan.initialConditions.xHat0;

    assert(isequal(size(x0), [2, 1]), 'x0 must be 2 x 1.');
    assert(isequal(size(xHat0), [2, 1]), 'xHat0 must be 2 x 1.');

    z0 = [x0; xHat0];

    odeRHS = @(t, z) evaluator.evaluateAugmentedStateDerivative(t, z);

    tspan = [0, duration];
    [timestamps, zHistory] = ode45(odeRHS, tspan, z0, buildODEOptions());

    xHistory = zHistory(:, 1:2);
    xHatHistory = zHistory(:, 3:4);

    numTimestamps = numel(timestamps);

    xDotHistory = zeros(numTimestamps, 2);
    uHistory = zeros(numTimestamps, 2);
    dHistory = zeros(numTimestamps, 3);

    for i = 1:numTimestamps
        t = timestamps(i);
        x = xHistory(i, :).';
        xHat = xHatHistory(i, :).';

        xDotHistory(i, :) = evaluator.evaluateStateDerivative(t, x, xHat).';
        uHistory(i, :) = evaluator.evaluateControlInput(t, xHat).';
        dHistory(i, :) = evaluator.evaluateDisturbance(t).';
    end

    simulationResult = struct();
    simulationResult.timestamps = timestamps;

    simulationResult.state = struct();
    simulationResult.state.x = xHistory;
    simulationResult.state.xHat = xHatHistory;
    simulationResult.state.xDot = xDotHistory;

    simulationResult.u = uHistory;
    simulationResult.d = dHistory;
    simulationResult.evaluator = evaluator;
end