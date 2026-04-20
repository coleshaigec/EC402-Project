function simulationResults = runAllSimulations(simulationPlans)
    % RUNALLSIMULATIONS Executes all planned runs of the simulation pipeline. 
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  simulationPlans array of structs, each with fields
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
    %      .controllers (cell array of strings/chars)
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
    %
    % OUTPUT
    %  simulationResults array of structs, each with fields
    %
    %

    % -- Determine number of simulations to run and preallocate output --
    numSimulationsToRun = numel(simulationPlans);
    templateSimulationResultStruct = buildTemplateSimulationResultStruct();
    simulationResults = repmat(templateSimulationResultStruct, numSimulationsToRun, 1);

    % -- Run simulations and populate result struct --
    for i = 1 : numSimulationsToRun
        simulationResults(i) = runSingleSimulation(simulationPlans(i));
    end


    
end