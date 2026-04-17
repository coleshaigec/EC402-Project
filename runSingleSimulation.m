function simulationResult = runSingleSimulation(simulationPlan)
    % RUNSINGLESIMULATION Top-level module that executes full simulation workflow for a single set of parameters.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  simulationPlan struct with fields

    % NOTE TO SELF: simulationPlan must provide plant geometry, K, and all
    % other numbers
    %
    % NOTES
    % - This utility is called by runAllSimulations. The caller will handle
    % reporting and visualization of simulation results. The role of this
    % utility is to execute individual simulations and pass the results
    % upward.


    %%%%%%%%%%%%%%%%%%%%
    % DEVELOPMENT NOTE %
    %%%%%%%%%%%%%%%%%%%%
    % If you want to isolate certain portions of the workflow, comment out
    % function calls outside your task's work sequence in this file. Some
    % parts are critical (e.g., plant-building) and should never be
    % commented out, but some can be removed without affecting the
    % analysis. 

    simulationResult = struct();
    simulationResult.results = struct();
    simulationResult.results.stateFeedback = struct();
    simulationResult.results.lqr = struct();
    simulationResult.plants = struct();
    simulationResult.controllers = struct();
    simulationResult.observers = struct();

    % -- Build plant models --
    linearPlant = buildLinearPlant(simulationPlan);
    nonlinearPlant = buildNonlinearPlant(simulationPlan);
    measurementModel = buildMeasurementModel(simulationPlan);

    % -- Perform open-loop analysis on linearized plant --
    openLoopResult = runOpenLoopAnalysisForLinearPlant(linearPlant, measurementModel);

    simulationResult.results.openLoopResult = openLoopResult;

    % -- Build controllers --
    stateFeedbackController = buildStateFeedbackController(linearPlant, measurementModel, simulationPlan);
    linearQuadraticRegulator = buildLQRController(linearPlant, measurementModel, simulationPlan);

    simulationResult.controllers.stateFeedback = stateFeedbackController;
    simulationResult.controllers.lqr = linearQuadraticRegulator;

    % -- Simulate controller performance on linearized plant --
    stateFeedbackLinearClosedLoopResult = runClosedLoopAnalysis(linearPlant, ...
        measurementModel, stateFeedbackController, simulationPlan);
    lqrLinearClosedLoopResult = runClosedLoopAnalysis(linearPlant, ...
        measurementModel, linearQuadraticRegulator, simulationPlan);

    simulationResult.results.stateFeedback.linear = stateFeedbackLinearClosedLoopResult;
    simulationResult.results.lqr.linear = lqrLinearClosedLoopResult;

    % -- Simulate controller performance on full nonlinear plant --
    stateFeedbackNonlinearClosedLoopResult = runClosedLoopAnalysis(nonlinearPlant, ...
        measurementModel, stateFeedbackController, simulationPlan);
    lqrNonlinearClosedLoopResult = runClosedLoopAnalysis(nonlinearPlant, ...
        measurementModel, linearQuadraticRegulator, simulationPlan);

    simulationResult.results.stateFeedback.nonlinear = stateFeedbackNonlinearClosedLoopResult;
    simulationResult.results.lqr.nonlinear = lqrNonlinearClosedLoopResult;

    % -- If partial observability is to be tested, design and simulate observer --
    if strcmp(simulationPlan.observabilityCase, 'moldOnly')
        luenbergerObserver = buildLuenbergerObserver(); % to be architected
        simulationResult.observers.luenberger = luenbergerObserver;

        
    end
end