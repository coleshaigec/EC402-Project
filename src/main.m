function main()
    % MAIN Runs end-to-end simulation workflow. 
    %
    % AUTHOR: Cole H. Shaigec

    % -- Build simulation plans --
    simulationConfig = buildSimulationConfig();
    disp(simulationConfig.controllerParameters)
    allSimulationParameters = buildSimulationParameterGrids(simulationConfig);
    simulationPlans = buildSimulationPlans(allSimulationParameters);
    
    
    % -- Run all simulations -- 
    simulationResults = runAllSimulations(simulationPlans);


    % -- Pass results through reporting layer --

end