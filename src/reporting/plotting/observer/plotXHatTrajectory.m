function xHatTrajectoryPlot = plotXHatTrajectory(xHatTrajectoryData, xHatTrajectoryDisplaySpec)
    % PLOTXHATTRAJECTORY Plots true and estimated state trajectories for a
    % single simulation run.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  xHatTrajectoryData struct with fields
    %      .x (numTimestamps x 2 double)    - true state trajectory
    %      .xHat (numTimestamps x 2 double) - estimated state trajectory
    %      .t (numTimestamps x 1 double)    - timestamps
    %
    %  xHatTrajectoryDisplaySpec struct with fields
    %      .title (string)
    %      .xLabel (string)
    %      .yLabel (string)
    %      .legendEntries (cell array of strings)
    %
    % OUTPUT
    %  xHatTrajectoryPlot (figure handle)

    xHatTrajectoryPlot = figure('Visible', 'off');
    hold on;
    grid on;

    trueMoldLevel = plot(xHatTrajectoryData.t, xHatTrajectoryData.x(:, 1), 'b');
    estimatedMoldLevel = plot(xHatTrajectoryData.t, xHatTrajectoryData.xHat(:, 1), 'b--');

    trueTundishLevel = plot(xHatTrajectoryData.t, xHatTrajectoryData.x(:, 2), 'r');
    estimatedTundishLevel = plot(xHatTrajectoryData.t, xHatTrajectoryData.xHat(:, 2), 'r--');

    title(xHatTrajectoryDisplaySpec.title);
    xlabel(xHatTrajectoryDisplaySpec.xLabel);
    ylabel(xHatTrajectoryDisplaySpec.yLabel);

    if ~isempty(xHatTrajectoryDisplaySpec.legendEntries)
        legend( ...
            [trueMoldLevel, estimatedMoldLevel, trueTundishLevel, estimatedTundishLevel], ...
            xHatTrajectoryDisplaySpec.legendEntries, ...
            'Location', 'best');
    end
end