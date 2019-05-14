%"""
%biotracs.core.adapter.model.Demux
%A Demux is a demulptiplexer Adapter used to dispatch the content of
%ResourceSet as individuals Resource objects
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.adapter.model.Mux
%"""

classdef Demux < biotracs.core.adapter.model.Adapter

    methods
        
        function this = Demux()
            this@biotracs.core.adapter.model.Adapter();

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
                'name', 'Resource',...
                'class', 'biotracs.core.mvc.model.Resource', ...
                'multiplicity', 1 ...
                )...
                });
            this.output.setIsResizable(true);
        end

        function resizeOutput( this, iNbPorts, varargin )
            this.output.resize( iNbPorts, varargin{:}  );
        end
        
        function this = resizeOutputWith( this, iResourceSet )
            if ~isa(iResourceSet, 'biotracs.core.mvc.model.ResourceSet')
                error('BIOTRACS:Demux:InvalidArgument','A ResourceSet is required');
            end
            this.doResizeOutputWith( iResourceSet );
        end
    end
    
    
    methods(Access = protected)

        function this = doResizeOutputWith( this, iResourceSet )
            n = iResourceSet.getLength();
            if n == 0
                error('BIOTRACS:Demux:UndefinedResourceSet','The ResourceSet structure is not defined')
            end
            specs = cell(1,n); 
            for i=1:n
                name = iResourceSet.getElementName(i);
                resource = iResourceSet.getAt(i);
                className = class(resource);
                specs{i} = struct(...
                    'name', name,...
                    'class', className, ...
                    'multiplicity', 1 ...
                );
            end
            this.setOutputSpecs(specs);
        end
        
        function doBeforeRun( this )
            this.doBeforeRun@biotracs.core.adapter.model.Adapter();
            resourceSet = this.getInputPortData('ResourceSet');
            isResized = this.output.getLength() >= resourceSet.getLength();
            if this.output.isResizable && ~isResized
                resourceSet = this.getInputPortData('ResourceSet');
                nbInputData = getLength(resourceSet);
                this.resizeOutput(nbInputData);
            end
            this.setIsDeactivated( resourceSet.isEmpty() );
        end
        
        function doRun( this )
            n = this.output.getLength();            
            resourceSet = this.getInputPortData('ResourceSet');
            logStr = cell(1,n);
            for i=1:n
                r = resourceSet.getAt(i);
                if r.isNil()
                    logStr{i} = ['Resource#',num2str(i),' is null (empty reference)'];
                else
                    port = this.output.getPortAt(i);
                    port.setData(r);
                    logStr{i} = ['Resource#',num2str(i),': ', r.getLabel()];
                end                
            end
            this.logger.writeLog( '%s', sprintf('%s\n',logStr{:}));
        end
        
    end
end
