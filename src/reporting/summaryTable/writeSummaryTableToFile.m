function writeSummaryTableToFile(summaryTable, outputPlan)
    % WRITESUMMARYTABLETOFILE Writes experiment summary table to configured output path.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  summaryTable table
    %      One row per runReport, with schema defined by
    %      buildTemplateSummaryTableRow and populated by
    %      buildTableRowFromRunReport.
    %
    %  outputPlan struct with fields
    %      .summary struct with fields
    %          .tableFilePath (string)
    %
    % SIDE EFFECTS
    %  Writes summary table to configured experiment output location.

    validateattributes(summaryTable, {'table'}, {}, mfilename, 'summaryTable', 1);

    assert(isstruct(outputPlan), ...
        'writeSummaryTableToFile:InvalidOutputPlan', ...
        'outputPlan must be a struct.');

    assert(isfield(outputPlan, 'summary') && isstruct(outputPlan.summary), ...
        'writeSummaryTableToFile:MissingSummaryStruct', ...
        'outputPlan.summary must exist and be a struct.');

    assert(isfield(outputPlan.summary, 'tableFilePath'), ...
        'writeSummaryTableToFile:MissingTableFilePath', ...
        'outputPlan.summary.tableFilePath must be defined.');

    tableFilePath = outputPlan.summary.tableFilePath;

    assert((ischar(tableFilePath) || isstring(tableFilePath)) && strlength(string(tableFilePath)) > 0, ...
        'writeSummaryTableToFile:InvalidTableFilePath', ...
        'outputPlan.summary.tableFilePath must be a nonempty string.');

    writetable(summaryTable, tableFilePath);
end