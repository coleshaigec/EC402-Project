function plottingPlan = buildPlottingPlan()
    % BUILDPLOTTINGPLAN Establishes configuration for plotting workflow.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  plottingPlan struct with fields
    %      .trajectories struct with fields
    %          .enabled (logical)
    %          .moldLevel (logical)
    %          .tundishLevel (logical)
    %          .input (logical)
    %          .disturbance (logical)
    %      .comparisons struct with fields
    %          .enabled (logical)
    %          .stateFeedbackVsLQR (logical)
    %          .linearVsNonlinear (logical)
    %      .observer struct with fields
    %          .enabled (logical)
    %          .xHatTrajectory (logical)
    %          .estimationErrorNormTrajectory (logical)
    %      .phasePortraits struct with fields
    %          .enabled (logical)
    %          .linear (logical)
    %          .nonlinear (logical)
    %      .summary struct with fields
    %          .enabled (logical)
    %          .fractionOutsidePrimaryBand (logical)
    %          .fractionOutsideSevereBand (logical)
    %          .peakMoldDeviation (logical)
    %          .controlEnergy (logical)
    %          .peakDeviationControlEnergyScatter (logical)
    %
    % NOTES
    % - This utility is supplied to allow the user to configure the
    % plotting plan. It toggles specific plots on and off at user
    % discretion.
    % - For easy configuration, the .enabled flag is provided for each
    % plot family. If this flag is set to false, that family of plots will
    % be ignored irrespective of the lower-level flag values.
    

    % For each 

    % Each field in plotting plan is logical 1 if enabled, logical 0 if not
    plottingPlan = struct();

    % -- Configure trajectory plotting --
    plottingPlan.trajectories = struct();
    plottingPlan.trajectories.enabled = true;
    plottingPlan.trajectories.moldLevel = true;
    plottingPlan.trajectories.tundishLevel = true;
    plottingPlan.trajectories.input = true;
    plottingPlan.trajectories.disturbance = true;

    % -- Configure comparison plots between controllers --
    plottingPlan.comparisons = struct();
    plottingPlan.comparisons.enabled = false;
    plottingPlan.comparisons.stateFeedbackVsLQR = true;
    plottingPlan.comparisons.linearVsNonlinear = true;

    % -- Configure observer plots --
    plottingPlan.observer = struct();
    plottingPlan.observer.enabled = false;
    plottingPlan.observer.xHatTrajectory = true;
    plottingPlan.observer.estimationErrorNormTrajectory = true;
    
    % -- Configure phase portrait plots --
    plottingPlan.phasePortraits = struct();
    plottingPlan.phasePortraits.enabled = true;
    plottingPlan.phasePortraits.linear = true;
    plottingPlan.phasePortraits.nonlinear = true;

    % -- Configure summary plots --
    plottingPlan.summary = struct();
    plottingPlan.summary.enabled = true; % toggle these off for now
    plottingPlan.summary.fractionOutsidePrimaryBand = true;
    plottingPlan.summary.fractionOutsideSevereBand = true;
    plottingPlan.summary.peakMoldDeviation = true;
    plottingPlan.summary.controlEnergy = true;
    plottingPlan.summary.peakDeviationControlEnergyScatter = true;
end