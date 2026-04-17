function openLoopResult = runOpenLoopAnalysisForLinearPlant(linearPlant, measurementModel, simulationPlan)
    % RUNOPENLOOPANALYSIS Performs open-loop analysis on the linear plant.  
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  linearPlant struct with fields
    %
    %  measurementModel struct with fields
    %
    %  simulationPlan struct with fields
    %     
    %
    %
    %
    % OUTPUTS
    %  openLoopResult struct with fields
    %      .eigenstructure struct with fields
    %          .eigenvalues
    %          .isStable
    %
    %      .controllability struct with fields
    %          .controllabilityMatrix
    %          .controllabilityMatrixRank
    %          .isControllable
    %
    %      .observability struct with fields
    %          .observabilityMatrix
    %          .observabilityMatrixRank
    %          .isObservable
    %
    % NOTES
    %

    openLoopResult = struct();
    if simulationPlan.shouldUseNonBaselineDisturbance
        disturbanceScenario = simulationPlan.disturbanceScenario;
    else
        disturbanceScenario = simulationPlan.baselineDisturbance;
    end

    % -- Analyze eigenstructure --
    eigenstructure = analyzeLinearPlantEigenstructure(linearPlant);

    % -- Analyze controllability -- 

    
    


    


end