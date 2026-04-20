function equilibrium = getEquilibriumFromOperatingPoint(operatingPoint)
    % GETEQUILIBRIUMFROMOPERATINGPOINT Computes equilibrium values from specified operating point.
    %
    % AUTHOR: Dani Schwartz/Richie Kim
    %
    % INPUT
    %  operatingPoint struct with fields
    %      .K        (double)    - plant-specific proportionality constant
    %      .vW       (double)    - computed withdrawal speed at operating point
    %      .hT       (double)    - computed tundish height
    %      .hM       (double)    - prescribed mold height at operating point
    %      .Qladle   (double)    - computed ladle -> tundish flow rate
    %      .uM       (double)    - prescribed tundish -> mold flow regulation setting
    %
    % OUTPUT
    %  equilibrium struct with fields
    %      .xe (2 x 1 double) - equilibrium state
    %      .ue (2 x 1 double) - equilibrium input

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % NOTES FOR IMPLEMENTATION %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % - Please do not delete the docstring above.
    % - Build xe and ue directly from the supplied operating point using the
    %   equilibrium formula shown in the project plan.
    % - The formula in the project plan expresses the equilibrium as a
    % difference between states -- you may need to do some algebra to
    % rearrange and get the exact state values.
    % - Use the canonical state ordering:
    %       xe = [hT; hM]
    % - Use the canonical input ordering:
    %       ue = [Qladle; uM]
    % - Both xe and ue must be column vectors, not row vectors.
    % - Do not recompute the operating point inside this function. Treat the
    %   input struct as the single source of truth.
    % - Do not hard-code scenario-specific numerical values in this function.
    % - Validate that all required operatingPoint fields are present before
    %   constructing the output.
    % - The output must be a struct with exactly two fields:
    %       equilibrium.xe
    %       equilibrium.ue

    % -- YOUR IMPLEMENTATION HERE -- 
    equilibrium = struct();
    equilibrium.xe = [];
    equilibrium.ue = [];

end