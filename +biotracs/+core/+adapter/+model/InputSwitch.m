%"""
%biotracs.core.adapter.model.InputSwitch
%An InputSwitch is an Adapter that has several input ports but has only one output port. 
%Its role is to selected only one Resource object (generally coming from a
%Demux or several left-comaptible processes) and sends it to the next
%Process in a Workflow. It allows performing selective routing in the process flow.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.adapter.model.OutputSwitch
%"""

classdef InputSwitch < biotracs.core.adapter.model.Adapter

    properties(SetAccess = protected)
        selectedPortIndex = 1;
    end

    methods
        
        function this = InputSwitch()
            this@biotracs.core.adapter.model.Adapter();

            % enhance inputs specs
            this.addInputSpecs({...
                struct(...
                'name', 'Resource',...
                'class', 'biotracs.core.mvc.model.Resource', ...
                'multiplicity', 2  ...
                )...
                });
            
            % enhance outputs specs
            this.addOutputSpecs({...
                struct(...
                'name', 'Resource',...
                'class', 'biotracs.core.mvc.model.Resource' ...
                )...
                });
            this.input.setIsResizable(true);
            this.output.setIsResizable(false);
        end
       
        function switchOn( this, iPortNumber )
            if this.selectedPortIndex < 0
                error('BIOTRACS:OutputSwitch:InvalidPortSelection', 'The selected port index is out of range');
            end
            this.logger.writeLog('Switch %s on input port #%d', this.label, iPortNumber);
            this.selectedPortIndex = iPortNumber;
        end

        function [tf] = isReady( this )
            if this.selectedPortIndex < 0
                tf = false; 
                return;
            end
            tf = this.isReady@biotracs.core.adapter.model.Adapter() || ...
                this.doGetSelectedInputPort().isReady();            
        end
        
    end
    
    
    methods(Access = protected)
        
        function port = doGetSelectedInputPort( this )
            if this.selectedPortIndex > this.input.getLength() || this.selectedPortIndex < 0
                error('BIOTRACS:OutputSwitch:InvalidPortSelection', 'The selected port index is out of range');
            end
            port = this.input.getPortAt(this.selectedPortIndex);
        end
        
        function doRun( this )
            r = this.doGetSelectedInputPort().getData();
            this.setOutputPortData('Resource', r);
            logStr = ['Resource#',num2str(this.selectedPortIndex),': ', r.getLabel()]; 
            this.logger.writeLog( '%s', sprintf('%s\n',logStr));
        end
        
    end
    
end
