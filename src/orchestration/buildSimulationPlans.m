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
    %      .operatingPoints array of structs, each with fields
    %          .K        (double)
    %          .vW       (double)
    %          .hT       (double)
    %          .hM       (double)
    %          .Qladle   (double)
    %          .uM       (double)
    %
    %      .observabilityCases (1 x N cell array of strings/chars)
    %      .controllers (cell array of strings/chars)
    %      .controllerParameters struct with fields
    %          .stateFeedbackController
    %          .lqr
    %
    % OUTPUT
    %  simulationPlans array of structs, each with fields
    %      .operatingPoint
    %      .plantGeometry
    %      .physicalConstants
    %      .safetyRequirements
    %      .observabilityCase
    %      .controllers
    %      .shouldUseNonBaselineDisturbance
    %      .baselineDisturbances
    %      .disturbanceScenario
    %      .controllerParameters
    %
    % NOTES
    % - This utility assigns exactly one operating point to each
    %   simulationPlan.
    % - This utility assigns exactly one disturbance scenario to each
    %   simulationPlan.
    % - This utility assigns exactly one observability case to each
    %   simulationPlan.
    % - simulationPlans are produced as the Cartesian product of the
    %   operatingPoints, disturbanceScenarios, and observabilityCases.
    % - This implementation assumes that operatingPoints and Kvalues are
    %   aligned one-to-one and correspond to the same operating regimes.

    % -- Extract iterable axes --
    operatingPoints = allSimulationParameters.operatingPoints;
    disturbanceScenarios = allSimulationParameters.disturbanceScenarios;
    observabilityCases = allSimulationParameters.observabilityCases;
    Kvalues = allSimulationParameters.Kvalues;

    numOperatingPoints = numel(operatingPoints);
    numDisturbanceScenarios = numel(disturbanceScenarios);
    numObservabilityCases = numel(observabilityCases);

    % -- Validate iterable axes --
    assert(numOperatingPoints >= 1, ...
        'buildSimulationPlans:InvalidOperatingPoints', ...
        'At least one operating point must be provided.');

    assert(numDisturbanceScenarios >= 1, ...
        'buildSimulationPlans:InvalidDisturbanceScenarios', ...
        'At least one disturbance scenario must be provided.');

    assert(numObservabilityCases >= 1, ...
        'buildSimulationPlans:InvalidObservabilityCases', ...
        'At least one observability case must be provided.');

    assert(numel(Kvalues) == numOperatingPoints, ...
        'buildSimulationPlans:DimensionMismatch', ...
        ['Number of K-values must match number of operating points. ', ...
         'Each operating point is assumed to correspond to exactly one K-value.']);

    % -- Build Cartesian product of iterable axes --
    operatingPointIndices = (1:numOperatingPoints).';
    disturbanceScenarioIndices = (1:numDisturbanceScenarios).';
    observabilityCaseIndices = (1:numObservabilityCases).';

    indexTable = combinations( ...
        operatingPointIndices, ...
        disturbanceScenarioIndices, ...
        observabilityCaseIndices ...
    );

    numSimulationPlans = height(indexTable);

    % -- Preallocate output struct array --
    templateSimulationPlan = buildTemplateSimulationPlanStruct();
    simulationPlans = repmat(templateSimulationPlan, numSimulationPlans, 1);

    % -- Populate simulation plans --
    for i = 1:numSimulationPlans
        operatingPointIndex = indexTable{i, 1};
        disturbanceScenarioIndex = indexTable{i, 2};
        observabilityCaseIndex = indexTable{i, 3};

        currentOperatingPoint = operatingPoints(operatingPointIndex);
        currentDisturbanceScenario = disturbanceScenarios(disturbanceScenarioIndex);
        currentObservabilityCase = observabilityCases{observabilityCaseIndex};

        currentPlan = templateSimulationPlan;

        currentPlan.operatingPoint = currentOperatingPoint;
        currentPlan.plantGeometry = allSimulationParameters.plantGeometry;
        currentPlan.physicalConstants = allSimulationParameters.physicalConstants;
        currentPlan.safetyRequirements = allSimulationParameters.safetyRequirements;

        currentPlan.observabilityCase = currentObservabilityCase;
        currentPlan.controllers = allSimulationParameters.controllers;

        currentPlan.baselineDisturbances = allSimulationParameters.baselineDisturbances;
        currentPlan.disturbanceScenario = currentDisturbanceScenario;
        currentPlan.shouldUseNonBaselineDisturbance = ...
            ~strcmp(currentDisturbanceScenario.name, 'baseline');

        currentPlan.controllerParameters = allSimulationParameters.controllerParameters;

        simulationPlans(i) = currentPlan;
    end
end