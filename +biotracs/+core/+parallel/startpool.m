%"""
%bbiotracs.core.parallel.start
%Starts parallel pools for parallel computing
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%"""

function startpool( )
    c = parcluster();
    if isempty(gcp('nocreate'))
        try
            parpool('local',c.NumWorkers);
            %addAttachedFiles(poolobj,{'biotracs.core.env.Env.m'})
        catch err
            warning(...
                'Cannot create parallel pool on ''%s'' cluster with %d workers.\n\n %s', ...
                c.Profile, ...
                c.NumWorkers, ...
                err.message ...
                );
        end
    else
        %fprintf('Parallel pool already started on ''%s'' cluster with %d workers.\n', c.Profile, c.NumWorkers);
    end
end
