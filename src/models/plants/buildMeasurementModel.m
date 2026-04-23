function measurementModel = buildMeasurementModel(simulationPlan)
    % BUILDMEASUREMENTMODEL Constructs C and D for output computation during simulation run.
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
    %          .uM       (double)
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
    %  measurementModel struct with fields
    %      .observabilityCase (string) - 'full' or 'moldOnly'
    %      .C (matrix of doubles, size depends on observability case)
    %      .D (matrix of doubles, size depends on observability case) - zeros here
    %
    % NOTES
    % - Given that two observability scenarios are tested, this function
    % builds the output separately from the plant model. 
    %

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTES FOR IMPLEMENTATION %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Please do not delete the docstring at the top of this file.
    %
    % This function builds the measurement model. It computes C and D for y
    % = Cx + Du. In our model, inputs don't affect observed state, so D is
    % a matrix of zeroes. 
    %
    % We are testing two observability cases. In the full observability case,
    % we can measure both states (mold height and tundish height)
    % perfectly. In the partial observability case, we can only observe the
    % mold height. This function must build the matrices C and D according
    % to the observability case specified in the simulationPlan struct
    % passed as an input.
    %
    % In the full observability case, C is the 2x2 identity matrix. In the
    % partial observability case, C is [1, 0] to extract the mold height
    % only and output a scalar y.
    %
    % See the state space model in the project plan for more details if
    % needed.
    %
    % The validator will enforce the correct size of D.

    observabilityCase = simulationPlan.observabilityCase;

    measurementModel = struct();
    measurementModel.observabilityCase = observabilityCase;

    switch observabilityCase
        case "full"
            measurementModel.C = eye(2);
            measurementModel.D = zeros(2, 2);

        case "moldOnly"
            measurementModel.C = [1, 0];
            measurementModel.D = zeros(1, 2);

        otherwise
            error('buildMeasurementModel:InvalidObservabilityCase', ...
                'observabilityCase must be "full" or "moldOnly".');
    end

    % Output validation - please do not remove
    validateMeasurementModel(measurementModel, simulationPlan);
end