function allSimulationParameters = buildSimulationParameterGrids(simulationConfig)
    % BUILDSIMULATIONPARAMETERGRIDS Builds parameter grids for use in simulation planning.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  simulationConfig struct with fields
    %      .duration (double)
    %      .chosenDisturbanceScenarios (1 x N cell array of char vectors or strings)
    %      .kValues (1 x numKValues vector)
    %
    % OUTPUT
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

    % -- Define plant geometry -- 
    plantGeometry = buildPlantGeometry();

    % -- Define safety requirements --
    safetyRequirements = buildSafetyRequirements();

    % -- Define physical constants --
    physicalConstants = buildPhysicalConstants();

    % -- Define baseline disturbances -- 
    baselineDisturbances = buildBaselineDisturbances();

    % -- Define search grid in K --
    Kvalues = simulationConfig.kValues;

    % -- Build disturbance scenarios --
    disturbanceScenarios = buildDisturbanceScenarios(simulationConfig.chosenDisturbanceScenarios);

    % -- Build an operating point for each K-value --
    templateOperatingPoint = buildTemplateOperatingPointStruct();
    operatingPoints = repmat(templateOperatingPoint, numel(Kvalues), 1);

    for i = 1 : numel(Kvalues)
        operatingPoints(i) = buildOperatingPoint( ...
            plantGeometry, ...
            safetyRequirements, ...
            Kvalues(i), ...
            physicalConstants ...
        );
    end

    % -- Populate output struct -- 
    allSimulationParameters = struct();
    allSimulationParameters.plantGeometry = plantGeometry;
    allSimulationParameters.physicalConstants = physicalConstants;
    allSimulationParameters.Kvalues = Kvalues;
    allSimulationParameters.safetyRequirements = safetyRequirements;
    allSimulationParameters.baselineDisturbances = baselineDisturbances;
    allSimulationParameters.disturbanceScenarios = disturbanceScenarios;
    allSimulationParameters.operatingPoints = operatingPoints;
    allSimulationParameters.controllerParameters = simulationConfig.controllerParameters;

    error('This is getting called');
    S = allSimulationParameters;
    fields = fieldnames(S);
    for i = 1:length(fields)
        fieldName = fields{i};
        value = S.(fieldName); % Use dynamic field names
        fprintf('%s: ', fieldName);
        disp(value);
    end
end