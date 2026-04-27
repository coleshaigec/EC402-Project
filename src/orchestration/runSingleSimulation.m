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
    %      .controller (string)
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
    % OUTPUT
    %  simulationResult struct with fields
    %      .linearPlant struct with fields
    %          .A (2 x 2 double) - state Jacobian, evaluated at operating point
    %          .B (2 x 2 double) - input Jacobian, evaluated at operating point
    %          .E (2 x 3 double) - disturbance Jacobian, evaluated at operating point
    %          .metadata struct with fields
    %              .operatingPoint struct with fields
    %                  .K        (double)    - plant-specific proportionality constant
    %                  .vW       (double)    - computed withdrawal speed at operating point
    %                  .hT       (double)    - computed tundish height
    %                  .hM       (double)    - prescribed mold height at operating point
    %                  .Qladle   (double)    - computed ladle -> tundish flow rate
    %                  .uM       (double)    - prescribed tundish -> mold flow regulation setting
    %              .plantGeometry struct with fields
    %                  .moldCrossSectionWidth      (double)
    %                  .moldCrossSectionLength     (double)
    %                  .moldCrossSectionalArea     (double)
    %                  .moldAxialLength            (double)
    %                  .nozzleCrossSectionalArea   (double)
    %                  .tundishCrossSectionalArea  (double)
    %              .physicalConstants struct with fields
    %                  .g (double)    - acceleration due to gravity
    %
    %      .nonlinearPlant struct with fields
    %          .f (function handle) - passed into ODE45 as nonlinear dynamics
    %          .metadata struct with fields
    %              .operatingPoint struct with fields
    %                  .K        (double)    - plant-specific proportionality constant
    %                  .vW       (double)    - computed withdrawal speed at operating point
    %                  .hT       (double)    - computed tundish height
    %                  .hM       (double)    - prescribed mold height at operating point
    %                  .Qladle   (double)    - computed ladle -> tundish flow rate
    %                  .uM       (double)    - prescribed tundish -> mold flow regulation setting
    %              .plantGeometry struct with fields
    %                  .moldCrossSectionWidth      (double)
    %                  .moldCrossSectionLength     (double)
    %                  .moldCrossSectionalArea     (double)
    %                  .moldAxialLength            (double)
    %                  .nozzleCrossSectionalArea   (double)
    %                  .tundishCrossSectionalArea  (double)
    %              .physicalConstants struct with fields
    %                  .g (double)    - acceleration due to gravity
    %
    %      .measurementModel struct with fields
    %          .observabilityCase (string) - 'full' or 'moldOnly'
    %          .C (matrix of doubles, size depends on observability case)
    %          .D (2 x 2 double) - zeros here
    %
    %      .openLoopResult struct with fields
    %          .eigenstructure struct with fields
    %              .eigenvalues (2 x 1 double)
    %              .isStable (boolean)
    %    
    %          .controllability struct with fields
    %              .controllabilityMatrix (matrix)
    %              .controllabilityMatrixRank (double)
    %              .isControllable (boolean)
    %    
    %          .observability struct with fields
    %              .observabilityMatrix (matrix)
    %              .observabilityMatrixRank (double)
    %              .isObservable (boolean)
    % 
    %      .controller struct with fields
    %          .type (string) - either 'stateFeedback' or 'lqr'
    %          .gains (2 x 2 double) 
    %          .equilibrium struct with fields
    %              .xe (state equilibrium)
    %              .ue (input equilibrium)
    %          .designMetadata struct with controller-specific fields
    %
    %      .nonlinearClosedLoopResult struct with fields
    %          .timestamps (numTimestamps x 1 double)
    %          .state struct with fields
    %              .x (numTimestamps x 2 double) - simulated state trajectory
    %              .xDot (numTimestamps x 2 double) - simulated state derivative trajectory
    %              .xHat (numTimestamps x 2 double) - state estimate trajectory (only in partial observability case)
    %          .u (numTimestamps x 2 double) - simulated input trajectory
    %          .d (numTimestamps x 3 double) - simulated disturbance trajectory
    %      
    %      .linearClosedLoopResult struct with fields
    %          .timestamps (numTimestamps x 1 double)
    %          .state struct with fields
    %              .x (numTimestamps x 2 double) - simulated state trajectory
    %              .xHat (numTimestamps x 2 double) - state estimate trajectory (only in partial observability case)
    %              .xDot (numTimestamps x 2 double) - simulated state derivative trajectory
    %          .u (numTimestamps x 2 double) - simulated input trajectory
    %          .d (numTimestamps x 3 double) - simulated disturbance trajectory
    %
    %      .observabilityCase (string) - 'full' or 'moldOnly'
    %
    % NOTES
    % - This utility is called by runAllSimulations. The caller will handle
    % reporting and visualization of simulation results. The role of this
    % utility is to execute individual simulations and pass the results
    % upward.
    % - Some branches (LQR and imperfect observability) are not yet implemented and are intended to throw an
    % error when tried.

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

    assert(ismember(simulationPlan.observabilityCase, getObservabilityCases()), 'observabilityCase must be ''full'' or ''moldOnly''');
    observable = strcmp(simulationPlan.observabilityCase, "full");

    % -- Build plant models --
    linearPlant = buildLinearPlant(simulationPlan);
    nonlinearPlant = buildNonlinearPlant(simulationPlan);
    measurementModel = buildMeasurementModel(simulationPlan);
    
    % -- Perform open-loop analysis on linearized plant --
    openLoopResult = runOpenLoopAnalysisForLinearPlant(linearPlant, measurementModel);

    % -- Build controller --
    switch simulationPlan.controller 
        case 'stateFeedback'
            controller = buildStateFeedbackController(linearPlant, simulationPlan.operatingPoint, simulationPlan.controllerParameters);
        case 'lqr'
            controller = buildLQRController(linearPlant);
        otherwise
            error('runSingleSimulation:InvalidFieldValue', ...
                'simulationPlan.controller expected ''lqr'' or ''stateFeedback'', provided %s', ...
                simulationPlan.controller);
    end

    % -- Plan closed-loop analysis --
    closedLoopAnalysisPlan = buildClosedLoopAnalysisPlan(simulationPlan, controller, linearPlant, nonlinearPlant, measurementModel);
    disp(closedLoopAnalysisPlan)
    % -- Simulate controller performance on linearized plant --
    switch simulationPlan.controller 
        case 'stateFeedback'
            if observable
                linearClosedLoopResult = simulateLinearClosedLoopFullState(closedLoopAnalysisPlan.linearPlant);
            else
                error('observer not yet implemented')
            end
            
        case 'lqr'
            if observable
                linearClosedLoopResult = simulateLinearClosedLoopFullState(closedLoopAnalysisPlan.linearPlant);
            else
                error('observer not yet implemented')
            end
        otherwise
            error('runSingleSimulation:InvalidFieldValue', ...
                'simulationPlan.controller expected ''lqr'' or ''stateFeedback'', provided %s', ...
                simulationPlan.controller);
    end

    % -- Simulate controller performance on nonlinear plant --
    switch simulationPlan.controller 
        case 'stateFeedback'
            if observable
                nonlinearClosedLoopResult = simulateNonlinearClosedLoopFullState(closedLoopAnalysisPlan.nonlinearPlant);
            else
                error('observer not yet implemented')
            end
            
        case 'lqr'
             if observable
                nonlinearClosedLoopResult = simulateNonlinearClosedLoopFullState(closedLoopAnalysisPlan.nonlinearPlant);
            else
                error('observer not yet implemented')
            end
        otherwise
            error('runSingleSimulation:InvalidFieldValue', ...
                'simulationPlan.controller expected ''lqr'' or ''stateFeedback'', provided %s', ...
                simulationPlan.controller);
    end

    % -- Amalgamate results for reporting --
    simulationResult = buildTemplateSimulationResultStruct;
    simulationResult.linearPlant = linearPlant;
    simulationResult.nonlinearPlant = nonlinearPlant;
    simulationResult.measurementModel = measurementModel;
    simulationResult.openLoopResult = openLoopResult;
    simulationResult.controller = controller;
    simulationResult.nonlinearClosedLoopResult = nonlinearClosedLoopResult;
    simulationResult.linearClosedLoopResult = linearClosedLoopResult;
    simulationResult.observabilityCase = simulationPlan.observabilityCase;
end