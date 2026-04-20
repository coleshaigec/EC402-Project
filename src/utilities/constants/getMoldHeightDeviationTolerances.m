function tolerances = getMoldHeightDeviationTolerances()
    % GETMOLDHEIGHTDEVIATIONTOLERANCES Returns tolerances for mold height deviation (in m). 
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  tolerances struct with fields
    %      .primary (double)      - primary band tolerance, in m
    %      .severe (double)       - severe band tolerance, in m
    %
    % NOTES
    % - These tolerances are based on values reported in a paper by LMM
    % Group, a manufacturer of rolling mills and continuous casting
    % systems. 
    % - The paper identifies ~5 mm deviations as indicative of meaningful
    % mold-level fluctuation (typically defined with persistence conditions).
    % We adopt this magnitude as the primary operating envelope without
    % enforcing persistence thresholds.
    % - The paper notes a nontrivial risk of longitudinal cracks on the
    % slab surface when the liquid level fluctuation exceeds 10mm, so we
    % define this as a "severe" fluctuation event

    tolerances = struct();
    tolerances.primary = 0.005;
    tolerances.severe = 0.01;
end
