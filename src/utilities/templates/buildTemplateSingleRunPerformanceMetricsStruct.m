function templateSingleRunPerformanceMetricsStruct = buildTemplateSingleRunPerformanceMetricsStruct()
    % BUILDTEMPLATESINGLERUNPERFORMANCEMETRICSSTRUCT Builds template single-run performance metrics struct for preallocation.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  templateSingleRunPerformanceMetricsStruct struct with fields
    %      .linear 
    %      .nonlinear 

    templateSingleRunPerformanceMetricsStruct = struct( ...
        'linear', [], ...
        'nonlinear', [] ...
    );
end