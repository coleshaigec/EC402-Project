function maxDeviation = computeMaxAbsoluteMoldLevelDeviation(x, hMStar)
    % COMPUTEMAXABSOLUTEMOLDLEVELDEVIATION Computes largest absolute deviation from mold level setpoint.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  x (numTimestamps x 2 double) - simulated state trajectory
    %  hMStar (double)              - mold level setpoint
    %
    % OUTPUT
    %  maxDeviation (double)

    % -- Compute error signal in mold height -- 
    errorSignal = x(:, 1) - hMStar;

    % -- Compute largest deviation --
    maxDeviation = max(abs(errorSignal));
end