%"""
%biotracs.core.adapter.model.Adapter
%An Adapter is a Process that does not alter or transform a Resource. 
%It is only used to perform non-transforminig operation such as _transmit_,
%_reorder_, _load_, _save_, _gather_, _dispatch_
%Resource objects.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%"""

classdef (Abstract) Adapter < biotracs.core.mvc.model.Process
    
    properties
    end
    
    methods
        
        function this = Adapter()
            this@biotracs.core.mvc.model.Process();
        end
        
        %-- B --
        
        %-- C --  eze
        
        %-- E --
    
        %-- G --
   
        %-- R --
        
        %-- U --
        
        function this = updateInputPortClass( this, iPortName, iNewClass )
            this.updateInputSpecs({...
                struct(...
                'name', iPortName,...
                'class', iNewClass ...
                )...
                });
        end
        
        function this = updateOutputPortClass( this, iPortName, iNewClass )
            this.updateOutputSpecs({...
                struct(...
                'name', iPortName,...
                'class', iNewClass ...
                )...
                });
        end
        
    end
    
    
    methods(Access = protected)

        %overload default behavior
        function doAttachProcessToOutputResources( this  )
            try
                this.doAttachProcessToOutputResources@biotracs.core.mvc.model.Process();
            catch exception
                if (strcmp(exception.identifier,'BIOTRACS:Resource:SetProcess:ProcessAlreadyDefined'))
                    %... do nothing
                else
                    rethrow(exception);
                end
            end
        end
        
    end
    
end
