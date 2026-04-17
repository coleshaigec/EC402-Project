function simulationResult = simulateLinearClosedLoopFullState(closedLoopAnalysisPlan)
    % SIMULATELINEARCLOSEDLOOPFULLSTATE Simulates closed-loop dynamics for linear plant with full observability. 
    %
    % AUTHOR: Richie Kim/Dani Schwartz
    %
    % INPUT
    %  closedLoopAnalysisPlan struct with fields 
    %      .linearPlant struct with fields
    %          .A (2 x 2 double) - state Jacobian, evaluated at operating point
    %          .B (2 x 2 double) - input Jacobian, evaluated at operating point
    %          .E (2 x 3 double) - disturbance Jacobian, evaluated at operating point
    %          .metadata struct with fields
    %              .operatingPoint struct with fields
    %                  .K        (double)    - plant-specific proportionality constant
    %                  .vW       (double)    - computed withdrawal speed at operating point
    %                  .hT       (double)    - computed tundish height
    %                  .hM       (double)    - prescribed molds height at operating point
    %                  .Qladle   (double)    - computed ladle -> tundish flow rate
    %                  .uM       (double)    - prescribed tundish -> mold flow regulation setting
    %              .plantGeometry struct with fields
    %                  .moldCrossSectionWidth      (double)
    %                  .moldCrossSectionLength     (double)
    %                  .moldCrossSectionalArea     (double)
    %                  .moldAxialLength            (double)
    %                  .nozzleCrossSectionalArea   (double)
    %                  .tundishCrossSectionalArea  (double)
    %              .physicalConstants struct with fields
    %                  .g (double)    - acceleration due to gravity
    %
    %      .duration (double) - length of simulation
    %
    %      .controller struct with fields
    %          .type (string) - either 'stateFeedback' or 'lqr'
    %          .gains (2 x 2 double) 
    %          .equilibrium struct with fields
    %              .xe (state equilibrium)
    %              .ue (input equilibrium)
    %          .designMetadata struct with controller-specific fields
    %
    % OUTPUT
    %  simulationResult struct with fields
    %      .timestamps (numTimestamps x 1 double)
    %      .x (numTimestamps x 2 double) - simulated state trajectory
    %      .xDot (numTimestamps x 2 double) - simulated state derivative trajectory
    %      .u (numTimestamps x 2 double) - simulated input trajectory
    %      .d (numTimestamps x 3 double) - simulated disturbance trajectory
    %
    % NOTES
    % - This function uses MATLAB's ODE45 
end