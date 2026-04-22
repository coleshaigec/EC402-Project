function validateLinearPlantEigenstructureAnalysis(eigenstructure, linearPlant)
    % VALIDATELINEARPLANTEIGENSTRUCTUREANALYSIS Validates eigenstructure
    % analysis struct produced by analyzeLinearPlantEigenstructure.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  eigenstructure (struct) - eigenstructure analysis result
    %  linearPlant    (struct) - linear plant model
    %
    % OUTPUT
    %  None. Function throws assertion error on invalid input.

    %%%%%%%%%%%%%%%%%%%%%
    % INPUT SANITY CHECK %
    %%%%%%%%%%%%%%%%%%%%%
    assert(isstruct(linearPlant), ...
        'validateLinearPlantEigenstructureAnalysis:InvalidLinearPlantType', ...
        'linearPlant must be a struct.');

    requiredLinearPlantFields = {'A', 'B', 'E', 'metadata'};
    assert(all(isfield(linearPlant, requiredLinearPlantFields)), ...
        'validateLinearPlantEigenstructureAnalysis:LinearPlantMissingField', ...
        'linearPlant must contain fields A, B, E, and metadata.');

    validateattributes(linearPlant.A, {'double'}, ...
        {'real', 'finite', 'nonsparse', 'size', [2, 2]}, ...
        mfilename, 'linearPlant.A');

    %%%%%%%%%%%%%%%%%%%%%
    % TOP-LEVEL CHECKS  %
    %%%%%%%%%%%%%%%%%%%%%
    assert(isstruct(eigenstructure), ...
        'validateLinearPlantEigenstructureAnalysis:InvalidType', ...
        'eigenstructure must be a struct.');

    requiredTopLevelFields = {'eigenvalues', 'isStable'};
    actualTopLevelFields = fieldnames(eigenstructure);

    assert(all(isfield(eigenstructure, requiredTopLevelFields)), ...
        'validateLinearPlantEigenstructureAnalysis:MissingField', ...
        ['eigenstructure is missing one or more required fields: ', ...
         'eigenvalues, isStable.']);

    assert(numel(actualTopLevelFields) == numel(requiredTopLevelFields), ...
        'validateLinearPlantEigenstructureAnalysis:UnexpectedFieldCount', ...
        'eigenstructure contains unexpected top-level fields.');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % EIGENVALUE VECTOR CHECKS   %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Eigvals of a real matrix may be complex, so do NOT require "real".
    validateattributes(eigenstructure.eigenvalues, {'double'}, ...
        {'finite', 'nonsparse', 'size', [2, 1]}, ...
        mfilename, 'eigenstructure.eigenvalues');

    assert(islogical(eigenstructure.isStable) && isscalar(eigenstructure.isStable), ...
        'validateLinearPlantEigenstructureAnalysis:InvalidIsStableType', ...
        'eigenstructure.isStable must be a logical scalar.');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % INTERNAL CONSISTENCY AGAINST LINEAR PLANT %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    expectedEigenvalues = eig(linearPlant.A);
    expectedEigenvalues = sortEigenvaluesByDescendingRealPart(expectedEigenvalues);

    observedEigenvalues = eigenstructure.eigenvalues;
    observedEigenvalues = sortEigenvaluesByDescendingRealPart(observedEigenvalues);

    assert(max(abs(observedEigenvalues - expectedEigenvalues)) < 1e-10, ...
        'validateLinearPlantEigenstructureAnalysis:EigenvalueMismatch', ...
        ['eigenstructure.eigenvalues must equal eig(linearPlant.A), ', ...
         'sorted in descending order by real part.']);

    assert(isSortedByDescendingRealPart(eigenstructure.eigenvalues), ...
        'validateLinearPlantEigenstructureAnalysis:EigenvalueOrderingMismatch', ...
        ['eigenstructure.eigenvalues must be sorted in descending order ', ...
         'by real part.']);

    expectedIsStable = all(real(expectedEigenvalues) < 0);

    assert(eigenstructure.isStable == expectedIsStable, ...
        'validateLinearPlantEigenstructureAnalysis:IsStableMismatch', ...
        ['eigenstructure.isStable must be true if and only if all ', ...
         'eigenvalues of linearPlant.A have strictly negative real part.']);
end

function eigenvaluesSorted = sortEigenvaluesByDescendingRealPart(eigenvalues)
    % SORTEIGENVALUESBYDESCENDINGREALPART Sorts eigenvalues in descending
    % order by real part. Ties are broken deterministically by descending
    % imaginary part.

    sortingTable = [real(eigenvalues(:)), imag(eigenvalues(:))];
    [~, sortIdx] = sortrows(sortingTable, [-1, -2]);
    eigenvaluesSorted = eigenvalues(sortIdx);
    eigenvaluesSorted = eigenvaluesSorted(:);
end

function tf = isSortedByDescendingRealPart(eigenvalues)
    % ISSORTEDBYDESCENDINGREALPART Returns true if eigenvalues are sorted in
    % descending order by real part, with descending imaginary-part tie break.

    eigenvalues = eigenvalues(:);
    eigenvaluesSorted = sortEigenvaluesByDescendingRealPart(eigenvalues);
    tf = max(abs(eigenvalues - eigenvaluesSorted)) < 1e-12;
end