function inputVectorTrajectoryPlot = plotInputVectorTrajectory(inputVectorTrajectory, ...
    inputSetpoints, inputDisplaySpec)
    % PLOTINPUTVECTORTRAJECTORY Plots input vector trajectory for a single simulation run.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  inputVectorTrajectory struct with fields
    %      .u (numTimestamps x 2 double) - simulated input trajectory
    %      .t (numTimestamps x 1 double) - timestamps
    %
    %  inputSetpoints struct with fields
    %      .uStar (2 x 1 double) - input setpoint
    %
    %  inputDisplaySpec struct with fields
    %      .title (string)
    %      .xLabel (string)
    %      .yLabel (string)
    %      .legendEntries (cell array of strings)
    %
    % OUTPUT
    %  inputVectorTrajectoryPlot (figure handle)

    t = inputVectorTrajectory.t(:);
    u = inputVectorTrajectory.u;

    assert(isequal(size(u, 1), numel(t)), ...
        'plotInputVectorTrajectory:DimensionMismatch', ...
        'inputVectorTrajectory.u must have one row per timestamp.');

    assert(isequal(size(u, 2), 2), ...
        'plotInputVectorTrajectory:InvalidInputTrajectorySize', ...
        'inputVectorTrajectory.u must be numTimestamps x 2.');

    uStar = inputSetpoints.uStar(:);

    assert(isequal(size(uStar), [2, 1]), ...
        'plotInputVectorTrajectory:InvalidSetpointSize', ...
        'inputSetpoints.uStar must be 2 x 1.');

    u1StarTrajectory = uStar(1) * ones(size(t));
    u2StarTrajectory = uStar(2) * ones(size(t));

    inputVectorTrajectoryPlot = figure('Visible', 'off');
    hold on;
    grid on;

    input1 = plot(t, u(:, 1), 'b');
    input2 = plot(t, u(:, 2), 'r');
    setpoint1 = plot(t, u1StarTrajectory, 'b:');
    setpoint2 = plot(t, u2StarTrajectory, 'r:');

    title(inputDisplaySpec.title);
    xlabel(inputDisplaySpec.xLabel);
    ylabel(inputDisplaySpec.yLabel);

    if ~isempty(inputDisplaySpec.legendEntries)
        assert(numel(inputDisplaySpec.legendEntries) == 4, ...
            'plotInputVectorTrajectory:InvalidLegendEntries', ...
            'inputDisplaySpec.legendEntries must contain exactly 4 entries.');

        legend([input1; input2; setpoint1; setpoint2], ...
            inputDisplaySpec.legendEntries, ...
            'Location', 'best');
    end
end