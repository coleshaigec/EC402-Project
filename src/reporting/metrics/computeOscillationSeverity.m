function oscillationSeverity = computeOscillationSeverity(x, hMStar)
    % COMPUTEOSCILLATIONSEVERITY Sums magnitude of first difference in error signal less net displacement as proxy for oscillation severity.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  x (numTimestamps x 2 double) - simulated state trajectory
    %  hMStar (double)              - mold level setpoint
    %
    % OUTPUT
    %  oscillationSeverity (double)

    % -- Compute error signal in mold height -- 
    errorSignal = x(:, 1) - hMStar;

    % -- Handle pathological edge case gracefully --
    if numel(errorSignal) < 2
        oscillationSeverity = 0;
        return;
    end

    % -- Compute oscillation severity --
    oscillationSeverity = sum(abs(diff(errorSignal))) - abs(errorSignal(end) - e(1));
end