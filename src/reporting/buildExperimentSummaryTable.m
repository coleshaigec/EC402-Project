function summaryTable = buildExperimentSummaryTable(simulationResults)
    % BUILDEXPERIMENTSUMMARYTABLE Aggregates results from all runs of a single experiment into a summary table.
    %
    % AUTHOR: Cole H. Shaigec
    % 
    % INPUTS
    %  simulationResults array of structs, each with fields
    %      .train struct with fields
    %          .yHat   - predicted labels
    %          .yTrue  - true labels
    %          .performanceMetrics struct with model-dependent fields
    %      .test
    %          .yHat   - predicted labels
    %          .yTrue  - true labels
    %          .performanceMetrics struct with model-dependent fields
    %      .trainedModel struct with fields
    %          .model (struct)             - trained model
    %          .modelName (string)         - model type to be trained
    %          .taskType  (string)         - 'classification' or 'regression'
    %          .hyperparameters            - hyperparameters used in training
    %      .runPlan struct with fields
    %          .runNumber (positive integer)
    %          .pcaSpec struct with fields
    %              .enabled (boolean)
    %              .selectionMode (string) - either 'varianceThreshold' or 'fixedNumComponents'
    %              .varianceThreshold (double in [0,1]) -
    %              .fixedNumComponents (int > 0) - number of principal components to compute
    %
    %          .modelSpec struct with fields
    %              .modelName (string)
    %              .hyperparameterGrid (struct with model-specific fields)
    %
    %          .cmapssSubset (string)                    - 'FD001', 'FD002', 'FD003', or 'FD004'
    %          .windowSize (positive integer)            - for dataset windowing
    %          .numFolds (positive integer)              - number of CV folds
    %
    % OUTPUTS
    %  summaryTable table
    %      One row per runReport, with schema defined by
    %      buildTemplateSummaryTableRow and populated by
    %      buildTableRowFromRunReport.

    numRuns = numel(runReports);

    % -- Build template row once so schema remains fixed across all runs --
    templateRow = buildTemplateSummaryTableRow();

    % -- Handle empty input cleanly by returning an empty table with the
    %    correct variable schema --
    if numRuns == 0
        emptyRowStruct = repmat(templateRow, 0, 1);
        summaryTable = struct2table(emptyRowStruct);
        return;
    end

    % -- Preallocate homogeneous struct array for speed and schema discipline --
    tableRows = repmat(templateRow, numRuns, 1);

    % -- Build one table row per run report --
    for iRun = 1:numRuns
        tableRows(iRun) = buildTableRowFromRunReport(runReports(iRun), templateRow);
    end

    % -- Convert homogeneous struct array to MATLAB table --
    summaryTable = struct2table(tableRows);
end