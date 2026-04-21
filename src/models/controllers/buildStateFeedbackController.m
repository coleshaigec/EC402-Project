function stateFeedbackController = buildStateFeedbackController(linearPlant, operatingPoint, stateFeedbackControllerParameters)
    % BUILDSTATEFEEDBACKCONTROLLER Places poles on the linearized plant and builds a state feedback controller model for use in simulation.
    %
    % AUTHOR: Dani Schwartz
    %
    % INPUTS
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
    %
    %  stateFeedbackControllerParameters struct with fields
    %      .desiredPoles (2 x 1 double);
    %
    % OUTPUT
    %  stateFeedbackController struct with fields
    %      .type (string) 
    %      .gains (2 x 2 double)
    %      .equilibrium struct with fields
    %          .xe (state equilibrium)
    %          .ue (input equilibrium)
    %      .designMetadata struct with fields
    %          .Acl (matrix) - closed-loop matrix
    %          .desiredPoles (2 x 1 double)
    %          .placedPoles (2 x 1 double)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTES FOR IMPLEMENTATION %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % - Please do not delete the docstring above. 
    % - MATLAB's built-in "place" function is the easiest, most convenient,
    % and most effective way to place poles for this project.
    % - To compute the equilibrium, please use the function
    % getEquilibriumFromOperatingPoint

    % -- YOUR IMPLEMENTATION HERE --
    stateFeedbackController = struct();
    stateFeedbackController.type = 'stateFeedback';
    stateFeedbackController.gains = gains;
    stateFeedbackController.equilibrium = struct();
    stateFeedbackController.equilibrium.xe = xe;
    stateFeedbackController.equilibrium.ue = ue;

    stateFeedbackController.designMetadata = struct();
    stateFeedbackController.designMetadata.Acl = Acl;
    stateFeedbackController.designMetadata.desiredPoles = stateFeedbackControllerParameters.desiredPoles;
    stateFeedbackController.designMetadata.placedPoles = eig(Acl);
    
    % Output validation -- please do not remove
    validateStateFeedbackController(stateFeedbackController, linearPlant, ...
        operatingPoint, stateFeedbackControllerParameters);

end