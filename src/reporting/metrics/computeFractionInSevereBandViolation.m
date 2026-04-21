function fractionInSevereViolation = computeFractionInSevereBandViolation(x, hMStar)
    % COMPUTEFRACTIONOFSAMPLESOUTSIDEPRIMARYBAND Computes fraction of samples in which mold height is in severe violation of operating band.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  x (numTimestamps x 2 double) - simulated state trajectory
    %  hMStar (double)              - mold level setpoint
    %
    % OUTPUT
    %  fractionInSevereViolation (double)

    tolerances = getMoldHeightDeviationTolerances();
    
    errorSignal = x(:, 1) - hMStar;
    inSevereViolation = abs(errorSignal) > tolerances.severe;

    fractionInSevereViolation = mean(inSevereViolation);
end