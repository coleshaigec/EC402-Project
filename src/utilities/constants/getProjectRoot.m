function projectRoot = getProjectRoot()
    % GETPROJECTROOT Returns project root path.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  projectRoot (string)
    %
    % NOTES
    % - Assumes this function is located somewhere under the project root.
    % - Project root is identified as the first parent directory containing
    %   both 'src' and 'outputs' folders.

    currentFilePath = mfilename('fullpath');
    currentFolder = fileparts(currentFilePath);

    % -- Walk up until project root is found --
    while ~(isfolder(fullfile(currentFolder, 'src')) && ...
            isfolder(fullfile(currentFolder, 'outputs')))

        parentFolder = fileparts(currentFolder);

        % -- Safety guard to avoid infinite loop --
        if strcmp(parentFolder, currentFolder)
            error('getProjectRoot:ProjectRootNotFound', ...
                'Could not locate project root.');
        end

        currentFolder = parentFolder;
    end

    projectRoot = currentFolder;
end