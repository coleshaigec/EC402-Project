function peakMoldDeviationSummaryPlot = ...
    plotPeakMoldDeviationSummary(peakMoldDeviationSummaryData, peakMoldDeviationSummaryDisplaySpec)
    % PLOTPEAKMOLDDEVIATIONSUMMARY Plots peak mold deviation by run.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  peakMoldDeviationSummaryData struct with fields
    %      .runLabels (numRuns x 1 string)
    %      .linearValues (numRuns x 1 double)
    %      .nonlinearValues (numRuns x 1 double)
    %
    %  peakMoldDeviationSummaryDisplaySpec struct with fields
    %      .title (string)
    %      .xLabel (string)
    %      .yLabel (string)
    %      .legendEntries (cell array of strings)
    %
    % OUTPUT
    %  peakMoldDeviationSummaryPlot (figure handle)

    peakMoldDeviationSummaryPlot = figure('Visible', 'off');
    hold on;
    grid on;

    groupedValues = [peakMoldDeviationSummaryData.linearValues, peakMoldDeviationSummaryData.nonlinearValues];
    barHandles = bar(groupedValues);

    title(peakMoldDeviationSummaryDisplaySpec.title);
    xlabel(peakMoldDeviationSummaryDisplaySpec.xLabel);
    ylabel(peakMoldDeviationSummaryDisplaySpec.yLabel);
    xticks(1:numel(peakMoldDeviationSummaryData.runLabels));
    xticklabels(peakMoldDeviationSummaryData.runLabels);

    if ~isempty(peakMoldDeviationSummaryDisplaySpec.legendEntries)
        legend(barHandles, peakMoldDeviationSummaryDisplaySpec.legendEntries, 'Location', 'best');
    end
end