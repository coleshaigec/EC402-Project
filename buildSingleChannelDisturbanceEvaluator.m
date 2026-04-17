function evaluator = buildSingleChannelDisturbanceEvaluator(channel)
    % BUILDSINGLECHANNELDISTURBANCEEVALUATOR Builds an anonymous function to evaluate a single element in the disturbance vector at time t.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  channel struct with fields
    %      .isActive           (boolean)
    %      .functionalForm     (string)
    %      .parameters struct with scenario-specific fields
    %
    % OUTPUT
    %  evaluator (anonymous function) - computes disturbance element at
    %  time t

    if channel.isActive
        switch channel.functionalForm
            case 'constant'
                evaluator = @(t) channel.parameters.amplitude;
            case 'step'
                evaluator = @(t) evaluateStepDisturbance(t, ...
                    channel.parameters.startTime, ...
                    channel.parameters.amplitude ...
                );
            case 'pulse'
                evaluator = @(t) evaluatePulseDisturbance(t, ...
                    channel.parameters.startTime, ...
                    channel.parameters.endTime, ...
                    channel.parameters.amplitude ...
                );
            otherwise
                error('buildSingleChannelDisturbanceEvaluator:InvalidFieldValue', ...
                    'Disturbance functional form %s is invalid', channel.functionalForm ...
                );
        end
    else
        evaluator = @(t) 0; % return 0 if not active
    end
end