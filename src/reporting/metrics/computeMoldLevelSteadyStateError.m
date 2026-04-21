function steadyStateError = computeMoldLevelSteadyStateError(x, hMStar)
    % COMPUTEMOLDLEVELSTEADYSTATEERROR Computes steady-state error of mold level trajectory. 
    %  
    % AUTHOR: Cole H. Shaigec
    %
    % INPUT
    %  x (numTimestamps x 2 double) - simulated state trajectory
    %  hMStar (double)              - mold level setpoint
    %
    % OUTPUT
    %  steadyStateError (double)    - steady-state mold level error
    %
    % NOTES
    % - Although this is a finite-time simulation, we take the final
    % mold-level value to be the limiting behavior. We then compute the
    % deviation of this value from the setpoint to be the steady-state
    % error.

    finalMoldLevel = x(end, 1);
    steadyStateError = abs(finalMoldLevel - hMStar);
end