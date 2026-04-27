function moldLevelTrajectoryPlot = plotMoldLevelTrajectory(moldLevelTrajectory, ...
    moldLevelSetpoints, moldLevelDisplaySpec)
    % PLOTMOLDLEVELTRAJECTORY Plots mold level trajectory for a single simulation run.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  moldLevelTrajectory struct with fields
    %      .x (numTimestamps x 1 double) - simulated mold level trajectory
    %      .t (numTimestamps x 1 double) - timestamps
    %
    %  moldLevelSetpoints struct with fields
    %      .hMStar (double)              - prescribed mold height at operating point
    %      .tolerances struct with fields
    %          .primary (double)       - primary band tolerance, in m
    %          .severe (double)        - severe band tolerance, in m
    %
    %  moldLevelDisplaySpec struct with fields
    %      .title (string)            - plot title
    %      .xLabel (string)           - plot x-axis label
    %      .yLabel (string)           - plot y-axis label
    %      .legendEntries (cell array of strings)  - if empty, don't add a legend
    %
    % OUTPUT
    %  moldLevelTrajectoryPlot (figure handle)

    % -- Extract and validate data --
    t = moldLevelTrajectory.t(:);
    hM = moldLevelTrajectory.x(:);

    assert(numel(t) == numel(hM), ...
        'plotMoldLevelTrajectory:DimensionMismatch', ...
        'moldLevelTrajectory.t and moldLevelTrajectory.x must have the same number of elements.');

    hMStar = moldLevelSetpoints.hMStar;

    setpointTrajectory = hMStar * ones(size(t));

    primaryBandLowerBound = ...
        (hMStar - moldLevelSetpoints.tolerances.primary) * ones(size(t));
    primaryBandUpperBound = ...
        (hMStar + moldLevelSetpoints.tolerances.primary) * ones(size(t));

    severeBandLowerBound = ...
        (hMStar - moldLevelSetpoints.tolerances.severe) * ones(size(t));
    severeBandUpperBound = ...
        (hMStar + moldLevelSetpoints.tolerances.severe) * ones(size(t));

    % -- Initialize figure --
    moldLevelTrajectoryPlot = figure;
    hold on;
    grid on;

    % -- Plot trajectory and reference bands --
    trajectory = plot(t, hM, 'b');
    setpoint = plot(t, setpointTrajectory, 'k-');

    primaryBand = plot(t, primaryBandLowerBound, 'k:');
    plot(t, primaryBandUpperBound, 'k:');

    severeBand = plot(t, severeBandLowerBound, 'r:');
    plot(t, severeBandUpperBound, 'r:');

    % -- Apply display spec requirements --
    title(moldLevelDisplaySpec.title);
    xlabel(moldLevelDisplaySpec.xLabel);
    ylabel(moldLevelDisplaySpec.yLabel);

    % -- Add legend if supplied --
    if ~isempty(moldLevelDisplaySpec.legendEntries)
        assert(numel(moldLevelDisplaySpec.legendEntries) == 4, ...
            'plotMoldLevelTrajectory:InvalidLegendEntries', ...
            'legendEntries must contain exactly 4 entries.');

        legend([trajectory; setpoint; primaryBand; severeBand], ...
            moldLevelDisplaySpec.legendEntries, ...
            'Location', 'best');
    end

end