function writeFigureToOutput(fig, targetDirectory, baseFileName)
    % WRITEFIGURETOOUTPUT Saves figure as PNG in specified output directory.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUTS
    %  fig (1,1) matlab.ui.Figure - figure handle to write
    %  targetDirectory (string)   - directory in which to save figure
    %  baseFileName (string)      - filename stem, without extension
    %
    % SIDE EFFECTS
    %  Writes PNG file to targetDirectory and closes the figure.
    %
    % NOTES
    % - This utility centralizes figure export so that plotting utilities do
    %   not need to know about file naming, extensions, or output-path
    %   plumbing.
    % - The output format is fixed to PNG to keep export behavior simple and
    %   consistent across the reporting workflow.

    % -- Fail fast if bad inputs are supplied --
    arguments
        fig (1,1) matlab.ui.Figure
        targetDirectory (1,1) string
        baseFileName (1,1) string
    end

    % -- Ensure target directory exists --
    if ~isfolder(targetDirectory)
        mkdir(targetDirectory);
    end

    % -- Build output file path --
    outputFilePath = fullfile(targetDirectory, baseFileName + ".png");

    % -- Export figure and close it --
    exportgraphics(fig, outputFilePath, 'Resolution', 300);
    close(fig);
end