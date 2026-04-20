function baselineDisturbances = getBaselineDisturbances()
    % GETBASELINEDISTURBANCES Establishes baseline disturbance scenario for simulation.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  baselineDisturbances struct with fields
    %      .baselineDisturbances struct with fields
    %          .dlStar                     (double) 
    %          .dnStar                     (double in [0,1])
    %          .dwStar                     (double)
    %
    % NOTES
    % - Baseline disturbances are assumed to be zero. This scenario
    % represents a standard operating condition. 
    % - Nonzero disturbances may be injected later via disturbance
    % scenarios.

    baselineDisturbances = struct();
    baselineDisturbances.dlStar = 0;
    baselineDisturbances.dnStar = 0;
    baselineDisturbances.dwStar = 0;
end