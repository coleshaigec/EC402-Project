function safetyRequirements = buildSafetyRequirements()
    % BUILDSAFETYREQUIREMENTS Defines solidification front safety requiremetns.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  safetyRequirements struct with fields
    %      .safeShellThickness         (double)
    %      .safetyFactor               (double in [0,1])
    %
    % NOTES
    % - The safety factor is a dimensionless proportionality constant. 
    % - Our reading of the literature did not find a universal rule for
    % setting safety factors. We thus adopt a safety factor of 0.8 as a
    % balance between conservatism and throughput.
    % - Determination of the safe solidification front is a complex
    % metallurgical calculation that is beyond the scope of this study. We
    % thus define a representative shell thickness by adding a ~2mm margin
    % to the thicknesses at which breakout was observed in Thomas, Lui, and Ho (1997). 
    % - The shell thickness is measured in meters. 

    safetyRequirements = struct();
    safetyRequirements.safetyFactor = 0.8;
    safetyRequirements.safeShellThickness = 0.025;

end