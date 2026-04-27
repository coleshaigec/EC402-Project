function odeOptions = buildODEOptions()
    % BUILDODEOPTIONS Defines numerical integration settings for closed-loop simulation.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % Please don't change this file

    odeOptions = odeset( ...
        'RelTol', 1e-8, ...
        'AbsTol', 1e-10, ...
        'MaxStep', 1.0);
end