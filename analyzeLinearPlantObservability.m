function observability = analyzeLinearPlantObservability(linearPlant, measurementModel)
    % ANALYZELINEARPLANTOBSERVABILITY Computes observability matrix for linear plant and evaluates observability via rank criterion.
    %
    % AUTHOR: Dani Schwartz/Richie Kim
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
    %  measurementModel struct with fields
    %      .observabilityCase (string) - 'full' or 'moldOnly'
    %      .C (matrix of doubles, size depends on observability case)
    %      .D (2 x 2 double) - zeros here
    %
    % OUTPUT
    %  observability struct with fields
    %      .observabilityMatrix (matrix)
    %      .observabilityMatrixRank (double)
    %      .isObservable (boolean)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTES FOR IMPLEMENTATION %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % - Please do not delete the docstring above. 
    % - isObservable is true if and only if the observability matrix has
    % rank equal to the number of states.
    % - The matrices B, D and E are irrelevant to this calculation. Only
    % A and C should be used.
    % - For this two-state model, the observability matrix is [C; CA]

    % -- YOUR IMPLEMENTATION HERE --
    observability = struct();
    observability.observabilityMatrix = [];
    observability.observabilityMatrixRank = [];
    observability.isObservable = [];
end