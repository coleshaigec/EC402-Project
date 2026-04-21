function settlingTimeResult = computeSettlingTimeForMoldLevel(x, timestamps, hMStar)
    % COMPUTESETTLINGTIMEFORMOLDLEVEL Computes settling time for mold level. 
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  x (numTimestamps x 2 double)            - simulated state trajectory
    %  timestamps (numTimestamps x 1 double)   - simulation timestamps
    %  hMStar (double)                         - mold level setpoint
    %
    % OUTPUT
    %  settlingTimeResult struct with fields
    %      .settlingTime (double)              - NaN if not settled
    %      .isSettled (logical)
    %
    % NOTES
    % - This utility defines settling time as the first timestamp after
    % which the mold level remains within the settled band for all future
    % time.

    % -- Check whether each sample is within settling threshold --
    settlingThreshold = getSettlingThresholdForMoldLevel();
    errorSignal = x(:, 1) - hMStar;
    outsideSettledBand = abs(errorSignal) > settlingThreshold;

    % -- Find last sojourn outside settled band, if it exists --
    lastOutsideIndex = find(outsideSettledBand, 1, 'last');

    % -- Determine settling time --
    if isempty(lastOutsideIndex)
        settlingTime = timestamps(1);
        isSettled = true;
    else
        settlingTimeIndex = lastOutsideIndex + 1;

        if settlingTimeIndex <= numel(timestamps)
            settlingTime = timestamps(settlingTimeIndex);
            isSettled = true;
        else
            settlingTime = NaN;
            isSettled = false;
        end
    end

    % -- Populate output struct --
    settlingTimeResult = struct();
    settlingTimeResult.settlingTime = settlingTime;
    settlingTimeResult.isSettled = isSettled;
end