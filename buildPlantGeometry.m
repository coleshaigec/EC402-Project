function plantGeometry = buildPlantGeometry()
    % BUILDPLANTGEOMETRY Defines geometric properties of plant.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  plantGeometry struct with fields
    %      .moldCrossSectionWidth      (double)
    %      .moldCrossSectionLength     (double)
    %      .moldCrossSectionalArea     (double)
    %      .moldAxialLength            (double)
    %      .nozzleCrossSectionalArea   (double)
    %      .tundishCrossSectionalArea  (double)
    %
    % NOTES
    %  - All lengths are measured in meters, all areas in m^2, and all
    %  volumes in m^3.
    %  - The geometry of our plant is hard-coded with dimensions
    %  approximating patterns observed in the literature. Our plant was not
    %  designed as an isomorph of any real facility or as the result of any
    %  rigorous analysis.
    %  - The geometry is defined as a representative continuous slab-casting 
    %  configuration using literature-consistent dimensions where available. 
    %  - The tundish quantity is treated as an effective cross-sectional area for a 
    %  reduced-order level-dynamics model rather than as an exact vessel design.

    plantGeometry = struct();
    
    % -- Define mold geometry --
    plantGeometry.moldCrossSectionWidth = 0.220;
    plantGeometry.moldCrossSectionLength = 1.320;
    plantGeometry.moldCrossSectionalArea = plantGeometry.moldCrossSectionWidth * plantGeometry.moldCrossSectionLength;
    plantGeometry.moldAxialLength = 0.810;

    % -- Define nozzle geometry --
    nozzleDiameter = 0.075; % [m]
    plantGeometry.nozzleCrossSectionalArea = pi * (nozzleDiameter / 2)^2;

    % -- Define tundish geometry --
    plantGeometry.tundishCrossSectionalArea = 2.0;

end