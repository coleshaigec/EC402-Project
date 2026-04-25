function controllability = analyzeLinearPlantControllability(linearPlant)
    % ANALYZELINEARPLANTCONTROLLABILITY Computes controllability matrix for linear plant and evaluates controllability via rank criterion.
    %
    % AUTHOR: Richie Kim
    %
    % INPUT
    %  linearPlant struct with fields
    %      .A (2 x 2 double) - state Jacobian, evaluated at operating point
    %      .B (2 x 2 double) - input Jacobian, evaluated at operating point
    %      .E (2 x 3 double) - disturbance Jacobian, evaluated at operating point
    %
    % OUTPUT
    %  controllability struct with fields
    %      .controllabilityMatrix (matrix)
    %      .controllabilityMatrixRank (double)
    %      .isControllable (boolean)

    A = linearPlant.A;
    B = linearPlant.B;

    controllabilityMatrix = [B, A*B];
    controllabilityMatrixRank = rank(controllabilityMatrix);

    controllability = struct();
    controllability.controllabilityMatrix = controllabilityMatrix;
    controllability.controllabilityMatrixRank = controllabilityMatrixRank;
    controllability.isControllable = controllabilityMatrixRank == size(A, 1);

end