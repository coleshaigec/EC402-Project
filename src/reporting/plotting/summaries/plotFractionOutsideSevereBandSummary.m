function fractionOutsideSevereBandSummaryPlot = ...
    plotFractionOutsideSevereBandSummary(severeBandSummaryData, severeBandSummaryDisplaySpec)
    % PLOTFRACTIONOUTSIDESEVEREBANDSUMMARY Plots fraction outside severe band by run.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  severeBandSummaryData struct with fields
    %      .runLabels (numRuns x 1 string)
    %      .linearValues (numRuns x 1 double)
    %      .nonlinearValues (numRuns x 1 double)
    %
    %  severeBandSummaryDisplaySpec struct with fields
    %      .title (string)
    %      .xLabel (string)
    %      .yLabel (string)
    %      .legendEntries (cell array of strings)
    %
    % OUTPUT
    %  fractionOutsideSevereBandSummaryPlot (figure handle)

    fractionOutsideSevereBandSummaryPlot = figure('Visible', 'off');
    hold on;
    grid on;

    groupedValues = [severeBandSummaryData.linearValues, severeBandSummaryData.nonlinearValues];
    barHandles = bar(groupedValues);

    title(severeBandSummaryDisplaySpec.title);
    xlabel(severeBandSummaryDisplaySpec.xLabel);
    ylabel(severeBandSummaryDisplaySpec.yLabel);
    xticks(1:numel(severeBandSummaryData.runLabels));
    xticklabels(severeBandSummaryData.runLabels);

    if ~isempty(severeBandSummaryDisplaySpec.legendEntries)
        legend(barHandles, severeBandSummaryDisplaySpec.legendEntries, 'Location', 'best');
    end
end