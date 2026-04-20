function templateDisturbanceScenarioStruct = buildTemplateDisturbanceScenarioStruct()
    % BUILDTEMPLATEDISTURBANCESCENARIOSTRUCT Builds template struct for preallocation of disturbance scenario struct array.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  templateDisturbanceScenarioStruct struct with fields
    %      .name
    %      .descriptionString
    %      .shouldApplyToLinearPlant
    %      .shouldApplyToNonlinearPlant
    %      .channels struct with fields
    %          .dl struct with fields
    %              .isActive           
    %              .functionalForm     
    %              .parameters struct with scenario-specific fields
    %          .dn struct with fields
    %              .isActive           
    %              .functionalForm     
    %              .parameters struct with scenario-specific fields
    %          .dw struct with fields
    %              .isActive           
    %              .functionalForm     
    %              .parameters struct with scenario-specific fields

    templateDisturbanceScenarioStruct = struct();
    templateDisturbanceScenarioStruct.name = [];
    templateDisturbanceScenarioStruct.descriptionString = [];
    templateDisturbanceScenarioStruct.shouldApplyToLinearPlant = [];
    templateDisturbanceScenarioStruct.shouldApplyToNonlinearPlant = [];
    templateDisturbanceScenarioStruct.channels = struct();
    templateDisturbanceScenarioStruct.channels.dl = struct();
    templateDisturbanceScenarioStruct.channels.dl.isActive = [];
    templateDisturbanceScenarioStruct.channels.dl.functionalForm = [];
    templateDisturbanceScenarioStruct.channels.dl.parameters = [];
    templateDisturbanceScenarioStruct.channels.dn = struct();
    templateDisturbanceScenarioStruct.channels.dn.isActive = [];
    templateDisturbanceScenarioStruct.channels.dn.functionalForm = [];
    templateDisturbanceScenarioStruct.channels.dn.parameters = [];
    templateDisturbanceScenarioStruct.channels.dw = struct();
    templateDisturbanceScenarioStruct.channels.dw.isActive = [];
    templateDisturbanceScenarioStruct.channels.dw.functionalForm = [];
    templateDisturbanceScenarioStruct.channels.dw.parameters = [];
end