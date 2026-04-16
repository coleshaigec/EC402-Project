function allSimulationParameters = buildSimulationParameterGrids()
    % BUILDSIMULATIONPARAMETERGRIDS Builds parameter grids for use in simulation planning.
    %
    % AUTHOR: Cole H. Shaigec
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
    %          .dmStar                     (double in [0,1])
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
    %              .dm struct with fields
    %                  .isActive           (boolean)
    %                  .functionalForm     (string)
    %                  .parameters struct with scenario-specific fields
    %              .dw struct with fields
    %                  .isActive           (boolean)
    %                  .functionalForm     (string)
    %                  .parameters struct with scenario-specific fields
    %
    %      .operatingPoints array of structs, each with fields
    %          .k        (double)    - plant-specific proportionality constant
    %          .vW       (double)    - computed withdrawal speed at operating point
    %          .hT       (double)    - computed tundish height
    %          .hM       (double)    - prescribed mold height at operating point
    %          .Qladle   (double)    - computed ladle -> tundish flow rate
    %          .uM       (double)    - prescribed tundish -> mold flow regulation setting



end