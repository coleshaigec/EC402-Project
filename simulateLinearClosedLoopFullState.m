function simulationResult = simulateLinearClosedLoopFullState(closedLoopSimulationPlan)
    % SIMULATELINEARCLOSEDLOOPFULLSTATE Simulates closed-loop dynamics for linear plant with full observability. 
    %
    % AUTHOR: Richie Kim/Dani Schwartz
    %
    % INPUT
    %  closedLoopSimulationPlan struct with fields
    %      .evaluator struct with fields
    %          .evaluateStateDerivative (function) - computes xDot(t, x)
    %          .evaluateDisturbance (function) - computes d(t)
    %          .evaluateControlInput (function) - computes control input u(t, x)
    %      .duration (double) - length of simulation
    %      .x0 (2 x 1 double) - initial state
  
    %
    % OUTPUT
    %  simulationResult struct with fields
    %      .timestamps (numTimestamps x 1 double)
    %      .x (numTimestamps x 2 double) - simulated state trajectory
    %      .xDot (numTimestamps x 2 double) - simulated state derivative trajectory
    %      .u (numTimestamps x 2 double) - simulated input trajectory
    %      .d (numTimestamps x 3 double) - simulated disturbance trajectory
    %
    % NOTES
    % - This function uses MATLAB's ODE45 to simulate the behavior of the
    % linear closed-loop system with a given controller, initial condition, and disturbance scenario. 
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
    simulationResult = struct();
    simulationResult.timestamps = [];
    simulationResult.x = [];
    simulationResult.xDot = [];
    simulationResult.u = [];
    simulationResult.d = [];
  
    

end