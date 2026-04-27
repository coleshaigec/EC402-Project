function nonlinearPlant = buildNonlinearPlant(simulationPlan)
    % BUILDNONLINEARPLANT Uses simulation plan to encode full nonlinear plant model for pipeline run.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  simulationPlan struct with fields
    %      .operatingPoint struct with fields
    %          .K        (double)    - plant-specific proportionality constant
    %          .vW       (double)    - computed withdrawal speed at operating point
    %          .hT       (double)    - computed tundish height
    %          .hM       (double)    - prescribed mold height at operating point
    %          .Qladle   (double)    - computed ladle -> tundish flow rate
    %          .uM       (double)    - prescribed tundish -> mold flow regulation setting
    %      .plantGeometry struct with fields
    %          .moldCrossSectionWidth      (double)
    %          .moldCrossSectionLength     (double)
    %          .moldCrossSectionalArea     (double)
    %          .moldAxialLength            (double)
    %          .nozzleCrossSectionalArea   (double)
    %          .tundishCrossSectionalArea  (double)
    %     .physicalConstants struct with fields
    %          .g (double)    - acceleration due to gravity
    %
    % OUTPUT
    %  nonlinearPlant struct with fields
    %      .f (function handle) - passed into ODE45 as nonlinear dynamics
    %      .metadata struct with fields
    %          .operatingPoint struct with fields
    %              .K        (double)    - plant-specific proportionality constant
    %              .vW       (double)    - computed withdrawal speed at operating point
    %              .hT       (double)    - computed tundish height
    %              .hM       (double)    - prescribed mold height at operating point
    %              .Qladle   (double)    - computed ladle -> tundish flow rate
    %              .uM       (double)    - prescribed tundish -> mold flow regulation setting
    %          .plantGeometry struct with fields
    %              .moldCrossSectionWidth      (double)
    %              .moldCrossSectionLength     (double)
    %              .moldCrossSectionalArea     (double)
    %              .moldAxialLength            (double)
    %              .nozzleCrossSectionalArea   (double)
    %              .tundishCrossSectionalArea  (double)
    %          .physicalConstants struct with fields
    %              .g (double)    - acceleration due to gravity
    
    
    % -- Build nonlinear plant --
    nonlinearPlant = struct();
     nonlinearPlant.f = @(x, u, d) evaluateNonlinearDynamics( ...
        x, ...
        u, ...
        d, ...
        simulationPlan.plantGeometry, ...
        simulationPlan.operatingPoint, ...
        simulationPlan.physicalConstants);

    nonlinearPlant.metadata = struct(); 
    nonlinearPlant.metadata.plantGeometry = simulationPlan.plantGeometry; 
    nonlinearPlant.metadata.operatingPoint = simulationPlan.operatingPoint;
    nonlinearPlant.metadata.physicalConstants = simulationPlan.physicalConstants;

end