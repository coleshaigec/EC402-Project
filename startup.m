function startup()
    % STARTUP Orchestrates end-to-end run of simulation and reporting workflows. 
    %
    % AUTHOR: Cole H. Shaigec
    
    % -- Define simulation plans --
    chosenDisturbanceScenarios = {"nozzleDegradationStep", "withdrawalPulse", "ladleFlowStep"};
    allSimulationParameters = buildSimulationParameterGrids(chosenDisturbanceScenarios);
    simulationPlans = buildSimulationPlans(allSimulationParameters);

    % -- Run all simulations --
    allSimulationResults = runAllSimulations(simulationPlans);

    % -- Run reporting workflow --
    reportSimulationResults(allSimulationResults);
end