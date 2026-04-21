function outputPlan = buildExperimentOutputPlan(numRuns, plottingPlan)
    % BUILDEXPERIMENTOUTPUTPLAN Defines output plan for reporting workflow.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  numRuns (positive integer) - number of pipeline runs to report
    %  plottingPlan struct        - plotting configuration
    %
    % OUTPUT
    %  outputPlan struct with fields
    %      .projectRoot (string)
    %      .outputsRoot (string)
    %      .experimentRoot (string)
    %      .summary struct with fields
    %          .root (string)
    %          .tableDirectory (string)
    %          .tableFileName (string)
    %          .tableFilePath (string)
    %          .plotsDirectory (string) - iff summary plots enabled
    %      .comparisons struct with fields
    %          .root (string)
    %          .plotsDirectory (string) - iff comparison plots enabled
    %      .runsRoot (string)
    %      .runs array of structs, each with fields
    %          .runFolderName (string)
    %          .root (string)
    %          .plotPaths struct with fields
    %              .trajectoriesDirectory (string) - iff trajectory plots enabled
    %              .observerDirectory (string) - iff observer plots enabled
    %              .phasePortraitsDirectory (string) - iff phase portraits enabled

    projectRoot = getProjectRoot();

    % -- Populate root folder paths --
    outputsRoot = fullfile(projectRoot, "outputs");
    experimentTimestamp = string(datetime('now', 'Format', 'HH-mm-ss_yyyy-MM-dd'));
    experimentFolderName = "EXPERIMENT_" + experimentTimestamp;
    experimentRoot = fullfile(outputsRoot, experimentFolderName);

    % -- Plan file structure for summary outputs --
    summaryRoot = fullfile(experimentRoot, "summary");
    summaryTableDirectory = fullfile(summaryRoot, "tables");
    summaryTableFileName = "TABLE_" + experimentFolderName + ".csv";
    summaryTableFilePath = fullfile(summaryTableDirectory, summaryTableFileName);

    % -- Add core fields to output struct --
    outputPlan = struct();
    outputPlan.projectRoot = projectRoot;
    outputPlan.outputsRoot = outputsRoot;
    outputPlan.experimentRoot = experimentRoot;

    outputPlan.summary = struct();
    outputPlan.summary.root = summaryRoot;
    outputPlan.summary.tableDirectory = summaryTableDirectory;
    outputPlan.summary.tableFileName = summaryTableFileName;
    outputPlan.summary.tableFilePath = summaryTableFilePath;

    % -- Plan file structure for summary and comparison plots, if enabled --
    if plottingPlan.summary.enabled
        outputPlan.summary.plotsDirectory = fullfile(summaryRoot, "plots");
    end

    if plottingPlan.comparisons.enabled
        comparisonRoot = fullfile(experimentRoot, "comparisons");
        outputPlan.comparisons = struct();
        outputPlan.comparisons.root = comparisonRoot;
        outputPlan.comparisons.plotsDirectory = fullfile(comparisonRoot, "plots");
    end

    % -- Plan file structure for runs folder --
    runsRoot = fullfile(experimentRoot, "runs");
    outputPlan.runsRoot = runsRoot;

    templateRunOutputPlan = buildTemplateRunOutputPlan();
    runs = repmat(templateRunOutputPlan, numRuns, 1);

    for i = 1:numRuns
        runFolderName = "RUN_" + sprintf('%03d', i);
        runRoot = fullfile(runsRoot, runFolderName);

        runs(i).runFolderName = runFolderName;
        runs(i).root = runRoot;
        runs(i).plotPaths = struct();

        if plottingPlan.trajectories.enabled
            runs(i).plotPaths.trajectoriesDirectory = fullfile(runRoot, "trajectories");
        end

        if plottingPlan.observer.enabled
            runs(i).plotPaths.observerDirectory = fullfile(runRoot, "observer");
        end

        if plottingPlan.phasePortraits.enabled
            runs(i).plotPaths.phasePortraitsDirectory = fullfile(runRoot, "phasePortraits");
        end
    end

    outputPlan.runs = runs;
end