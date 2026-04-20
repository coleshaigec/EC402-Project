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
    initialConditions.x0 = [1;1];
    initialConditions.xHat0 = [1,1];

end