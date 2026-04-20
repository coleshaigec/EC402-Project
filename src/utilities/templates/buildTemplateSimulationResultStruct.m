function templateSimulationResultStruct = buildTemplateSimulationResultStruct()
    % BUILDTEMPLATESIMULATIONRESULTSTRUCT Builds template simulationResult struct for preallocation.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  templateSimulationResultStruct struct with fields 
    
    templateSimulationResultStruct = struct();
    templateSimulationResultStruct.linearPlant = [];
    templateSimulationResultStruct.nonlinearPlant = [];
    templateSimulationResultStruct.measurementModel = [];
    templateSimulationResultStruct.openLoopResult = [];
    templateSimulationResultStruct.controller = [];
    templateSimulationResultStruct.nonlinearClosedLoopResult = [];
    templateSimulationResultStruct.linearClosedLoopResult = [];
    templateSimulationResultStruct.observabilityCase = [];
end