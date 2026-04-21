function outputPath = getOutputPath(filename)
    % GETOUTPUTPATH Returns relative path from caller to outputs folder.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  filename (string)
    %
    % OUTPUT
    %  outputPath (string)

    currentFilePath = mfilename('fullpath');
    currentFolder = fileparts(currentFilePath);

    % -- Walk up until project root is found (contains 'src' and/or 'outputs') --
    while ~isfolder(fullfile(currentFolder, 'src'))
        parentFolder = fileparts(currentFolder);

        % -- Safety guard to avoid infinite loop --
        if strcmp(parentFolder, currentFolder)
            error('getOutputPath:ProjectRootNotFound', ...
                'Could not locate project root.');
        end

        currentFolder = parentFolder;
    end

    projectRoot = currentFolder;
    outputFolder = fullfile(projectRoot, 'outputs');

    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end

    outputPath = fullfile(outputFolder, filename);
end