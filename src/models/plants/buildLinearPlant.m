function linearPlant = buildLinearPlant(simulationPlan)
    % BUILDLINEARPLANT Uses simulation plan to encode linearized plant model for pipeline run.
    %
    % AUTHOR: Richie Kim/Dani Schwartz
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
    %  linearPlant struct with fields
    %      .A (2 x 2 double) - state Jacobian, evaluated at operating point
    %      .B (2 x 2 double) - input Jacobian, evaluated at operating point
    %      .E (2 x 3 double) - disturbance Jacobian, evaluated at operating point
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
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTES FOR IMPLEMENTATION %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Please do not delete the docstring at the top of this file.
    %
    % This function builds the linear plant model that the downstream
    % simulators will use. To ensure fast simulation, we don't want to
    % evaluate the Jacobians more than once, so we're doing it here inside
    % this function and packaging the result into a single struct that the
    % simulation pipeline will carry around.
    %
    % See project plan for typed up Jacobians. 



    % -- YOUR IMPLEMENTATION HERE -- 
    linearPlant = struct();
    linearPlant.A = []; % state Jacobian
    linearPlant.B = []; % input Jacobian
    linearPlant.E = []; % disturbance Jacobian
    linearPlant.metadata = []; % populate according to docstring

    % Output validation - please do not remove!
    validateLinearPlant(linearPlant, simulationPlan);
end