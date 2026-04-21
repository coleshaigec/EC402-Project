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

    
    outputFolder = fullfile(projectRoot, 'outputs');

    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder);
    end

    outputPath = fullfile(outputFolder, filename);
end