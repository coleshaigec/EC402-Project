function linearVsNonlinearMoldLevelComparisonPlot = ...
    plotLinearVsNonlinearMoldLevelComparison(comparisonData, comparisonDisplaySpec)
    % PLOTLINEARVSNONLINEARMOLDLEVELCOMPARISON Plots linear and nonlinear mold level trajectories on one figure.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  comparisonData struct with fields
    %      .linearTrajectory struct with fields
    %          .x (numTimestamps x 1 double)
    %          .t (numTimestamps x 1 double)
    %      .nonlinearTrajectory struct with fields
    %          .x (numTimestamps x 1 double)
    %          .t (numTimestamps x 1 double)
    %      .hMStarLinear (double)
    %      .hMStarNonlinear (double)
    %      .tolerances struct with fields
    %          .primary (double)
    %          .severe (double)
    %
    %  comparisonDisplaySpec struct with fields
    %      .title (string)
    %      .xLabel (string)
    %      .yLabel (string)
    %      .legendEntries (cell array of strings)
    %
    % OUTPUT
    %  linearVsNonlinearMoldLevelComparisonPlot (figure handle)

    linearVsNonlinearMoldLevelComparisonPlot = figure('Visible', 'off');
    hold on;
    grid on;

    linearTrajectory = plot( ...
        comparisonData.linearTrajectory.t, ...
        comparisonData.linearTrajectory.x, ...
        'b');

    nonlinearTrajectory = plot( ...
        comparisonData.nonlinearTrajectory.t, ...
        comparisonData.nonlinearTrajectory.x, ...
        'r');

    linearSetpoint = plot( ...
        comparisonData.linearTrajectory.t, ...
        comparisonData.hMStarLinear, ...
        'b--');

    nonlinearSetpoint = plot( ...
        comparisonData.nonlinearTrajectory.t, ...
        comparisonData.hMStarNonlinear, ...
        'r--');

    representativeTimeVector = comparisonData.nonlinearTrajectory.t;

    primaryBandLower = comparisonData.hMStarNonlinear - comparisonData.tolerances.primary;
    primaryBandUpper = comparisonData.hMStarNonlinear + comparisonData.tolerances.primary;
    primaryBand = plot(representativeTimeVector, primaryBandLower, 'k:');
    plot(representativeTimeVector, primaryBandUpper, 'k:');

    severeBandLower = comparisonData.hMStarNonlinear - comparisonData.tolerances.severe;
    severeBandUpper = comparisonData.hMStarNonlinear + comparisonData.tolerances.severe;
    severeBand = plot(representativeTimeVector, severeBandLower, 'm:');
    plot(representativeTimeVector, severeBandUpper, 'm:');

    title(comparisonDisplaySpec.title);
    xlabel(comparisonDisplaySpec.xLabel);
    ylabel(comparisonDisplaySpec.yLabel);

    if ~isempty(comparisonDisplaySpec.legendEntries)
        legend( ...
            [linearTrajectory, nonlinearTrajectory, linearSetpoint, nonlinearSetpoint, primaryBand, severeBand], ...
            comparisonDisplaySpec.legendEntries, ...
            'Location', 'best');
    end
end