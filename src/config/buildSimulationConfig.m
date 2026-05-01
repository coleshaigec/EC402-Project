function simulationConfig = buildSimulationConfig()
    % BUILDSIMULATIONCONFIG Establishes parameters for simulation configuration.
    %
    % AUTHOR: Cole H. Shaigec

    simulationConfig = struct();

    % -- Nominal plant parameter --
    simulationConfig.kValues = 0.0300;

    % -- LQR comparison run --
    % This run compares the selected pole-placement state-feedback controller
    % against the LQR controller under identical full-state observability and
    % disturbance assumptions.
    simulationConfig.controllers = {"stateFeedback", "lqr"};
    simulationConfig.observabilityCases = {"full"};

    simulationConfig.chosenDisturbanceScenarios = { ...
        "baseline", ...
        "nozzleConstant", ...
        "withdrawalPulse" ...
    };

    simulationConfig.controllerParameters = struct();

    % -- Selected state-feedback controller from Pareto-knee pole sweep --
    simulationConfig.controllerParameters.stateFeedback = struct( ...
        'desiredPoles', {[-0.162; -0.165]} ...
    );

    % -- LQR controller --
    simulationConfig.controllerParameters.lqr = struct();

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % FULL POLE-PLACEMENT SWEEP                                           %
    % Toggle this block back on to replicate the dense state-feedback      %
    % pole-placement sweep used to identify the Pareto-knee pole pair.     %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % simulationConfig.controllers = {"stateFeedback"};
    % simulationConfig.observabilityCases = {"full"};
    %
    % simulationConfig.chosenDisturbanceScenarios = { ...
    %     "baseline", ...
    %     "nozzleConstant", ...
    %     "withdrawalPulse" ...
    % };
    %
    % alphaGrid = linspace(0.05, 1.50, 40);
    % rhoGrid   = linspace(1.02, 4.00, 25);
    %
    % numPolePairs = numel(alphaGrid) * numel(rhoGrid);
    %
    % simulationConfig.controllerParameters = struct();
    % simulationConfig.controllerParameters.stateFeedback = repmat( ...
    %     struct('desiredPoles', []), numPolePairs, 1);
    %
    % counter = 1;
    %
    % for i = 1:numel(alphaGrid)
    %     for j = 1:numel(rhoGrid)
    %         alpha = alphaGrid(i);
    %         rho = rhoGrid(j);
    %
    %         simulationConfig.controllerParameters.stateFeedback(counter).desiredPoles = ...
    %             [-alpha; -rho * alpha];
    %
    %         counter = counter + 1;
    %     end
    % end
end