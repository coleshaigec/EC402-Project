function linearPlant = buildLinearPlant(simulationPlan)
    % BUILDLINEARPLANT Uses simulation plan to encode linearized plant model for pipeline run.
    %
    % AUTHOR: Richie Kim
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
    %      .controller (string)
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

    % % -- Hard-coded values in place for pipeline debugging --
    % % Delete these when you're ready to test your code
    % linearPlant.A = eye(2);
    % linearPlant.B = eye(2);
    % linearPlant.E = [1,0,0;0,1,0];
    % linearPlant.metadata = struct();
    % linearPlant.metadata.operatingPoint = buildOperatingPoint(buildPlantGeometry(), buildSafetyRequirements, 1, struct('g', 9.81));
    % linearPlant.metadata.plantGeometry = buildPlantGeometry();
    % linearPlant.metadata.physicalConstants = struct('g', 9.81);

    % Output validation - please do not remove!
    validateLinearPlant(linearPlant, simulationPlan);
end