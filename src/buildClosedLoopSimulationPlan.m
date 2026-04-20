function simulationPlan = buildClosedLoopSimulationPlan(closedLoopAnalysisPlan)
    % BUILDCLOSEDLOOPSIMULATIONPLAN Constructs plan for single closed-loop simulation run.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %
    % OUTPUT
    %  closedLoopSimulationPlan struct with fields
    %      .evaluator struct with fields
    %          .evaluateStateDerivative (function) - computes xDot(t, x)
    %          .evaluateDisturbance (function) - computes d(t)
    %          .evaluateControlInput (function) - computes control input u(t, x)
    %      .duration (double) - length of simulation
    %      .x0 (2 x 1 double) - initial state
    %


end