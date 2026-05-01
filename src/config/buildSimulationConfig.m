function simulationConfig = buildSimulationConfig()
    % BUILDSIMULATIONCONFIG Establishes parameters for simulation configuration.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  simulationConfig struct with fields
    %      .duration (double)
    %      .kValues (vector of doubles) 
    %      .chosenDisturbanceScenarios (1 x N cell array of char vectors or strings)
    %      .controllerParameters struct with fields
    %          .desiredPoles (2 x 1 vector)
    %
    % NOTES
    % - This utility may be used to configure the pipeline for a given
    % experiment run.
    % - Per Thomas (2002), K is a plant-specific constant that is usually
    % estimated from empirical data. 
    % - Since we do not have a concrete physical plant to work with, our
    % approach is to define K as a parameter grid and use simulation to perform
    % a sensitivity analysis across candidate values of K.
    % - A parameter grid in K is defined by centering a sensitivity grid on
    % the value 0.030 m/sqrt(min). This value is an approximation to the one used
    % in Petrus et al. (2020), whose reported thick-slab caster values are of similar order
    % to the representative slab geometry used here.
    % - Since K is a metallurgical constant influenced by many factors beyond 
    % plant geometry (factors which are beyond the scope of this study), we
    % note that our K-values are meant only to be a plausible first
    % approximation.

    simulationConfig = struct();

    % -- Set k-values for simulation --
    % simulationConfig.kValues = [0.0290; 0.0300; 0.0310]; % this is the real one - toggled off for convenience in testing
    simulationConfig.kValues = 0.0300;

    % -- Configure controller(s) --
    % Chosen controllers can be "stateFeedback" and/or "lqr"
    % simulationConfig.controllers = {"stateFeedback", "lqr"}; 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % POLE PLACEMENT TUNING RUN %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % -- Configure controller(s) --
    simulationConfig.controllers = {"stateFeedback"};
    
    % -- State feedback pole sweep --
    alphaGrid = [0.05, 0.10, 0.15, 0.20, 0.30, 0.50];
    rhoGrid   = [1.10, 1.50, 2.00, 2.50, 3.00, 4.00];
    
    numPolePairs = numel(alphaGrid) * numel(rhoGrid);
    
    simulationConfig.controllerParameters.stateFeedback = repmat( ...
        struct('desiredPoles', []), numPolePairs, 1);
    
    counter = 1;
    
    for i = 1:numel(alphaGrid)
        for j = 1:numel(rhoGrid)
            alpha = alphaGrid(i);
            rho = rhoGrid(j);
    
            simulationConfig.controllerParameters.stateFeedback(counter).desiredPoles = ...
                [-alpha; -rho * alpha];
    
            counter = counter + 1;
        end


    end
    simulationConfig.kValues = 0.0300;
    simulationConfig.controllers = {"stateFeedback"};
    simulationConfig.observabilityCases = {"full"};
    simulationConfig.chosenDisturbanceScenarios = { ...
        "baseline", ...
        "nozzleConstant", ...
        "withdrawalPulse" ...
    };
    % -- Keep sweep focused --
    simulationConfig.kValues = 0.0300;
    simulationConfig.observabilityCases = {"full"};
    simulationConfig.chosenDisturbanceScenarios = {"baseline", "nozzleConstant", "withdrawalPulse"};
   

    % -- LQR --
    simulationConfig.controllerParameters.lqr = struct();

    % -- Choose disturbance scenarios --
    % see buildDisturbanceScenarios.m
    % If you don't want any disturbances, populate this with "baseline" only
    simulationConfig.chosenDisturbanceScenarios = {"nozzleConstant", "withdrawalPulse"};

    % -- Choose observability scenarios -- 
    % Choose either 'full' or 'moldOnly'
    simulationConfig.observabilityCases = {"full", "moldOnly"};
end