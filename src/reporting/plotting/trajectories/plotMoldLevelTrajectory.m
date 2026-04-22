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

    % -- Initialize figure --
    moldLevelTrajectoryPlot = figure;
    hold on; grid on;

    % -- Plot trajectory and superimpose operating point --
    trajectory = plot(moldLevelTrajectory.t, moldLevelTrajectory.x ,'b'); % trajectory as blue line
    setpoint = plot(moldLevelTrajectory.t, moldLevelSetpoints.hMStar, 'k-'); % setpoint as black line
    
    % -- Compute band bounds and add to plot --
    primaryBandLowerBound = moldLevelSetpoints.hMStar - moldLevelSetpoints.tolerances.primary;
    primaryBandUpperBound = moldLevelSetpoints.hMStar + moldLevelSetpoints.tolerances.primary;
    primaryBand = plot(moldLevelTrajectory.t, primaryBandLowerBound, 'k:'); % primary band lower bound
    plot(moldLevelTrajectory.t, primaryBandUpperBound, 'k:'); % primary band upper bound

    severeBandLowerBound = moldLevelSetpoints.hMStar - moldLevelSetpoints.tolerances.severe;
    severeBandUpperBound = moldLevelSetpoints.hMStar + moldLevelSetpoints.tolerances.severe;
    severeBand = plot(moldLevelTrajectory.t, severeBandLowerBound, 'r:'); % severe band lower bound
    plot(moldLevelTrajectory.t, severeBandUpperBound, 'r:'); % severe band upper bound

    % -- Apply display spec requirements --
    title(moldLevelDisplaySpec.title);
    xlabel(moldLevelDisplaySpec.xLabel);
    ylabel(moldLevelDisplaySpec.yLabel);

    % -- If legend entries are supplied, add a legend --
    if ~isempty(moldLevelDisplaySpec.legendEntries)
        legend([trajectory, setpoint, primaryBand, severeBand], ...
            moldLevelDisplaySpec.legendEntries, ...
            'Location', 'best' ...
        );
    end
end