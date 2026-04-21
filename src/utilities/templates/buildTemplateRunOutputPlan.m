
function templateRunOutputPlan = buildTemplateRunOutputPlan()
    % BUILDTEMPLATERUNOUTPUTPLAN Builds template struct for preallocation of
    % run subfield in outputPlan.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  templateRunOutputPlan struct with fields
    %      .runFolderName
    %      .root
    %      .plotPaths

    templateRunOutputPlan = struct();
    templateRunOutputPlan.runFolderName = [];
    templateRunOutputPlan.root = [];
    templateRunOutputPlan.plotPaths = [];
end