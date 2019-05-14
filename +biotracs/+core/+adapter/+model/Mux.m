%"""
%biotracs.core.adapter.model.Mux
%An Mux is an multiplexer Adapter used to aggregate several Resource objects in a single ResourceSet object.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.adapter.model.Demux
%"""

classdef Mux < biotracs.core.adapter.model.Adapter

    properties
    end
    
    methods
        
        function this = Mux()
            this@biotracs.core.adapter.model.Adapter();
            
            % enhance inputs specs
            this.addInputSpecs({...
                struct(...
                'name', 'Resource',...
                'class', 'biotracs.core.mvc.model.Resource', ...
                'multiplicity', 1 ...
                )...
                });
            this.input.setIsResizable(true);
            
            % enhance outputs specs
            this.addOutputSpecs({...
                struct(...
                'name', 'ResourceSet',...
                'class', 'biotracs.core.mvc.model.ResourceSet' ...
                )...
                });
        end

    end
    
    
    methods(Access = protected)
        
        function doRun( this )
            n = this.input.getLength();
            result = this.getOutputPortData('ResourceSet');
            result.allocate(n);
            logStr = cell(1,n);
            for i=1:n
                r = this.input.getPortAt(i).getData();
                result.setAt(i, r);
                logStr{i} = ['Resource#',num2str(i),': ', r.getLabel()];
            end
            this.logger.writeLog( '%s', sprintf('%s\n',logStr{:}));
            
            this.setOutputPortData('ResourceSet', result);
        end
        
    end
end
