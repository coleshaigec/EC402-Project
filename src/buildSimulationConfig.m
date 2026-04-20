function simulationConfig = buildSimulationConfig()
    % BUILDSIMULATIONCONFIG Establishes parameters for simulation configuration.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  simulationConfig struct with fields
    %      .duration (double)
    %      .chosenDisturbanceScenarios (1 x N cell array of char vectors or strings)

    simulationConfig = struct();
    simulationConfig.duration = 1000;
    simulationConfig.chosenDisturbanceScenarios = {"nozzlePulse", "withdrawalStep"};
end