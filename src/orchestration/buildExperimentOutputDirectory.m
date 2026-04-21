function buildExperimentOutputDirectory(outputPlan)
    % BUILDEXPERIMENTOUTPUTDIRECTORY Constructs output directory to house plots and summary table.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  outputPlan struct with fields
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
    %          .plotPaths struct with optional fields
    %              .trajectoriesDirectory (string)
    %              .observerDirectory (string)
    %              .phasePortraitsDirectory (string)
    %
    % SIDE EFFECTS
    %  Creates experiment output directory and all required subdirectories.

    % -- Create experiment root and summary directories --
    ensureDirectoryExists(outputPlan.experimentRoot);
    ensureDirectoryExists(outputPlan.summary.root);
    ensureDirectoryExists(outputPlan.summary.tableDirectory);

    if isfield(outputPlan.summary, 'plotsDirectory')
        ensureDirectoryExists(outputPlan.summary.plotsDirectory);
    end

    % -- Create comparison directories, if present --
    if isfield(outputPlan, 'comparisons')
        ensureDirectoryExists(outputPlan.comparisons.root);
        ensureDirectoryExists(outputPlan.comparisons.plotsDirectory);
    end

    % -- Create run root and per-run subdirectories --
    ensureDirectoryExists(outputPlan.runsRoot);

    for i = 1:numel(outputPlan.runs)
        ensureDirectoryExists(outputPlan.runs(i).root);

        if isfield(outputPlan.runs(i), 'plotPaths') && isstruct(outputPlan.runs(i).plotPaths)
            plotPathFieldNames = fieldnames(outputPlan.runs(i).plotPaths);

            for j = 1:numel(plotPathFieldNames)
                thisFieldName = plotPathFieldNames{j};
                thisDirectory = outputPlan.runs(i).plotPaths.(thisFieldName);
                ensureDirectoryExists(thisDirectory);
            end
        end
    end
end

function ensureDirectoryExists(directoryPath)
    % ENSUREDIRECTORYEXISTS Creates directory if it does not already exist.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  directoryPath (string)

    if ~isfolder(directoryPath)
        mkdir(directoryPath);
    end
end