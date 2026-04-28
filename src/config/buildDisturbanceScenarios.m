function disturbanceScenarios = buildDisturbanceScenarios(chosenDisturbanceScenarios)
    % BUILDDISTURBANCESCENARIOS Selects disturbance scenarios from a hard-coded set and maps them into a struct digestible by the simulation planner.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  chosenDisturbanceScenarios (1 x N cell array of char vectors or strings)
    %
    % OUTPUT
    %  disturbanceScenarios array of structs, each with fields
    %      .name
    %      .descriptionString
    %      .shouldApplyToLinearPlant
    %      .shouldApplyToNonlinearPlant
    %      .channels struct with fields
    %          .dl struct with fields
    %              .isActive           (boolean)
    %              .functionalForm     (string)
    %              .parameters struct with scenario-specific fields
    %          .dn struct with fields
    %              .isActive           (boolean)
    %              .functionalForm     (string)
    %              .parameters struct with scenario-specific fields
    %          .dw struct with fields
    %              .isActive           (boolean)
    %              .functionalForm     (string)
    %              .parameters struct with scenario-specific fields
    %
    % NOTES
    % - These disturbance scenarios are hard-coded and may be reconfigured
    % at the user's discretion by changing the parameters within this file. 
    % - These scenarios were designed by the experimenters to act as
    % plausible facsimiles to disturbances that may arise during
    % operation of a continuous casting system.
    % - To avoid a combinatorial number of simulation pipeline runs, a
    % subset of these scenarios is selected for a given experiment.

    % -- Preallocate output struct array -- 
    numScenariosToBuild = numel(chosenDisturbanceScenarios);
    templateDisturbanceScenario = buildTemplateDisturbanceScenarioStruct();

    disturbanceScenarios = repmat(templateDisturbanceScenario, numScenariosToBuild, 1);

    % -- Populate output struct array --
    for i = 1 : numScenariosToBuild
        chosenScenario = chosenDisturbanceScenarios{i};
        currentScenario = templateDisturbanceScenario;
        currentScenario.name = chosenScenario;

        switch chosenScenario
            case 'baseline'
                currentScenario.descriptionString = "Baseline: no disturbance";
                currentScenario.shouldApplyToLinearPlant = false;
                currentScenario.shouldApplyToNonlinearPlant = false;
                currentScenario.channels.dl.isActive = false;
                currentScenario.channels.dn.isActive = false;
                currentScenario.channels.dw.isActive = false;
            case 'ladleConstant'
                currentScenario.descriptionString = "Constant ladle -> tundish flow disturbance";
                currentScenario.shouldApplyToLinearPlant = true;
                currentScenario.shouldApplyToNonlinearPlant = true;
                currentScenario.channels.dl.isActive = true;
                currentScenario.channels.dl.functionalForm = 'constant';
                currentScenario.channels.dl.parameters.amplitude = 0.002;
                currentScenario.channels.dn.isActive = false;
                currentScenario.channels.dw.isActive = false;
            case 'ladleStep'
                currentScenario.descriptionString = "Ladle -> tundish flow step disturbance";
                currentScenario.shouldApplyToLinearPlant = true;
                currentScenario.shouldApplyToNonlinearPlant = true;
                currentScenario.channels.dl.isActive = true;
                currentScenario.channels.dl.functionalForm = 'step';
                currentScenario.channels.dl.parameters.amplitude = 0.002;
                currentScenario.channels.dl.parameters.startTime = 250;
                currentScenario.channels.dn.isActive = false;
                currentScenario.channels.dw.isActive = false;
            case 'ladlePulse'
                currentScenario.descriptionString = "Transient pulse disturbance to ladle -> tundish flow";
                currentScenario.shouldApplyToLinearPlant = true;
                currentScenario.shouldApplyToNonlinearPlant = true;
                currentScenario.channels.dl.isActive = true;
                currentScenario.channels.dl.functionalForm = 'pulse';
                currentScenario.channels.dl.parameters.amplitude = 0.002;
                currentScenario.channels.dl.parameters.startTime = 100;
                currentScenario.channels.dl.parameters.endTime = 250;
                currentScenario.channels.dn.isActive = false;
                currentScenario.channels.dw.isActive = false;
            case 'nozzleConstant'
                currentScenario.descriptionString = "Constant nozzle flow disturbance";
                currentScenario.shouldApplyToLinearPlant = true;
                currentScenario.shouldApplyToNonlinearPlant = true;
                currentScenario.channels.dl.isActive = false;
                currentScenario.channels.dn.isActive = true;
                currentScenario.channels.dn.functionalForm = 'constant';
                currentScenario.channels.dn.parameters.amplitude = 0.15;
                currentScenario.channels.dw.isActive = false;
            case 'nozzleStep'
                currentScenario.descriptionString = "Step disturbance to nozzle flow";
                currentScenario.shouldApplyToLinearPlant = true;
                currentScenario.shouldApplyToNonlinearPlant = true;
                currentScenario.channels.dl.isActive = false;
                currentScenario.channels.dn.isActive = true;
                currentScenario.channels.dn.functionalForm = 'step';
                currentScenario.channels.dn.parameters.amplitude = 0.3;
                currentScenario.channels.dn.parameters.startTime = 300;
                currentScenario.channels.dw.isActive = false;
            case 'nozzlePulse'
                currentScenario.descriptionString = "Transient pulse disturbance to nozzle flow";
                currentScenario.shouldApplyToLinearPlant = true;
                currentScenario.shouldApplyToNonlinearPlant = true;
                currentScenario.channels.dl.isActive = false;
                currentScenario.channels.dn.isActive = true;
                currentScenario.channels.dn.functionalForm = 'pulse';
                currentScenario.channels.dn.parameters.amplitude = 0.2;
                currentScenario.channels.dn.parameters.startTime = 100;
                currentScenario.channels.dn.parameters.endTime = 250;
                currentScenario.channels.dw.isActive = false;
            case 'withdrawalConstant'
                currentScenario.descriptionString = "Constant mechanical disturbance in withdrawal mechanism";
                currentScenario.shouldApplyToLinearPlant = true;
                currentScenario.shouldApplyToNonlinearPlant = true;
                currentScenario.channels.dl.isActive = false;
                currentScenario.channels.dn.isActive = false;
                currentScenario.channels.dw.isActive = true;
                currentScenario.channels.dw.functionalForm = 'constant';
                currentScenario.channels.dw.parameters.amplitude = 0.1;
            case 'withdrawalStep'
                currentScenario.descriptionString = "Step mechanical disturbance in withdrawal mechanism";
                currentScenario.shouldApplyToLinearPlant = true;
                currentScenario.shouldApplyToNonlinearPlant = true;
                currentScenario.channels.dl.isActive = false;
                currentScenario.channels.dn.isActive = false;
                currentScenario.channels.dw.isActive = true;
                currentScenario.channels.dw.functionalForm = 'step';
                currentScenario.channels.dw.parameters.amplitude = 0.1;
                currentScenario.channels.dw.parameters.startTime = 300;
            case 'withdrawalPulse'
                currentScenario.descriptionString = "Transient pulse disturbance in withdrawal mechanism";
                currentScenario.shouldApplyToLinearPlant = true;
                currentScenario.shouldApplyToNonlinearPlant = true;
                currentScenario.channels.dl.isActive = false;
                currentScenario.channels.dn.isActive = false;
                currentScenario.channels.dw.isActive = true;
                currentScenario.channels.dw.functionalForm = 'pulse';
                currentScenario.channels.dw.parameters.amplitude = 0.1;
                currentScenario.channels.dw.parameters.startTime = 100;
                currentScenario.channels.dw.parameters.endTime = 250;
            otherwise
                error('buildDisturbanceScenarios:InvalidFieldValue', ...
                    'Specified disturbance scenario %s does not exist', ...
                    chosenScenario ...
                );
        end
        disturbanceScenarios(i) = currentScenario;
    end
end