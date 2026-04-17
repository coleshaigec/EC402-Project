function simulationResult = simulateLinearClosedLoopFullState(closedLoopAnalysisPlan)
    % SIMULATELINEARCLOSEDLOOPFULLSTATE Simulates closed-loop dynamics for linear plant with full observability. 
    %
    % AUTHOR: Richie Kim/Dani Schwartz
    %
    % INPUT
    %  closedLoopAnalysisPlan struct with fields 
    
    %
    %      .duration (double) - length of simulation
    %
   
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