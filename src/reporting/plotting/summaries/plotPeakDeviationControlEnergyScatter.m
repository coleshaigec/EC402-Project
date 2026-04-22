function peakDeviationControlEnergyScatterPlot = ...
    plotPeakDeviationControlEnergyScatter(scatterData, scatterDisplaySpec)
    % PLOTPEAKDEVIATIONCONTROLENERGYSCATTER Plots peak mold deviation versus control energy.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  scatterData struct with fields
    %      .linearControlEnergy (numRuns x 1 double)
    %      .nonlinearControlEnergy (numRuns x 1 double)
    %      .linearPeakMoldDeviation (numRuns x 1 double)
    %      .nonlinearPeakMoldDeviation (numRuns x 1 double)
    %
    %  scatterDisplaySpec struct with fields
    %      .title (string)
    %      .xLabel (string)
    %      .yLabel (string)
    %      .legendEntries (cell array of strings)
    %
    % OUTPUT
    %  peakDeviationControlEnergyScatterPlot (figure handle)

    peakDeviationControlEnergyScatterPlot = figure('Visible', 'off');
    hold on;
    grid on;

    linearPoints = scatter( ...
        scatterData.linearControlEnergy, ...
        scatterData.linearPeakMoldDeviation, ...
        'filled');

    nonlinearPoints = scatter( ...
        scatterData.nonlinearControlEnergy, ...
        scatterData.nonlinearPeakMoldDeviation, ...
        'filled');

    title(scatterDisplaySpec.title);
    xlabel(scatterDisplaySpec.xLabel);
    ylabel(scatterDisplaySpec.yLabel);

    if ~isempty(scatterDisplaySpec.legendEntries)
        legend([linearPoints, nonlinearPoints], ...
            scatterDisplaySpec.legendEntries, ...
            'Location', 'best');
    end
end