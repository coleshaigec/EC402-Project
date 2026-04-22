function estimationErrorNormTrajectoryPlot = ...
    plotEstimationErrorNormTrajectory(estimationErrorNormData, estimationErrorNormDisplaySpec)
    % PLOTESTIMATIONERRORNORMTRAJECTORY Plots estimation error norm over time
    % for a single simulation run.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  estimationErrorNormData struct with fields
    %      .x (numTimestamps x 2 double)    - true state trajectory
    %      .xHat (numTimestamps x 2 double) - estimated state trajectory
    %      .t (numTimestamps x 1 double)    - timestamps
    %
    %  estimationErrorNormDisplaySpec struct with fields
    %      .title (string)
    %      .xLabel (string)
    %      .yLabel (string)
    %      .legendEntries (cell array of strings)
    %
    % OUTPUT
    %  estimationErrorNormTrajectoryPlot (figure handle)

    estimationErrorNormTrajectoryPlot = figure('Visible', 'off');
    hold on;
    grid on;

    estimationError = estimationErrorNormData.x - estimationErrorNormData.xHat;
    estimationErrorNorm = sqrt(sum(estimationError.^2, 2));

    estimationErrorNormHandle = plot( ...
        estimationErrorNormData.t, ...
        estimationErrorNorm, ...
        'k');

    title(estimationErrorNormDisplaySpec.title);
    xlabel(estimationErrorNormDisplaySpec.xLabel);
    ylabel(estimationErrorNormDisplaySpec.yLabel);

    if ~isempty(estimationErrorNormDisplaySpec.legendEntries)
        legend( ...
            estimationErrorNormHandle, ...
            estimationErrorNormDisplaySpec.legendEntries, ...
            'Location', 'best');
    end
end