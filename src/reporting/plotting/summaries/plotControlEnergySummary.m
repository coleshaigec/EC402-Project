function controlEnergySummaryPlot = ...
    plotControlEnergySummary(controlEnergySummaryData, controlEnergySummaryDisplaySpec)
    % PLOTCONTROLENERGYSUMMARY Plots control energy by run.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  controlEnergySummaryData struct with fields
    %      .runLabels (numRuns x 1 string)
    %      .linearValues (numRuns x 1 double)
    %      .nonlinearValues (numRuns x 1 double)
    %
    %  controlEnergySummaryDisplaySpec struct with fields
    %      .title (string)
    %      .xLabel (string)
    %      .yLabel (string)
    %      .legendEntries (cell array of strings)
    %
    % OUTPUT
    %  controlEnergySummaryPlot (figure handle)

    controlEnergySummaryPlot = figure('Visible', 'off');
    hold on;
    grid on;

    groupedValues = [controlEnergySummaryData.linearValues, controlEnergySummaryData.nonlinearValues];
    barHandles = bar(groupedValues);

    title(controlEnergySummaryDisplaySpec.title);
    xlabel(controlEnergySummaryDisplaySpec.xLabel);
    ylabel(controlEnergySummaryDisplaySpec.yLabel);
    xticks(1:numel(controlEnergySummaryData.runLabels));
    xticklabels(controlEnergySummaryData.runLabels);

    if ~isempty(controlEnergySummaryDisplaySpec.legendEntries)
        legend(barHandles, controlEnergySummaryDisplaySpec.legendEntries, 'Location', 'best');
    end
end