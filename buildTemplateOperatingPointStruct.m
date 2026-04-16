function templateOperatingPointStruct = buildTemplateOperatingPointStruct()
    % BUILDTEMPLATEOPERATINGPOINTSTRUCT Builds a representative operating point struct for use in preallocation of struct arrays.
    %
    % AUTHOR: Cole H. Shaigec
    %
    % OUTPUT
    %  templateOperatingPointStruct struct with fields
    %      .K        
    %      .vW       
    %      .hT       
    %      .hM       
    %      .Qladle   
    %      .uM       

    templateOperatingPointStruct = struct( ...
        'K', [], ...
        'vW', [], ...
        'hT', [], ...
        'hM', [], ...
        'Qladle', [], ...
        'uM', [] ...
     );
end



% OUTPUT
    