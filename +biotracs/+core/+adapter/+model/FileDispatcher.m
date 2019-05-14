%"""
%biotracs.core.adapter.model.FileDispatcher
%A FileDispatcher is a special type of Demux used to dispatch the content
%of a DataFileSet object as individuals DataFile objects.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%"""

classdef FileDispatcher < biotracs.core.adapter.model.Demux
    
    methods
        
        function this = FileDispatcher()
            this@biotracs.core.adapter.model.Demux();
            
            % enhance outputs specs
            this.setInputSpecs({...
                struct(...
                'name', 'DataFileSet',...
                'class', 'biotracs.data.model.DataFileSet' ...
                )...
                });
            
            % enhance inputs specs
            this.setOutputSpecs({...
                struct(...
                'name', 'Resource',...
                'class', 'biotracs.core.mvc.model.Resource', ...
                'multiplicity', 1 ...
                )...
                });
            this.output.setIsResizable(true);
        end

    end
    
    
    methods(Access = protected)
        
        function doBeforeRun( this )
            this.doBeforeRun@biotracs.core.adapter.model.Adapter();
            resourceSet = this.getInputPortData('DataFileSet');
            n = resourceSet.getLength();
            this.resizeOutput(n);
        end
        
        
        function doRun( this )
            n = this.output.getLength();
            resourceSet = this.getInputPortData('DataFileSet');
            logStr = cell(1,n);
            for i=1:n
                inputFile = resourceSet.getAt(i);
                port = this.output.getPortAt(i);
    
                dataFileSet = biotracs.data.model.DataFileSet();
                dataFileSet.add(inputFile);
                port.setData(dataFileSet);
                
                logStr{i} = ['Resource#',num2str(i),': ', inputFile.getLabel()];
            end            
            this.logger.writeLog( '%s', sprintf('%s\n',logStr{:}));
        end
        
    end
end
