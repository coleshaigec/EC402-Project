function d = evaluatePulseDisturbance(t, startTime, endTime, amplitude)
    % EVALUATEPULSEDISTURBANCE Evaluates value of pulse disturbance at time t. 
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  t (double) - time
    %  startTime (double) - pulse start time
    %  endTime (double) - pulse end time
    %  amplitude (double) - pulse amplitude
    %
    % OUTPUT
    %  d (double) - value of disturbance

    if t >= startTime && t <= endTime
        d = amplitude;
    else 
        d = 0;
    end
end