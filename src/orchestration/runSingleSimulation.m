function simulationResult = runSingleSimulation(simulationPlan)
    % RUNSIMULATIONPIPELINE Top-level module that executes full simulation workflow for a single set of parameters.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  simulationPlan struct with fields
    %      .operatingPoint struct with fields
    %          .K        (double)
    %          .vW       (double)
    %          .hT       (double)
    %          .hM       (double)
    %          .Qladle   (double)
    %          .uM       (double)'
    %
    %      .plantGeometry struct with fields
    %          .moldCrossSectionWidth      (double)
    %          .moldCrossSectionLength     (double)
    %          .moldCrossSectionalArea     (double)
    %          .moldAxialLength            (double)
    %          .nozzleCrossSectionalArea   (double)
    %          .tundishCrossSectionalArea  (double)
    %
    %      .physicalConstants struct with fields
    %          .g                          (double) - gravity
    %
    %      .safetyRequirements struct with fields
    %          .safeShellThickness         (double)
    %          .safetyFactor               (double in [0,1])
    %
    %      .observabilityCase (string)
    %
    %      .controllers (string/chars)
    %
    %      .shouldUseNonBaselineDisturbance (boolean)
    %
    %      .baselineDisturbances struct with fields
    %          .dlStar                     (double)
    %          .dnStar                     (double in [0,1])
    %          .dwStar                     (double)
    %
    %      .disturbanceScenarios array of structs with fields
    %          .name
    %          .descriptionString
    %          .shouldApplyToLinearPlant
    %          .shouldApplyToNonlinearPlant
    %          .channels struct with fields
    %              .dl struct with fields
    %                  .isActive
    %                  .functionalForm
    %                  .parameters
    %              .dn struct with fields
    %                  .isActive
    %                  .functionalForm
    %                  .parameters
    %              .dw struct with fields
    %                  .isActive
    %                  .functionalForm
    %                  .parameters
    %
    %      .controllerParameters struct with fields
    %          .stateFeedbackController
    %          .lqr
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
    
    % -- DEBUGGING - REMOVE ON DEPLOY - Print all fields and values in plan
    % S = simulationPlan;
    % fields = fieldnames(S);
    % for i = 1:length(fields)
    %     fieldName = fields{i};
    %     value = S.(fieldName); % Use dynamic field names
    %     fprintf('%s: ', fieldName);
    %     disp(value);
    % end

    simulationResult = buildTemplateSimulationResultStruct();

    % -- Build plant models --
    linearPlant = buildLinearPlant(simulationPlan);
    nonlinearPlant = buildNonlinearPlant(simulationPlan);
    measurementModel = buildMeasurementModel(simulationPlan);
    
    % -- Perform open-loop analysis on linearized plant --
    openLoopResult = runOpenLoopAnalysisForLinearPlant(linearPlant, measurementModel);
    assignin('base', 'openLoopResult', openLoopResult); 

    simulationResult.results.openLoopResult = openLoopResult;

    % -- Build controller --
    switch simulationPlan.controller 
        case 'stateFeedback'
            simulationPlan.controllerParameters
            controller = buildStateFeedbackController(linearPlant, simulationPlan.controllerParameters);
        case 'lqr'
            controller = buildLQR(linearPlant, simulationPlan.controllerParameters);
        otherwise
            error('runSingleSimulation:InvalidFieldValue', ...
                'simulationPlan.controller expected ''lqr'' or ''stateFeedback'', provided %s', ...
                simulationPlan.controller);
    end

    simulationResult.controller = controller;

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