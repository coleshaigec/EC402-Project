function allSimulationParameters = buildSimulationParameterGrids(chosenDisturbanceScenarios)
    % BUILDSIMULATIONPARAMETERGRIDS Builds parameter grids for use in simulation planning.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  simulationConfig struct with fields
    %      .duration (double)
    %      .chosenDisturbanceScenarios (1 x N cell array of char vectors or strings)
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
    %
    % NOTES
    % - Per Thomas (2002), K is a plant-specific constant that is usually
    % estimated from empirical data. 
    % - Since we do not have a concrete physical plant to work with, our
    % approach is to define K as a parameter grid and use simulation to perform
    % a sensitivity analysis across candidate values of K.
    % - A parameter grid in K is defined by centering a sensitivity grid on
    % the value 0.030 m/sqrt(min). This value is an approximation to the one used
    % in Petrus et al. (2020), whose reported thick-slab caster values are of similar order
    % to the representative slab geometry used here.
    % - Since K is a metallurgical constant influenced by many factors beyond 
    % plant geometry (factors which are beyond the scope of this study), we
    % note that our K-values are meant only to be a plausible first
    % approximation.

    % -- Define plant geometry -- 
    plantGeometry = buildPlantGeometry();

    % -- Define safety requirements --
    safetyRequirements = buildSafetyRequirements();

    % -- Define physical constants --
    physicalConstants = buildPhysicalConstants();

    % -- Define baseline disturbances -- 
    baselineDisturbances = buildBaselineDisturbances();

    % -- Define search grid in K --
    Kvalues = [0.0290; 0.0300; 0.0310];

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
end