function tundishLevelTrajectoryPlot = plotTundishLevelTrajectory(tundishLevelTrajectory, ...
    tundishLevelSetpoints, tundishLevelDisplaySpec)
    % PLOTTUNDISHLEVELTRAJECTORY Plots tundish level trajectory for a single simulation run.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  tundishLevelTrajectory struct with fields
    %      .x (numTimestamps x 1 double) - simulated tundish level trajectory
    %      .t (numTimestamps x 1 double) - timestamps
    %
    %  tundishLevelSetpoints struct with fields
    %      .hTStar (double)
    %
    %  tundishLevelDisplaySpec struct with fields
    %      .title (string)
    %      .xLabel (string)
    %      .yLabel (string)
    %      .legendEntries (cell array of strings)
    %
    % OUTPUT
    %  tundishLevelTrajectoryPlot (figure handle)

    t = tundishLevelTrajectory.t(:);
    hT = tundishLevelTrajectory.x(:);

    assert(numel(t) == numel(hT), ...
        'plotTundishLevelTrajectory:DimensionMismatch', ...
        'tundishLevelTrajectory.t and tundishLevelTrajectory.x must have same number of elements.');

    hTStarTrajectory = tundishLevelSetpoints.hTStar * ones(size(t));

    tundishLevelTrajectoryPlot = figure('Visible', 'off');
    hold on;
    grid on;

    trajectory = plot(t, hT, 'b');
    setpoint = plot(t, hTStarTrajectory, 'k-');

    title(tundishLevelDisplaySpec.title);
    xlabel(tundishLevelDisplaySpec.xLabel);
    ylabel(tundishLevelDisplaySpec.yLabel);

    if ~isempty(tundishLevelDisplaySpec.legendEntries)
        assert(numel(tundishLevelDisplaySpec.legendEntries) == 2, ...
            'plotTundishLevelTrajectory:InvalidLegendEntries', ...
            'legendEntries must contain exactly 2 entries.');

        legend([trajectory; setpoint], ...
            tundishLevelDisplaySpec.legendEntries, ...
            'Location', 'best');
    end
end