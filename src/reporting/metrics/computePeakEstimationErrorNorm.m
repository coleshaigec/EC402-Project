function peakEstimationErrorNorm = computePeakEstimationErrorNorm(x, xHat)
    % COMPUTEPEAKESTIMATIONERRORNORM Computes largest estimation error by Euclidean norm.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  x (numTimestamps x 2 double) - simulated state trajectory
    %  xHat (numTimestamps x 2 double) - simulated state estimate trajectory
    %
    % OUTPUT
    %  peakEstimationErrorNorm (double)
    % 
    % NOTES
    % - To my knowledge, there is no convenient MATLAB utility for
    % computing row-level norms of a matrix. This function thus exploits
    % the fact that norm rankings are transitive under squaring, picks the
    % largest squared norm, and returns its square root.

    estimationError = x - xHat;
    estimationErrorRowLevelSquaredNorms = sum(estimationError.^2, 2);
    peakEstimationErrorNorm = sqrt(max(estimationErrorRowLevelSquaredNorms));
end