function templateRow = buildTemplateSummaryTableRow()
    % BUILDTEMPLATESUMMARYTABLEROW Builds scalar struct containing template row for experiment summary table.
    %
    % AUTHOR: Cole H. Shaigec
    % 
    % OUTPUTS
    %  templateRow struct with fields
    %      .runNumber (double)     
    %      .cmapssSubset (string)
    %      .taskType  (string)   
    %      .windowSize (double)
    %      .warningHorizon (double)
    %      .pcaEnabled (boolean)
    %      .pcaSelectionMode (string)
    %      .pcaVarianceThreshold (double)
    %      .modelName (string)
    %      .boostingRegressionT (double)
    %      .knnK (double)
    %      .qdaRegularizationStrength (double)
    %      .naiveBayesVarianceSmoothing (double)
    %      .randomForestNumTrees (double)
    %      .randomForestMinLeafSize (double)
    %      .randomForestNumPredictorsToSample (double)
    %      .ridgeRegressionLambda (double)
    %      .trainAccuracy (double)
    %      .trainF1 (double)
    %      .trainPrecision (double)
    %      .trainRecall (double)
    %      .trainSpecificity (double)
    %      .trainBalancedAccuracy (double)
    %      .trainRMSE (double)
    %      .trainMAE (double)
    %      .trainMedAE (double)
    %      .trainR2 (double)
    %      .trainBias (double)
    %      .testAccuracy (double)
    %      .testF1 (double)
    %      .testPrecision (double)
    %      .testRecall (double)
    %      .testSpecificity (double)
    %      .testBalancedAccuracy (double)
    %      .testRMSE (double)
    %      .testMAE (double)
    %      .testMedAE (double)
    %      .testR2 (double)
    %      .testBias (double)

    placeholder  = "";               

    % -- Build template row with fixed schema --
    templateRow = struct( ...
        'runNumber', placeholder, ...
        'linearPlant_K', placeholder, ...
        'linearPlant_vW', placeholder, ...
        'linearPlant_hT', placeholder, ...
        'linearPlant_hM', placeholder, ...
        'linearPlant_Qladle', placeholder, ...
        'linearPlant_uM', placeholder, ...
        'linearPlant_moldCSWidth', placeholder, ...
        'linearPlant_moldCSLength', placeholder, ...
        'linearPlant_moldCSArea', placeholder, ...
        'linearPlant_moldAxialLength', placeholder, ...
        'linearPlant_nozzleCSArea', placeholder, ...
        'linearPlant_tundishCSArea', placeholder, ...
        'nonlinearPlant_K', placeholder, ...
        'nonlinearPlant_vW', placeholder, ...
        'nonlinearPlant_hT', placeholder, ...
        'nonlinearPlant_hM', placeholder, ...
        'nonlinearPlant_Qladle', placeholder, ...
        'nonlinearPlant_uM', placeholder, ...
        'nonlinearPlant_moldCSWidth', placeholder, ...
        'nonlinearPlant_moldCSLength', placeholder, ...
        'nonlinearPlant_moldCSArea', placeholder, ...
        'nonlinearPlant_moldAxialLength', placeholder, ...
        'nonlinearPlant_nozzleCSArea', placeholder, ...
        'nonlinearPlant_tundishCSArea', placeholder, ...
        'observabilityCase', placeholder, ...
        'openLoopEigenvalues', placeholder, ...
        'openLoopIsStable', placeholder, ...
        'controllabilityMatrixRank', placeholder, ...
        'isControllable', placeholder, ...
        'observabilityMatrixRank', placeholder, ...
        'isObservable', placeholder, ...
        'controllerType', placeholder, ...
        'controllerGains', placeholder, ...
        'controller_xe', placeholder, ...
        'controller_ue', placeholder, ...
        'isControllable', placeholder, ...
        'isControllable', placeholder, ...
        'isControllable', placeholder, ...
        'isControllable', placeholder, ...
        'isControllable', placeholder, ...
        'isControllable', placeholder, ...
        'isControllable', placeholder, ...
        'isControllable', placeholder, ...
        'isControllable', placeholder, ...
        'isControllable', placeholder, ...
    );


    %  simulationResult struct with fields
    %
    %      .linearPlant struct with fields
    %          .A (2 x 2 double) - state Jacobian, evaluated at operating point
    %          .B (2 x 2 double) - input Jacobian, evaluated at operating point
    %          .E (2 x 3 double) - disturbance Jacobian, evaluated at operating point
    %          .metadata struct with fields
    %              .operatingPoint struct with fields
    %                  .K        (double)    - plant-specific proportionality constant
    %                  .vW       (double)    - computed withdrawal speed at operating point
    %                  .hT       (double)    - computed tundish height
    %                  .hM       (double)    - prescribed mold height at operating point
    %                  .Qladle   (double)    - computed ladle -> tundish flow rate
    %                  .uM       (double)    - prescribed tundish -> mold flow regulation setting
    %              .plantGeometry struct with fields
    %                  .moldCrossSectionWidth      (double)
    %                  .moldCrossSectionLength     (double)
    %                  .moldCrossSectionalArea     (double)
    %                  .moldAxialLength            (double)
    %                  .nozzleCrossSectionalArea   (double)
    %                  .tundishCrossSectionalArea  (double)
    %              .physicalConstants struct with fields
    %                  .g (double)    - acceleration due to gravity
    %
    %      .nonlinearPlant struct with fields
    %          .f (function handle) - passed into ODE45 as nonlinear dynamics
    %          .metadata struct with fields
    %              .operatingPoint struct with fields
    %                  .K        (double)    - plant-specific proportionality constant
    %                  .vW       (double)    - computed withdrawal speed at operating point
    %                  .hT       (double)    - computed tundish height
    %                  .hM       (double)    - prescribed mold height at operating point
    %                  .Qladle   (double)    - computed ladle -> tundish flow rate
    %                  .uM       (double)    - prescribed tundish -> mold flow regulation setting
    %              .plantGeometry struct with fields
    %                  .moldCrossSectionWidth      (double)
    %                  .moldCrossSectionLength     (double)
    %                  .moldCrossSectionalArea     (double)
    %                  .moldAxialLength            (double)
    %                  .nozzleCrossSectionalArea   (double)
    %                  .tundishCrossSectionalArea  (double)
    %              .physicalConstants struct with fields
    %                  .g (double)    - acceleration due to gravity
    %
    %      .measurementModel struct with fields
    %          .observabilityCase (string) - 'full' or 'moldOnly'
    %          .C (matrix of doubles, size depends on observability case)
    %          .D (2 x 2 double) - zeros here
    %
    %      .openLoopResult struct with fields
    %          .eigenstructure struct with fields
    %              .eigenvalues (2 x 1 double)
    %              .isStable (boolean)
    %    
    %          .controllability struct with fields
    %              .controllabilityMatrix (matrix)
    %              .controllabilityMatrixRank (double)
    %              .isControllable (boolean)
    %    
    %          .observability struct with fields
    %              .observabilityMatrix (matrix)
    %              .observabilityMatrixRank (double)
    %              .isObservable (boolean)
    % 
    %      .controller struct with fields
    %          .type (string) - either 'stateFeedback' or 'lqr'
    %          .gains (2 x 2 double) 
    %          .equilibrium struct with fields
    %              .xe (state equilibrium)
    %              .ue (input equilibrium)
    %          .designMetadata struct with controller-specific fields
    %
    %      .nonlinearClosedLoopResult struct with fields
    %          .timestamps (numTimestamps x 1 double)
    %          .state struct with fields
    %              .x (numTimestamps x 2 double) - simulated state trajectory
    %              .xDot (numTimestamps x 2 double) - simulated state derivative trajectory
    %          .u (numTimestamps x 2 double) - simulated input trajectory
    %          .d (numTimestamps x 3 double) - simulated disturbance trajectory
    %      
    %      .linearClosedLoopResult struct with fields
    %          .timestamps (numTimestamps x 1 double)
    %          .state struct with fields
    %              .x (numTimestamps x 2 double) - simulated state trajectory
    %              .xHat (numTimestamps x 2 double) - state estimate trajectory (only in partial observability case)
    %              .xDot (numTimestamps x 2 double) - simulated state derivative trajectory
    %          .u (numTimestamps x 2 double) - simulated input trajectory
    %          .d (numTimestamps x 3 double) - simulated disturbance trajectory
    %
    %      .observabilityCase (string) - 'full' or 'moldOnly'
end