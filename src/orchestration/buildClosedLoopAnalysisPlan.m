function closedLoopAnalysisPlan = buildClosedLoopAnalysisPlan( ...
    simulationPlan, controller, linearPlant, nonlinearPlant, measurementModel)
    % BUILDCLOSEDLOOPANALYSISPLAN Constructs plan for single closed-loop analysis run.
    %
    % AUTHOR: Cole H. Shaigec

    assert(ismember(simulationPlan.observabilityCase, getObservabilityCases()), ...
        'observabilityCase must be ''full'' or ''moldOnly''.');

    isFullStateObservable = strcmp(simulationPlan.observabilityCase, "full");

    disturbanceEvaluator = buildDisturbanceEvaluator(simulationPlan.disturbanceScenario);

    closedLoopAnalysisPlan = struct();
    closedLoopAnalysisPlan.linearPlant = struct();
    closedLoopAnalysisPlan.nonlinearPlant = struct();

    if isFullStateObservable
        linearEvaluator = buildLinearFullStateClosedLoopEvaluator( ...
            linearPlant, ...
            controller, ...
            disturbanceEvaluator);

        nonlinearEvaluator = buildNonlinearFullStateClosedLoopEvaluator( ...
            nonlinearPlant, ...
            controller, ...
            disturbanceEvaluator);

        observer = [];

    else
        observer = buildLuenbergerObserver(linearPlant, measurementModel);

        linearEvaluator = buildLinearObserverClosedLoopEvaluator( ...
            linearPlant, ...
            controller, ...
            observer, ...
            disturbanceEvaluator);

        nonlinearEvaluator = buildNonlinearObserverClosedLoopEvaluator( ...
            nonlinearPlant, ...
            linearPlant, ...
            controller, ...
            observer, ...
            disturbanceEvaluator);
    end

    initialConditions = buildInitialConditions();

    closedLoopAnalysisPlan.linearPlant.evaluator = linearEvaluator;
    closedLoopAnalysisPlan.linearPlant.initialConditions = initialConditions;
    closedLoopAnalysisPlan.linearPlant.duration = getSimulationDuration();

    closedLoopAnalysisPlan.nonlinearPlant.evaluator = nonlinearEvaluator;
    closedLoopAnalysisPlan.nonlinearPlant.initialConditions = initialConditions;
    closedLoopAnalysisPlan.nonlinearPlant.duration = getSimulationDuration();

    closedLoopAnalysisPlan.observer = observer;
end