function fractionOutsidePrimaryBandSummaryPlot = ...
    plotFractionOutsidePrimaryBandSummary(primaryBandSummaryData, primaryBandSummaryDisplaySpec)
    % PLOTFRACTIONOUTSIDEPRIMARYBANDSUMMARY Plots fraction outside primary band by run.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  primaryBandSummaryData struct with fields
    %      .runLabels (numRuns x 1 string)
    %      .linearValues (numRuns x 1 double)
    %      .nonlinearValues (numRuns x 1 double)
    %
    %  primaryBandSummaryDisplaySpec struct with fields
    %      .title (string)
    %      .xLabel (string)
    %      .yLabel (string)
    %      .legendEntries (cell array of strings)
    %
    % OUTPUT
    %  fractionOutsidePrimaryBandSummaryPlot (figure handle)

    fractionOutsidePrimaryBandSummaryPlot = figure('Visible', 'off');
    hold on;
    grid on;

    groupedValues = [primaryBandSummaryData.linearValues, primaryBandSummaryData.nonlinearValues];
    barHandles = bar(groupedValues);

    title(primaryBandSummaryDisplaySpec.title);
    xlabel(primaryBandSummaryDisplaySpec.xLabel);
    ylabel(primaryBandSummaryDisplaySpec.yLabel);
    xticks(1:numel(primaryBandSummaryData.runLabels));
    xticklabels(primaryBandSummaryData.runLabels);

    if ~isempty(primaryBandSummaryDisplaySpec.legendEntries)
        legend(barHandles, primaryBandSummaryDisplaySpec.legendEntries, 'Location', 'best');
    end
end