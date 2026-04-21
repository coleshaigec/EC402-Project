function absoluteOvershoot = computeAbsoluteMoldLevelOvershoot(x, hMStar)
    % COMPUTEABSOLUTEMOLDLEVELOVERSHOOT Computes absolute overshoot in mold level.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  x (numTimestamps x 2 double) - simulated state trajectory
    %  hMStar (double)              - mold level setpoint
    %
    % OUTPUT
    %  absoluteOvershoot (double)

    errorSignal = x(:, 1) - hMStar;

    firstNonzeroIndex = find(errorSignal ~= 0, 1, 'first');

    % -- Handle degenerate case: trajectory exactly at setpoint throughout --
    if isempty(firstNonzeroIndex)
        absoluteOvershoot = 0;
        return;
    end

    signOfFirstNonzeroErrorTerm = sign(errorSignal(firstNonzeroIndex));

    % -- Determine overshoot based on sign of first nonzero error term --
    if signOfFirstNonzeroErrorTerm > 0
        absoluteOvershoot = max(-errorSignal, 0);
        absoluteOvershoot = max(absoluteOvershoot);
    else
        absoluteOvershoot = max(errorSignal, 0);
        absoluteOvershoot = max(absoluteOvershoot);
    end
end