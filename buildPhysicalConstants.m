function physicalConstants = buildPhysicalConstants()
    % BUILDPHYSICALCONSTANTS Defines physical constants for use in simulation.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  physicalConstants struct with fields
    %      .g (double)   - acceleration due to gravity

    physicalConstants = struct();
    physicalConstants.g = 9.81;
end