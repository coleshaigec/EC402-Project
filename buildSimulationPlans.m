function simulationPlans = buildSimulationPlans(allSimulationParameters)
    % BUILDSIMULATIONPLANS Builds simulation plans for parameter sweeps.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT 
    %  allSimulationParameters struct with fields
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
    %      .Kvalues                        (numKValues x 1 double)
    %       
    %      .safetyRequirements struct with fields
    %          .safeShellThickness         (double)
    %          .safetyFactor               (double in [0,1])
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
    %                  .isActive           (boolean)
    %                  .functionalForm     (string)
    %                  .parameters struct with scenario-specific fields
    %              .dn struct with fields
    %                  .isActive           (boolean)
    %                  .functionalForm     (string)
    %                  .parameters struct with scenario-specific fields
    %              .dw struct with fields
    %                  .isActive           (boolean)
    %                  .functionalForm     (string)
    %                  .parameters struct with scenario-specific fields
    %
    %      .operatingPoints array of structs, each with fields
    %          .K        (double)    - plant-specific proportionality constant
    %          .vW       (double)    - computed withdrawal speed at operating point
    %          .hT       (double)    - computed tundish height
    %          .hM       (double)    - prescribed mold height at operating point
    %          .Qladle   (double)    - computed ladle -> tundish flow rate
    %          .uM       (double)    - prescribed tundish -> mold flow regulation setting
    %
    %
    % OUTPUT 
    %  simulationPlans array of structs, each with fields
    %      .operatingPoint struct with fields
    %          .K        (double)    - plant-specific proportionality constant
    %          .vW       (double)    - computed withdrawal speed at operating point
    %          .hT       (double)    - computed tundish height
    %          .hM       (double)    - prescribed mold height at operating point
    %          .Qladle   (double)    - computed ladle -> tundish flow rate
    %          .uM       (double)    - prescribed tundish -> mold flow regulation setting
    %
    %      .plantGeometry struct with fields
    %          .moldCrossSectionWidth      (double)
    %          .moldCrossSectionLength     (double)
    %          .moldCrossSectionalArea     (double)
    %          .moldAxialLength            (double)
    %          .nozzleCrossSectionalArea   (double)
    %          .tundishCrossSectionalArea  (double)
    %
    %      .observabilityCase (string) - 'full' or 'moldOnly'
    %
    %      .shouldUseNonBaselineDisturbance (boolean) - true iff disturbanceScenario is empty
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
    %                  .isActive           (boolean)
    %                  .functionalForm     (string)
    %                  .parameters struct with scenario-specific fields
    %              .dn struct with fields
    %                  .isActive           (boolean)
    %                  .functionalForm     (string)
    %                  .parameters struct with scenario-specific fields
    %              .dw struct with fields
    %                  .isActive           (boolean)
    %                  .functionalForm     (string)
    %                  .parameters struct with scenario-specific fields
    %
    %      .controllerParameters
    %          .stateFeedbackController
    % 
    %      
    %
    % NOTES
    % - This utility assigns exactly one K-value to each simulationPlan. 
    % - If any non-baseline disturbance scenarios are provided, exactly one
    % disturbance scenario is assigned to each simulationPlan. 
    % - simulationPlans are produced as the Cartesian product of the
    % disturbanceScenarios and K-values


    % -- Determine number of simulations to be run and preallocate output --
    numDisturbanceScenarios = numel(allSimulationParameters.disturbanceScenarios);
    numKValues = numel(allSimulationParameters.Kvalues);
    numSimulationsToRun = numDisturbanceScenarios * numKValues;

    templateSimulationPlan = buildTemplateSimulationPlanStruct();
    simulationPlans = repmat(templateSimulationPlan, numSimulationsToRun, 1);

    % -- Populate simulation plans using Cartesian product --
    












end