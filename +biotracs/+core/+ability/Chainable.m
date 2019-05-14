%"""
%biotracs.core.ability.Chainable
%Base class to handle Chainable objects. A Chainable is an object that
%be chained (linked) to another Chainable object to create a Workflow.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.mvc.model.Workflow, biotracs.core.mvc.model.Process
%"""

classdef (Abstract) Chainable < handle
    

    methods
    end

    methods( Abstract )
        [ next ]    = getNext( this );
        [ prev ]    = getPrevious( this );
        [ tf ]      = isSource( this );
        [ tf ]      = isSink( this );
    end
    
end
