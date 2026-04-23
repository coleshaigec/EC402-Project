function stateFeedbackVsLQRMoldLevelComparisonPlot = ...
    plotStateFeedbackVsLQRMoldLevelComparison(comparisonData, comparisonDisplaySpec)
    % PLOTSTATEFEEDBACKVSLQRMOLDLEVELCOMPARISON Plots state-feedback and LQR mold level trajectories on one figure.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  comparisonData struct with fields
    %      .stateFeedbackTrajectory struct with fields
    %          .x (numTimestamps x 1 double)
    %          .t (numTimestamps x 1 double)
    %      .lqrTrajectory struct with fields
    %          .x (numTimestamps x 1 double)
    %          .t (numTimestamps x 1 double)
    %      .hMStarStateFeedback (double)
    %      .hMStarLQR (double)
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
    %  stateFeedbackVsLQRMoldLevelComparisonPlot (figure handle)

    stateFeedbackVsLQRMoldLevelComparisonPlot = figure('Visible', 'off');
    hold on;
    grid on;

    stateFeedbackTrajectory = plot( ...
        comparisonData.stateFeedbackTrajectory.t, ...
        comparisonData.stateFeedbackTrajectory.x, ...
        'b');

    lqrTrajectory = plot( ...
        comparisonData.lqrTrajectory.t, ...
        comparisonData.lqrTrajectory.x, ...
        'r');

    stateFeedbackSetpoint = plot( ...
        comparisonData.stateFeedbackTrajectory.t, ...
        comparisonData.hMStarStateFeedback, ...
        'b--');

    lqrSetpoint = plot( ...
        comparisonData.lqrTrajectory.t, ...
        comparisonData.hMStarLQR, ...
        'r--');

    representativeTimeVector = comparisonData.lqrTrajectory.t;

    primaryBandLower = comparisonData.hMStarLQR - comparisonData.tolerances.primary;
    primaryBandUpper = comparisonData.hMStarLQR + comparisonData.tolerances.primary;
    primaryBand = plot(representativeTimeVector, primaryBandLower, 'k:');
    plot(representativeTimeVector, primaryBandUpper, 'k:');

    severeBandLower = comparisonData.hMStarLQR - comparisonData.tolerances.severe;
    severeBandUpper = comparisonData.hMStarLQR + comparisonData.tolerances.severe;
    severeBand = plot(representativeTimeVector, severeBandLower, 'm:');
    plot(representativeTimeVector, severeBandUpper, 'm:');

    title(comparisonDisplaySpec.title);
    xlabel(comparisonDisplaySpec.xLabel);
    ylabel(comparisonDisplaySpec.yLabel);

    if ~isempty(comparisonDisplaySpec.legendEntries)
        legend( ...
            [stateFeedbackTrajectory, lqrTrajectory, stateFeedbackSetpoint, lqrSetpoint, primaryBand, severeBand], ...
            comparisonDisplaySpec.legendEntries, ...
            'Location', 'best');
    end
end