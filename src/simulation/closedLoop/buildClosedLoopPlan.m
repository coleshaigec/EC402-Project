function closedLoopPlan = buildClosedLoopPlan()
    % BUILDCLOSEDLOOPPLAN Defines a configuration for a single closed-loop simulation.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %     
    %
    % OUTPUT
    %  simulatorInput struct with fields
    %      .
    % 

    % What do we need here?
    % - Evaluator
    % - Duration
    % - Initial conditions struct

    % Design case-wise:
    % 1. Linear, full-state
    %    - EvaluateStateDerivative
    %    - EvaluateDisturbance
    %    - EvaluateControlInput
    %
    % 2. Nonlinear, full-state
    %    - EvaluateStateDerivative
    %    - EvaluateDisturbance
    %    - EvaluateControlInput
    %
    % 3. What does the observer need?

    % This is a remarkably big integration job!



    

end