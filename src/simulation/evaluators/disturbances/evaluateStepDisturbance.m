function d = evaluateStepDisturbance(t, startTime, amplitude)
    % EVALUATESTEPDISTURBANCE Evaluates value of step disturbance at time t.
    %
    % AUTHOR: Cole H. Shaigec
    % 
    % INPUTS
    %  t (double) - time
    %  startTime (double) - step start time
    %  amplitude (double) - step amplitude
    %
    % OUTPUT
    %  d (double) - value of disturbance

    if t >= startTime
        d = amplitude;
    else 
        d = 0;
    end
end