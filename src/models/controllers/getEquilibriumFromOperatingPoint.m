function equilibrium = getEquilibriumFromOperatingPoint(operatingPoint)
    % GETEQUILIBRIUMFROMOPERATINGPOINT Computes equilibrium values from specified operating point.
    %
    % AUTHOR: Richie Kim
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

    requiredFields = {'K', 'vW', 'hT', 'hM', 'Qladle', 'uM'};

    for i = 1:length(requiredFields)
        if ~isfield(operatingPoint, requiredFields{i})
            error('getEquilibriumFromOperatingPoint:MissingField', ...
                'operatingPoint is missing required field: %s', requiredFields{i});
        end
    end

    equilibrium = struct();

    equilibrium.xe = [
        operatingPoint.hM;
        operatingPoint.hT
    ];

    equilibrium.ue = [
        operatingPoint.uM;
        operatingPoint.vW
    ];

    % -- Output validation - please do not remove
    validateEquilibrium(equilibrium, operatingPoint);
end