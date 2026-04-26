function inputTolerances = getInputTolerancesForLQR()
    % GETINPUTTOLERANCESFORLQR Defines acceptable deviations in inputs for use in LQR design.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  inputTolerances struct with fields
    %      .deltaUM (deviation tolerance in [0,1] tundish/mold flow actuator input)
    %      .relativeDeltaVW (percentage deviation tolerance in withdrawal speed)
    %
    % NOTES
    % - Since the input uM is already normalized to [0,1], 0.2 has a
    % meaningful interpretation as a variation magnitude. 
    % - By separation of concerns, the dimensions and structure of the
    % withdrawal speed are abstracted away from this function. The
    % withdrawal speed tolerance returned by this function should thus be
    % interpreted not as a magnitude but instead as a percentage of the
    % safe value. 
    
    inputTolerances = struct();
    inputTolerances.deltaUM = 0.2;
    inputTolerances.relativeDeltaVW = 0.05;  
end