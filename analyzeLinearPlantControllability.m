function controllability = analyzeLinearPlantControllability(linearPlant)
    % ANALYZELINEARPLANTCONTROLLABILITY Computes controllability matrix for linear plant and evaluates controllability via rank criterion.
    %
    % AUTHOR: Dani Schwartz/Richie Kim
    %
    % INPUT
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
    % OUTPUT
    %  controllability struct with fields
    %      .controllabilityMatrix (matrix)
    %      .controllabilityMatrixRank (double)
    %      .isControllable (boolean)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTES FOR IMPLEMENTATION %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % - Please do not delete the docstring above. 
    % - isControllable is true if and only if the controllability matrix has full row
    % rank. 
    % - Only the input and state Jacobians A and B should be used here. The
    % disturbance Jacobian E is irrelevant.

    % -- YOUR IMPLEMENTATION HERE -- 
    controllability = struct();
    controllability.controllabilityMatrix = [];
    controllability.controllabilityMatrixRank = [];
    controllability.isControllable = [];


end