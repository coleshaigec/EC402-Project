function evaluator = buildDisturbanceEvaluator(disturbanceScenario)
    % BUILDDISTURBANCEEVALUATOR Parses a disturbance scenario and packages it into an anonymous function usable by ODE45. 
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  disturbanceScenario struct with fields
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
    % OUTPUT
    %  evaluator (anonymous function)

    % -- In baseline disturbance scenario, return the zero vector --
    if strcmp(disturbanceScenario.name, 'baseline')
       evaluator = @(t) evaluateBaselineDisturbance(t);

    % -- For non-baseline scenarios, evaluate by channel --
    else 
        dlEvaluator = buildSingleChannelDisturbanceEvaluator(disturbanceScenario.channels.dl);
        dnEvaluator = buildSingleChannelDisturbanceEvaluator(disturbanceScenario.channels.dn);
        dwEvaluator = buildSingleChannelDisturbanceEvaluator(disturbanceScenario.channels.dw);
        evaluator = @(t) [
            dlEvaluator(t);
            dnEvaluator(t);
            dwEvaluator(t)
        ];
    end
end