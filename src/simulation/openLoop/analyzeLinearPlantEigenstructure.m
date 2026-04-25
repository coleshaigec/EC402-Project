function eigenstructure = analyzeLinearPlantEigenstructure(linearPlant)
    % ANALYZELINEARPLANTEIGENSTRUCTURE Computes eigenvalues of state Jacobian and analyzes open-loop stability for the linearized model. 
    %
    % AUTHOR: Richie Kim
    %
    % INPUTS
    % linearPlant struct with fields
    %     .A (2 x 2 double) - state Jacobian, evaluated at operating point
    %     .B (2 x 2 double) - input Jacobian, evaluated at operating point
    %     .E (2 x 3 double) - disturbance Jacobian, evaluated at operating point
    %     .metadata struct with fields
    %         .operatingPoint struct with fields
    %             .K        (double)    - plant-specific proportionality constant
    %             .vW       (double)    - computed withdrawal speed at operating point
    %             .hT       (double)    - computed tundish height
    %             .hM       (double)    - prescribed mold height at operating point
    %             .Qladle   (double)    - computed ladle -> tundish flow rate
    %             .uM       (double)    - prescribed tundish -> mold flow regulation setting
    %         .plantGeometry struct with fields
    %             .moldCrossSectionWidth      (double)
    %             .moldCrossSectionLength     (double)
    %             .moldCrossSectionalArea     (double)
    %             .moldAxialLength            (double)
    %             .nozzleCrossSectionalArea   (double)
    %             .tundishCrossSectionalArea  (double)
    %         .physicalConstants struct with fields
    %             .g (double)    - acceleration due to gravity
    %
    % OUTPUT
    %  eigenstructure struct with fields
    %      .eigenvalues (2 x 1 double) - eigenvalues of state Jacobian
    %      .isStable (boolean) - 'true' if state Jacobian is Hurwitz, false otherwise
    %

    A = linearPlant.A;

    eigenvalues = eig(A);
    [~, sortIdx] = sort(real(eigenvalues), 'descend');
    eigenvalues = eigenvalues(sortIdx);

    eigenstructure = struct();
    eigenstructure.eigenvalues = eigenvalues(:);
    eigenstructure.isStable = all(real(eigenvalues) < 0);

end