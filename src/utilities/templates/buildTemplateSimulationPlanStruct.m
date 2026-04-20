function templateSimulationPlanStruct = buildTemplateSimulationPlanStruct()
    % BUILDTEMPLATESIMULATIONPLANSTRUCT Builds template simulationPlan struct for preallocation.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  templateSimulationPlanStruct struct with fields
    %      .operatingPoint
    %      .plantGeometry
    %      .physicalConstants
    %      .safetyRequirements
    %      .observabilityCase
    %      .controller
    %      .shouldUseNonBaselineDisturbance
    %      .baselineDisturbances
    %      .disturbanceScenario
    %      .controllerParameters

    templateSimulationPlanStruct = struct();
    templateSimulationPlanStruct.operatingPoint = [];
    templateSimulationPlanStruct.plantGeometry = [];
    templateSimulationPlanStruct.physicalConstants = [];
    templateSimulationPlanStruct.safetyRequirements = [];
    templateSimulationPlanStruct.observabilityCase = [];
    templateSimulationPlanStruct.controller = [];
    templateSimulationPlanStruct.shouldUseNonBaselineDisturbance = [];
    templateSimulationPlanStruct.baselineDisturbances = [];
    templateSimulationPlanStruct.disturbanceScenario = [];
    templateSimulationPlanStruct.controllerParameters = [];
end