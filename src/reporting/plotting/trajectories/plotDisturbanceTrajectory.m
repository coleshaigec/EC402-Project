function disturbanceTrajectoryPlot = plotDisturbanceTrajectory(disturbanceTrajectory, ...
    disturbanceDisplaySpec)
    % PLOTDISTURBANCETRAJECTORY Plots disturbance trajectory for a single simulation run.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  disturbanceTrajectory struct with fields
    %      .d (numTimestamps x 3 double) - simulated disturbance trajectory
    %      .t (numTimestamps x 1 double) - timestamps
    %
    %  disturbanceDisplaySpec struct with fields
    %      .title (string)
    %      .xLabel (string)
    %      .yLabel (string)
    %      .legendEntries (cell array of strings)
    %
    % OUTPUT
    %  disturbanceTrajectoryPlot (figure handle)

    disturbanceTrajectoryPlot = figure('Visible', 'off');
    hold on;
    grid on;

    disturbance1 = plot(disturbanceTrajectory.t, disturbanceTrajectory.d(:, 1), 'b');
    disturbance2 = plot(disturbanceTrajectory.t, disturbanceTrajectory.d(:, 2), 'r');
    disturbance3 = plot(disturbanceTrajectory.t, disturbanceTrajectory.d(:, 3), 'k');

    title(disturbanceDisplaySpec.title);
    xlabel(disturbanceDisplaySpec.xLabel);
    ylabel(disturbanceDisplaySpec.yLabel);

    if ~isempty(disturbanceDisplaySpec.legendEntries)
        legend([disturbance1, disturbance2, disturbance3], ...
            disturbanceDisplaySpec.legendEntries, 'Location', 'best');
    end
end