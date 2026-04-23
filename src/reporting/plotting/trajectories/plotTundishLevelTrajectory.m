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

    tundishLevelTrajectoryPlot = figure('Visible', 'off');
    hold on;
    grid on;

    trajectory = plot(tundishLevelTrajectory.t, tundishLevelTrajectory.x, 'b');
    setpoint = plot(tundishLevelTrajectory.t, tundishLevelSetpoints.hTStar, 'k-');

    title(tundishLevelDisplaySpec.title);
    xlabel(tundishLevelDisplaySpec.xLabel);
    ylabel(tundishLevelDisplaySpec.yLabel);

    if ~isempty(tundishLevelDisplaySpec.legendEntries)
        legend([trajectory, setpoint], ...
            tundishLevelDisplaySpec.legendEntries, 'Location', 'best');
    end
end