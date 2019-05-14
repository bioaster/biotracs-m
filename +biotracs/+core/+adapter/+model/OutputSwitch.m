%"""
%biotracs.core.adapter.model.OutputSwitch
%An OutputSwitch is an Adapter that has a single input port but has several output ports. 
%Its role is to send the input one Resource object the a given output port.
%It allows performing selective routing in the process flow.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.adapter.model.InputSwitch
%"""

classdef OutputSwitch < biotracs.core.adapter.model.Adapter

    properties(SetAccess = protected)
        selectedPortIndex = 1;
    end

    methods
        
        function this = OutputSwitch()
            this@biotracs.core.adapter.model.Adapter();

            % enhance outputs specs
            this.addInputSpecs({...
                struct(...
                'name', 'Resource',...
                'class', 'biotracs.core.mvc.model.Resource' ...
                )...
                });
            
            % enhance inputs specs
            this.addOutputSpecs({...
                struct(...
                'name', 'Resource',...
                'class', 'biotracs.core.mvc.model.Resource', ...
                'multiplicity', 2 ...
                )...
                });
            this.input.setIsResizable(false);
            this.output.setIsResizable(true);
        end
       
        function switchOn( this, iPortNumber )
            if this.selectedPortIndex < 0
                error('BIOTRACS:OutputSwitch:InvalidPortSelection', 'The selected port index is out of range');
            end
            this.logger.writeLog('Switch %s on output port #%d', this.label, iPortNumber);
            this.selectedPortIndex = iPortNumber;
        end

        function resizeOutput( this, iNbPorts, varargin )
            this.output.resize( iNbPorts, varargin{:}  );
        end
        
    end
    
    
    methods(Access = protected)
        
        function port = doGetSelectedOutputPort( this )
            if this.selectedPortIndex > this.output.getLength() || this.selectedPortIndex < 0
                error('BIOTRACS:OutputSwitch:InvalidPortSelection', 'The selected port index is out of range');
            end
            port = this.output.getPortAt(this.selectedPortIndex);
        end
        
        function doRun( this )
            r = this.getInputPortData('Resource');
            port = this.doGetSelectedOutputPort();
            port.setData(r);

            logStr = ['Resource: ', r.getLabel(), ' -> output port ', num2str(this.selectedPortIndex)]; 
            this.logger.writeLog( '%s', sprintf('%s\n',logStr));
        end
        
    end
    
end
