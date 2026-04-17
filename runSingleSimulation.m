function simulationResult = runSingleSimulation(simulationPlan)
    % RUNSINGLESIMULATION Top-level module that executes full simulation workflow for a single set of parameters.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  simulationPlan struct with fields

    % NOTE TO SELF: simulationPlan must provide plant geometry, K, and all
    % other numbers


    %%%%%%%%%%%%%%%%%%%%
    % DEVELOPMENT NOTE %
    %%%%%%%%%%%%%%%%%%%%
    % If you want to isolate certain portions of the workflow, comment out
    % function calls outside your task's work sequence in this file

    % -- Build plant models --
    linearPlant = buildLinearPlant(simulationPlan);
    nonlinearPlant = buildNonlinearPlant(simulationPlan);

    


    % --  --
    

    % -- 




end