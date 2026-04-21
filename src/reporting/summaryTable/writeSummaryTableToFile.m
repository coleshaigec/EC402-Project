function writeSummaryTableToFile(summaryTable, outFileName)
    % WRITESUMMARYTABLETOFILE Writes experiment summary table to file in outputs folder.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  summaryTable table
    %      One row per runReport, with schema defined by
    %      buildTemplateSummaryTableRow and populated by
    %      buildTableRowFromRunReport.
    %
    %  outFileName (string) - output filename
    %
    % SIDE EFFECTS
    %  writes to file in outputs folder.

    targetPath = getOutputPath(outFileName);
    writetable(summaryTable, targetPath);
end