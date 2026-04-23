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

    inputVectorTrajectoryPlot = figure('Visible', 'off');
    hold on;
    grid on;

    input1 = plot(inputVectorTrajectory.t, inputVectorTrajectory.u(:, 1), 'b');
    input2 = plot(inputVectorTrajectory.t, inputVectorTrajectory.u(:, 2), 'r');
    setpoint1 = plot(inputVectorTrajectory.t, inputSetpoints.uStar(1), 'b:');
    setpoint2 = plot(inputVectorTrajectory.t, inputSetpoints.uStar(2), 'r:');

    title(inputDisplaySpec.title);
    xlabel(inputDisplaySpec.xLabel);
    ylabel(inputDisplaySpec.yLabel);

    if ~isempty(inputDisplaySpec.legendEntries)
        legend([input1, input2, setpoint1, setpoint2], ...
            inputDisplaySpec.legendEntries, 'Location', 'best');
    end
end