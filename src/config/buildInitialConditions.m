function initialConditions = buildInitialConditions()
    % BUILDINITIALCONDITIONS Allows user to hard-code initial conditions for closed-loop simulation.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  initialConditions struct with fields
    %      .x0 (2 x 1 double) - initial state
    %      .xHat0 (2 x 1 double) - initial state estimate
    %
    % NOTES
    % - xHat0 is used for the 'moldOnly' observability case.

    initialConditions = struct();
    initialConditions.x0 = [0.7; 1.7];
    initialConditions.xHat0 = [0.6; 1.8];

end