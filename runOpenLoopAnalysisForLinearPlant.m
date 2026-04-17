function openLoopResult = runOpenLoopAnalysisForLinearPlant(linearPlant, measurementModel)
    % RUNOPENLOOPANALYSISFORLINEARPLANT Performs open-loop analysis on the linear plant at the specified operating point.  
    %
    % AUTHOR: Cole H. Shaigec
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
    % OUTPUTS
    %  openLoopResult struct with fields
    %      .eigenstructure struct with fields
    %          .eigenvalues (2 x 1 double)
    %          .isStable (boolean)
    %
    %      .controllability struct with fields
    %          .controllabilityMatrix (matrix)
    %          .controllabilityMatrixRank (double)
    %          .isControllable (boolean)
    %
    %      .observability struct with fields
    %          .observabilityMatrix (matrix)
    %          .observabilityMatrixRank (double)
    %          .isObservable (boolean)

    % -- Analyze eigenstructure --
    eigenstructure = analyzeLinearPlantEigenstructure(linearPlant);

    % -- Analyze controllability -- 
    controllability = analyzeLinearPlantControllability(linearPlant);

    % -- Analyze observability --
    observability = analyzeLinearPlantObservability(linearPlant, measurementModel);

    % -- Populate output struct -- 
    openLoopResult = struct();
    openLoopResult.eigenstructure = eigenstructure;
    openLoopResult.controllability = controllability;
    openLoopResult.observability = observability;
end