%"""
%biotracs.core.adapter.model.Merger
%An Merger is an Adapter that merge several ResourceSet contents in a single ResourceSet
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%"""

classdef Merger < biotracs.core.adapter.model.Adapter

    properties
    end
    
    methods
        
        function this = Merger()
            this@biotracs.core.adapter.model.Adapter();
            
            % enhance inputs specs
            this.addInputSpecs({...
                struct(...
                'name', 'ResourceSet',...
                'class', 'biotracs.core.mvc.model.ResourceSet', ...
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
            if n == 1
                data = this.input.getPortAt(1).getData();
                this.setOutputPortData('ResourceSet', data);
                this.setIsPhantom(true);
                logStr{1} = ['Pass single ResourceSet: ', data.getLabel()];
            else
                dataList = cell(1,n);
                logStr = cell(1,n);
                for i=1:n
                    dataList{i} = this.input.getPortAt(i).getData();
                    logStr{i} = ['ResourceSet#',num2str(i),': ', dataList{i}.getLabel()];
                end
                
                try
                    results = concat(dataList{:});
                catch exception
                    if strcmp(exception.identifier, 'BIOTRACS:Set:Duplicate')
                        error('BIOTRACS:Merger:Duplicate', '%s\nPlease ensure the ResourceSets to merge do not contain identically named data.', error.message);
                    else
                        error('BIOTRACS:Merger:UnkwnownError', '%s\nAn error occured when merging ResourceSets.', error.message);
                    end
                end
                this.setOutputPortData('ResourceSet', results);
            end
            this.logger.writeLog( '%s', sprintf('%s\n',logStr{:}));
        end
        
    end
end
