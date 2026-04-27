function observer = buildLuenbergerObserver(linearPlant, measurementModel)
    % BUILDLUENBERGEROBSERVER Builds Luenberger observer for linearized plant.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  linearPlant struct with fields
    %      .A (2 x 2 double)
    %      .B (2 x 2 double)
    %      .E (2 x 3 double)
    %      .metadata struct
    %
    %  measurementModel struct with fields
    %      .observabilityCase (string)
    %      .C (p x 2 double)
    %      .D (p x 2 double)
    %
    % OUTPUT
    %  observer struct with fields
    %      .type (string)
    %      .gain (2 x p double)
    %      .equilibrium struct with field
    %          .xe (2 x 1 double)
    %      .measurementModel struct
    %      .designMetadata struct

    A = linearPlant.A;
    C = measurementModel.C;

    desiredObserverPoles = getDesiredObserverPoles();

    assert(isequal(size(A), [2, 2]), ...
        'buildLuenbergerObserver:InvalidA', ...
        'linearPlant.A must be 2 x 2.');

    assert(size(C, 2) == 2, ...
        'buildLuenbergerObserver:InvalidC', ...
        'measurementModel.C must have 2 columns.');

    assert(isequal(size(desiredObserverPoles), [2, 1]), ...
        'buildLuenbergerObserver:InvalidDesiredObserverPoles', ...
        'desiredObserverPoles must be 2 x 1.');

    observabilityMatrix = obsv(A, C);
    observabilityRank = rank(observabilityMatrix);

    assert(observabilityRank == 2, ...
        'buildLuenbergerObserver:PlantNotObservable', ...
        'Cannot build observer because (A, C) is not observable.');

    L = place(A.', C.', desiredObserverPoles).';

    xe = [
        linearPlant.metadata.operatingPoint.hM;
        linearPlant.metadata.operatingPoint.hT
    ];

    observer = struct();
    observer.type = "luenberger";
    observer.gain = L;

    observer.equilibrium = struct();
    observer.equilibrium.xe = xe;

    observer.measurementModel = measurementModel;

    observer.designMetadata = struct();
    observer.designMetadata.desiredObserverPoles = desiredObserverPoles;
    observer.designMetadata.observabilityMatrix = observabilityMatrix;
    observer.designMetadata.observabilityRank = observabilityRank;
    observer.designMetadata.estimatorErrorDynamics = A - L * C;
    observer.designMetadata.estimatorErrorPoles = eig(A - L * C);
end