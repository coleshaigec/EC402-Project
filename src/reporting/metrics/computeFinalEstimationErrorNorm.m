function finalEstimationErrorNorm = computeFinalEstimationErrorNorm(x, xHat)
    % COMPUTEFINALESTIMATIONERRORNORM Computes final estimation error norm.
    % 
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  x (numTimestamps x 2 double) - simulated state trajectory
    %  xHat (numTimestamps x 2 double) - simulated state estimate trajectory
    %
    % OUTPUT
    %  finalEstimationErrorNorm (double)
    %
    % NOTES
    % - Although this is a finite-time simulation, we assume that the duration is sufficient to
    % use the final estimation error norm as a proxy for steady-state estimation error.

    finalEstimationErrorNorm = norm(x(end, :) - xHat(end, :));
     
end