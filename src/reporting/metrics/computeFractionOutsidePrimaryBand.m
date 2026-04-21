function fractionOutsidePrimaryBand = computeFractionOutsidePrimaryBand(x, hMStar)
    % COMPUTEFRACTIONOFSAMPLESOUTSIDEPRIMARYBAND Computes fraction of samples in which mold height is outside primary acceptable band.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  x (numTimestamps x 2 double) - simulated state trajectory
    %  hMStar (double)              - mold level setpoint
    %
    % OUTPUT
    %  fractionOutsidePrimaryBand (double)

    tolerances = getMoldHeightDeviationTolerances();
    
    errorSignal = x(:, 1) - hMStar;
    outsideBand = abs(errorSignal) > tolerances.primary;

    fractionOutsidePrimaryBand = mean(outsideBand);

end