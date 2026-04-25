function observability = analyzeLinearPlantObservability(linearPlant, measurementModel)
    % ANALYZELINEARPLANTOBSERVABILITY Computes observability matrix for linear plant and evaluates observability via rank criterion.
    %
    % AUTHOR: Richie Kim
    %
    % INPUTS
    %  linearPlant struct with fields
    %      .A (2 x 2 double) - state Jacobian, evaluated at operating point
    %      .B (2 x 2 double) - input Jacobian, evaluated at operating point
    %      .E (2 x 3 double) - disturbance Jacobian, evaluated at operating point
    %      .metadata struct with fields
    %
    %  measurementModel struct with fields
    %      .observabilityCase (string) - 'full' or 'moldOnly'
    %      .C (matrix of doubles, size depends on observability case)
    %      .D (matrix of doubles, size depends on observability case) - zeros here
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

    A = linearPlant.A;
    C = measurementModel.C;

    observabilityMatrix = obsv(A, C);
    observabilityMatrixRank = rank(observabilityMatrix);

    observability = struct();
    observability.observabilityMatrix = observabilityMatrix;
    observability.observabilityMatrixRank = observabilityMatrixRank;
    observability.isObservable = observabilityMatrixRank == size(A, 1);

end