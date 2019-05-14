%"""
%biotracs.core.mvc.model.WorkflowIterator
%A WorkflowIterator is a type of Workflow that is composed a process Iterator and a sub-workflow (the iterated Workflow). 
%A WorkflowIterator allows looping on a the elements of a ResourceSet to process them sequentially by a given Workflow.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%* See: biotracs.core.mvc.model.Iterator, biotracs.core.mvc.model.Worfklow
%"""

classdef WorkflowIterator < biotracs.core.mvc.model.Workflow
    
    properties(SetAccess = protected)
        iterator
        iteratedWorkflow;
    end
    
    events
        beforeEach;    %event triggered on each iteration
        afterEach;    %event triggered on each iteration
    end

    methods
        
        function this = WorkflowIterator( iWorlflow )
            this@biotracs.core.mvc.model.Workflow();
            if nargin == 0
                return;
            end
            
            this.iteratedWorkflow = iWorlflow;
            this.iterator = biotracs.core.adapter.model.Iterator();
            
            % create outputs specs if required
            if this.iteratedWorkflow.getInput().getLength() == 0
                error('BIOTRACS:WorkflowIterator:InvalidPortSize', 'The iterated workflow must have at most one input port');
            elseif this.iteratedWorkflow.getInput().getLength() > 1
                error('BIOTRACS:WorkflowIterator:InvalidPortSize', 'The iterated workflow must have at most one input port');
            elseif ~isa( this.iteratedWorkflow.getInput().getPortAt(1).getData(), 'biotracs.core.mvc.model.Resource')
                error('BIOTRACS:WorkflowIterator:InvalidPortDataClass', 'The iterated workflow must have a port with data of class ''biotracs.core.mvc.model.Resource''');
            end
            
            this.addNode( this.iterator, 'Iterator' );
            this.addNode( this.iteratedWorkflow, 'IteratedWorkflow' );
            
            this.createInputPortInterface( 'Iterator', 'ResourceSet' );
            this.iterator.getOutput().getPortAt(1).connectTo( this.iteratedWorkflow.getInput().getPortAt(1) ); 
            
            %add listeners
            this.iterator.addlistener('beforeEach', @beforEach );
            this.iterator.addlistener('afterEach', @afterEach );
            function beforEach(varargin)
                this.notify('beforeEach');
            end
            function afterEach(varargin)
                this.notify('beforeEach');
            end
        end
        
        %-- G --
        
        function w = getIteratedWorkflow( this )
            w = this.iteratedWorkflow;
        end

        %-- S --
        
    end
    
    methods(Access = protected)
    end
    
end