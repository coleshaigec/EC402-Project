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

    stateFeedbackTime = comparisonData.stateFeedbackTrajectory.t(:);
    lqrTime = comparisonData.lqrTrajectory.t(:);

    stateFeedbackMoldLevel = comparisonData.stateFeedbackTrajectory.x(:);
    lqrMoldLevel = comparisonData.lqrTrajectory.x(:);

    assert(numel(stateFeedbackTime) == numel(stateFeedbackMoldLevel), ...
        'plotStateFeedbackVsLQRMoldLevelComparison:StateFeedbackDimensionMismatch', ...
        'State-feedback trajectory time and state vectors must have same length.');

    assert(numel(lqrTime) == numel(lqrMoldLevel), ...
        'plotStateFeedbackVsLQRMoldLevelComparison:LQRDimensionMismatch', ...
        'LQR trajectory time and state vectors must have same length.');

    stateFeedbackSetpointTrajectory = ...
        comparisonData.hMStarStateFeedback * ones(size(stateFeedbackTime));
    lqrSetpointTrajectory = ...
        comparisonData.hMStarLQR * ones(size(lqrTime));

    representativeTimeVector = lqrTime;

    primaryBandLower = ...
        (comparisonData.hMStarLQR - comparisonData.tolerances.primary) ...
        * ones(size(representativeTimeVector));
    primaryBandUpper = ...
        (comparisonData.hMStarLQR + comparisonData.tolerances.primary) ...
        * ones(size(representativeTimeVector));

    severeBandLower = ...
        (comparisonData.hMStarLQR - comparisonData.tolerances.severe) ...
        * ones(size(representativeTimeVector));
    severeBandUpper = ...
        (comparisonData.hMStarLQR + comparisonData.tolerances.severe) ...
        * ones(size(representativeTimeVector));

    stateFeedbackVsLQRMoldLevelComparisonPlot = figure('Visible', 'off');
    hold on;
    grid on;

    stateFeedbackTrajectory = plot( ...
        stateFeedbackTime, ...
        stateFeedbackMoldLevel, ...
        'b');

    lqrTrajectory = plot( ...
        lqrTime, ...
        lqrMoldLevel, ...
        'r');

    stateFeedbackSetpoint = plot( ...
        stateFeedbackTime, ...
        stateFeedbackSetpointTrajectory, ...
        'b--');

    lqrSetpoint = plot( ...
        lqrTime, ...
        lqrSetpointTrajectory, ...
        'r--');

    primaryBand = plot(representativeTimeVector, primaryBandLower, 'k:');
    plot(representativeTimeVector, primaryBandUpper, 'k:');

    severeBand = plot(representativeTimeVector, severeBandLower, 'm:');
    plot(representativeTimeVector, severeBandUpper, 'm:');

    title(comparisonDisplaySpec.title);
    xlabel(comparisonDisplaySpec.xLabel);
    ylabel(comparisonDisplaySpec.yLabel);

    if ~isempty(comparisonDisplaySpec.legendEntries)
        assert(numel(comparisonDisplaySpec.legendEntries) == 6, ...
            'plotStateFeedbackVsLQRMoldLevelComparison:InvalidLegendEntries', ...
            'comparisonDisplaySpec.legendEntries must contain exactly 6 entries.');

        legend( ...
            [stateFeedbackTrajectory; lqrTrajectory; stateFeedbackSetpoint; lqrSetpoint; primaryBand; severeBand], ...
            comparisonDisplaySpec.legendEntries, ...
            'Location', 'best');
    end
end