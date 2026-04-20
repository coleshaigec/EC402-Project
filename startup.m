function startup()
    % STARTUP Initializes environment at the beginning of a MATLAB session.
    %
    % AUTHOR: Cole H. Shaigec

    % -- Add source code folders to searchable path --
    projectRoot = fileparts(mfilename('fullpath'));
    srcRoot = fullfile(projectRoot, 'src');

    addpath(genpath(srcRoot));

    fprintf('Project source folders added to path.\n');
end