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

    linearTime = comparisonData.linearTrajectory.t(:);
    nonlinearTime = comparisonData.nonlinearTrajectory.t(:);

    linearMoldLevel = comparisonData.linearTrajectory.x(:);
    nonlinearMoldLevel = comparisonData.nonlinearTrajectory.x(:);

    assert(numel(linearTime) == numel(linearMoldLevel), ...
        'plotLinearVsNonlinearMoldLevelComparison:LinearDimensionMismatch', ...
        'Linear trajectory time and state vectors must have same length.');

    assert(numel(nonlinearTime) == numel(nonlinearMoldLevel), ...
        'plotLinearVsNonlinearMoldLevelComparison:NonlinearDimensionMismatch', ...
        'Nonlinear trajectory time and state vectors must have same length.');

    linearSetpointTrajectory = comparisonData.hMStarLinear * ones(size(linearTime));
    nonlinearSetpointTrajectory = comparisonData.hMStarNonlinear * ones(size(nonlinearTime));

    representativeTimeVector = nonlinearTime;

    primaryBandLower = ...
        (comparisonData.hMStarNonlinear - comparisonData.tolerances.primary) ...
        * ones(size(representativeTimeVector));
    primaryBandUpper = ...
        (comparisonData.hMStarNonlinear + comparisonData.tolerances.primary) ...
        * ones(size(representativeTimeVector));

    severeBandLower = ...
        (comparisonData.hMStarNonlinear - comparisonData.tolerances.severe) ...
        * ones(size(representativeTimeVector));
    severeBandUpper = ...
        (comparisonData.hMStarNonlinear + comparisonData.tolerances.severe) ...
        * ones(size(representativeTimeVector));

    linearVsNonlinearMoldLevelComparisonPlot = figure('Visible', 'off');
    hold on;
    grid on;

    linearTrajectory = plot(linearTime, linearMoldLevel, 'b');

    nonlinearTrajectory = plot(nonlinearTime, nonlinearMoldLevel, 'r');

    linearSetpoint = plot(linearTime, linearSetpointTrajectory, 'b--');

    nonlinearSetpoint = plot(nonlinearTime, nonlinearSetpointTrajectory, 'r--');

    primaryBand = plot(representativeTimeVector, primaryBandLower, 'k:');
    plot(representativeTimeVector, primaryBandUpper, 'k:');

    severeBand = plot(representativeTimeVector, severeBandLower, 'm:');
    plot(representativeTimeVector, severeBandUpper, 'm:');

    title(comparisonDisplaySpec.title);
    xlabel(comparisonDisplaySpec.xLabel);
    ylabel(comparisonDisplaySpec.yLabel);

    if ~isempty(comparisonDisplaySpec.legendEntries)
        assert(numel(comparisonDisplaySpec.legendEntries) == 6, ...
            'plotLinearVsNonlinearMoldLevelComparison:InvalidLegendEntries', ...
            'comparisonDisplaySpec.legendEntries must contain exactly 6 entries.');

        legend( ...
            [linearTrajectory; nonlinearTrajectory; linearSetpoint; nonlinearSetpoint; primaryBand; severeBand], ...
            comparisonDisplaySpec.legendEntries, ...
            'Location', 'best');
    end
end