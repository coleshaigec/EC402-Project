function baselineDisturbances = buildBaselineDisturbances()
    % BUILDBASELINEDISTURBANCES Establishes baseline disturbance scenario for simulation.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  baselineDisturbances struct with fields
    %      .baselineDisturbances struct with fields
    %          .dlStar                     (double) 
    %          .dmStar                     (double in [0,1])
    %          .dwStar                     (double)
    %
    % NOTES
    % - Baseline disturbances are assumed to be zero. This scenario
    % represents a standard operating condition. 
    % - Nonzero disturbances may be injected later via disturbance
    % scenarios.

    baselineDisturbances = struct();
    baselineDisturbances.dlStar = 0;
    baselineDisturbances.dmStar = 0;
    baselineDisturbances.dwStar = 0;
end