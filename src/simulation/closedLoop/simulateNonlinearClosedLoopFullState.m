function simulationResult = simulateNonlinearClosedLoopFullState(closedLoopAnalysisPlan)
    % SIMULATELINEARCLOSEDLOOPFULLSTATE Simulates closed-loop dynamics for linear plant with full observability. 
    %
    % AUTHOR: Dani Schwartz
    %
    % INPUT
    %  closedLoopSimulationPlan struct with fields
    %      .evaluator struct with fields
    %          .evaluateStateDerivative (function) - computes xDot(t, x)
    %          .evaluateDisturbance (function) - computes d(t)
    %          .evaluateControlInput (function) - computes control input u(t, x)
    %      .duration (double) - length of simulation
    %      .initialConditions struct with fields
    %           .x0 (2 x 1 double) - initial state
    %
    % OUTPUT
    %  simulationResult struct with fields
    %      .timestamps (numTimestamps x 1 double)
    %      .state struct with fields
    %          .x (numTimestamps x 2 double) - simulated state trajectory
    %          .xDot (numTimestamps x 2 double) - simulated state derivative trajectory
    %      .u (numTimestamps x 2 double) - simulated input trajectory
    %      .d (numTimestamps x 3 double) - simulated disturbance trajectory
    %
    % NOTES
    % - This function uses MATLAB's ODE45 to simulate the behavior of the
    % nonlinear closed-loop system with a given controller, initial condition, and disturbance scenario. 
    % - The system dynamics are packaged into an evaluator utility provided
    % as an input to the function. 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTES FOR IMPLEMENTATION %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % - Please do not delete the docstring above. 
    % - The information needed for you to compute xDot and other required
    % quantities for the simulation is packaged into the provided
    % 'evaluator' utility. All you have to do is call it. 

    % -- YOUR IMPLEMENTATION HERE -- 
    evaluator = closedLoopAnalysisPlan.evaluator;
    duration = closedLoopAnalysisPlan.duration;
    x0 = closedLoopAnalysisPlan.initialConditions.x0;

    odeRHS = @(t,x) evaluator.evaluateStateDerivative(t,x);

    %simulation with ode45
    tspan = [0, duration];
    [timestamps, xHistory] = ode45(odeRHS, tspan, x0);

    numTimestamps = length(timestamps);
    uHistory = zeros(numTimestamps, 2);
    dHistory = zeros(numTimestamps, 3);
    xDotHistory = zeros(numTimestamps, 2);

    for i = 1:numTimestamps
        t = timestamps(i);
        x = xHistory(i, :)';
        uHistory(i,:) = evaluator.evaluateControlInput(t,x)';
        dHistory(i,:) = evaluator.evaluateDisturbance(t)';
        xDotHistory(i,:) = evaluator.evaluateStateDerivative(t,x)';
    end

    simulationResult = struct();
    simulationResult.timestamps = timestamps;
    simulationResult.state = struct();
    simulationResult.state.x = xHistory;
    simulationResult.state.xDot = xDotHistory;
    simulationResult.u = uHistory;
    simulationResult.d = dHistory;

    % Output validation - please do not remove
    validateNonlinearClosedLoopFullStateResult(simulationResult, closedLoopAnalysisPlan);
end