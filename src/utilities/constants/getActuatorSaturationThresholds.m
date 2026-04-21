function thresholds = getActuatorSaturationThresholds()
    % GETACTUATORSATURATIONTHRESHOLDS Returns near-saturation thresholds for [0,1] tundish -> mold flow control actuator.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  thresholds struct with fields
    %      .upper (double)      - upper "near-saturation threshold"
    %      .lower (double)      - lower "near-saturation threshold"
    %
    % NOTES
    % - Since this actuator is an abstract lumped parameter model, we
    % define the saturation thresholds as arbitrary percentages instead of
    % anchoring them in a particular physical system or other result from
    % the literature.

    thresholds = struct();
    thresholds.upper = 0.95;
    thresholds.lower = 0.05;
end
