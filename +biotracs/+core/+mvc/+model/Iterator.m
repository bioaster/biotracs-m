%"""
%biotracs.core.mvc.model.Iterator
%Defines the iterator object. An Iterator allows iterating an each Resource of a ResourSet. Each Resource objects are passed to the next nodes sequentially.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2018
%* See: biotracs.core.mvc.model.IteratorConfig, biotracs.core.mvc.model.Process
%"""

classdef Iterator < biotracs.core.mvc.model.Process
    
    properties(SetAccess = protected)
        iterationCounter = 0;
        iteratedProcessName = 'IteratedProccess';
    end
    
    events
        beforeEach;    %event triggered on each iteration
        afterEach;    %event triggered on each iteration
    end

    methods
        
        function this = Iterator( iIteratedProcess )
            this@biotracs.core.mvc.model.Process();
            
            % enhance outputs specs
            this.addInputSpecs({...
                struct(...
                'name', 'ResourceSet',...
                'class', 'biotracs.core.mvc.model.ResourceSet' ...
                )...
                });
            
            % enhance inputs specs
            this.addOutputSpecs({...
                struct(...
                'name', 'ResourceSet',...
                'class', 'biotracs.core.mvc.model.ResourceSet' ...
                )...
                });
            this.output.setIsResizable(true);
            
            if nargin == 1
                this.bindEngine(iIteratedProcess, this.iteratedProcessName);
            end
        end
        
        %-- G --
        
        function i = getIterationCount( this )
            i = this.iterationCounter;
        end
        
        function p = getIteratedProcess( this )
            p = this.getEngine(this.iteratedProcessName);
        end

        %-- R --
        
        function reset( this )
            this.reset@biotracs.core.mvc.model.Process();
            this.iterationCounter = 0;
        end
        
        %-- S --
        
        function this = setIteratedProcess( this, iIteratedProcess, iIteratedProcessName )
            if nargin == 3
                this.iteratedProcessName = iIteratedProcessName;
            end
            if( this.hasEngine(this.iteratedProcessName) )
                this.removeEngine( this.iteratedProcessName )
            end
            this.bindEngine(iIteratedProcess, this.iteratedProcessName);
        end
        
    end
    
    methods(Access = protected)
        
        function doRun( this )
            e = this.getIteratedProcess();
            if isempty(e)
               error('BIOTRACS:Iterator:NoIteratedProcessDefined', 'No iterated process is defined'); 
            end
            
            resourceSet = this.getInputPortData('ResourceSet');
            n = getLength(resourceSet);
            resultSet = this.getOutputPortData('ResourceSet');
            resultSet.allocate(n);
            
            %open log
            wd = this.getConfig.getParamValue('WorkingDirectory');
            for i=1:n
                this.iterationCounter = i;
                resource = resourceSet.getAt(i); 
                e.getInput().getPortAt(1).setData( resource );
                e.getConfig().updateParamValue('WorkingDirectory', fullfile(wd, e.getLabel(), num2str(i)));
                
                this.notify('beforeEach');
                e.run();
                result = e.getOutput().getPortAt(1).getData();
                resultSet.setAt(i, result);
                this.notify('afterEach');
                
                logStr = strcat('Processing resource ',num2str(i),': ', resource.getLabel());
                this.logger.writeLog( '%s', logStr);
                
                e.reset();
            end

            %close log
            %closeLog(this);
            
            this.setOutputPortData('ResourceSet', resultSet);
        end
        
    end
    
end