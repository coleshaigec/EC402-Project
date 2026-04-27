function closedLoopAnalysisPlan = buildClosedLoopAnalysisPlan(simulationPlan, controller, linearPlant, nonlinearPlant, measurementModel)
    % BUILDCLOSEDLOOPANALYSISPLAN Constructs plan for single closed-loop analysis run.
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
    %      .disturbanceScenario struct with fields
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
    %      .initialConditions struct with fields
    %          .x0 (2 x 1 double) - initial state
    %          .xHat0 (2 x 1 double) - initial state estimate, empty in non-observable case
    % 
    %
    % OUTPUT
    %  closedLoopAnalysisPlan struct with fields
    %      .linearPlant struct with fields
    %          .evaluator struct with case-specific fields
    %          .duration (double) - length of simulation
    %          .initialConditions struct with case-specific fields
    %      .nonlinearPlant struct with fields
    %          .evaluator struct with case-specific fields
    %          .duration (double) - length of simulation
    %          .initialConditions struct with case-specific fields
    assert(ismember(simulationPlan.observabilityCase, getObservabilityCases()), 'observabilityCase must be ''full'' or ''moldOnly''');
    observable = strcmp(simulationPlan.observabilityCase, "full");
    
    closedLoopAnalysisPlan = struct();
    closedLoopAnalysisPlan.linearPlant = struct();
    closedLoopAnalysisPlan.nonlinearPlant = struct();

    % -- Design of closed-loop analysis plan depends on observability --
    if observable
         disturbanceEvaluator = buildDisturbanceEvaluator(simulationPlan.disturbanceScenario);
         linearEvaluator = buildLinearFullStateClosedLoopEvaluator(linearPlant, ...
             controller, disturbanceEvaluator);
         nonlinearEvaluator = buildNonlinearFullStateClosedLoopEvaluator(nonlinearPlant, controller, disturbanceEvaluator);
    else
        % Will deal with imperfect observability case later -- interface is
        % the same!
    end

    
    % -- Populate output struct --
    closedLoopAnalysisPlan.linearPlant.evaluator = linearEvaluator;
    closedLoopAnalysisPlan.linearPlant.initialConditions = buildInitialConditions();
    closedLoopAnalysisPlan.linearPlant.duration = getSimulationDuration();

    closedLoopAnalysisPlan.nonlinearPlant.evaluator = nonlinearEvaluator;
    closedLoopAnalysisPlan.nonlinearPlant.initialConditions = buildInitialConditions();
    closedLoopAnalysisPlan.nonlinearPlant.duration = getSimulationDuration();
end