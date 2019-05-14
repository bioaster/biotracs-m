%"""
%biotracs.core.constraint.ConstraintSet
%Set of Constraint objects. @ToDo: In next releases, a Parameter will be associated with a ConstraintSet instead of a Constraint. 
%This will allow restricting the values a parameters according to several
%constraints.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.constraint.Constraint, biotracs.core.mvc.Parameter
%"""

classdef ConstraintSet < biotracs.core.constraint.Constraint & biotracs.core.container.Set
    
    properties
    end
    
    methods

         function this = ConstraintSet( varargin )
            this@biotracs.core.constraint.Constraint();
            this@biotracs.core.container.Set( varargin{:} );
            this.classNameOfElements = {'biotracs.core.constraint.Constraint'};
         end
        
         function out = summary( this )
             n = this.getLength();
             txt = cell(1,n);
             for i=1:n
                 txt{i} = this.getAt(i).summary();
             end
             txt = strjoin(txt,' AND ');
             
             if ~nargout
                 fprintf('%s\n',txt);
             else
                 out = txt;
             end
         end
         
    end
    
    methods(Access = protected)
        
        function tf = doIsValid( this, iValue )
            if isempty(iValue)
                tf = true; return;
            end
            
            n = this.getLength();
            for i=1:n
                constraint = this.getAt(i);
                tf = constraint.doIsValid( iValue );
                if ~tf, break; end
            end
        end

    end
    
end

