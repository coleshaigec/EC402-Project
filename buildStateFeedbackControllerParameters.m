function stateFeedbackControllerParameters = buildStateFeedbackControllerParameters()
    % BUILDSTATEFEEDBACKCONTROLLERPARAMETERS Sets desired parameters for state feedback controller.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  stateFeedbackControllerParameters struct with fields
    %      .desiredPoles (2 x 1 double);
    %
    % NOTES
    % - This utility exists to enable the user to configure the state
    % feedback controller designed within the pipeline. 
    % - The desired poles are hard-coded within this file. We expect them
    % to be changed throughout the experimentation process as we iterate
    % toward desired behaviors over repeated pipeline runs.

    % -- Set desired poles here --
    desiredPoles = [-0.1; -0.15];

    % -- Populate output struct --
    stateFeedbackControllerParameters = struct();
    stateFeedbackControllerParameters.desiredPoles = desiredPoles;
    
end