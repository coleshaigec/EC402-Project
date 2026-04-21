function fractionNearSaturation = computeFractionNearActuatorSaturation(u)
    % COMPUTEFRACTIONNEARACTUATORSATURATION Computes the proportion of samples in which the actuator input is outside the "safe" interior region.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  u (numTimestamps x 2 double) - simulated input trajectory
    %
    % OUTPUT
    %  fractionNearSaturation (double)

    thresholds = getActuatorSaturationThresholds();
    nearSaturation = u(:, 1) > thresholds.upper | u(:, 1) < thresholds.lower;
    fractionNearSaturation = mean(nearSaturation);
end