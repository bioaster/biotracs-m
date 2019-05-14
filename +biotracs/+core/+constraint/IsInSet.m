%"""
%biotracs.core.constraint.IsInSet
%Constraint that checks if a Parameter value is a set of values
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.mvc.Parameter
%"""

classdef IsInSet < biotracs.core.constraint.Constraint
    
    properties
        setOfElements = {};
    end
    
    methods
        
        function this = IsInSet( iSetOfElements )
            this@biotracs.core.constraint.Constraint();
            if ~iscell(iSetOfElements)
                error('Invalid argument, a cell is required');
            end
            this.setOfElements = iSetOfElements;
        end

    end
    
    methods(Access = protected)
        
        function tf = doIsValid( this, iValue )
            if isempty(iValue)
                tf = true; return;
            end

            tf = false;
            for i=1:length(this.setOfElements)
                if ischar(iValue) && ischar(this.setOfElements{i})
                    tf = strcmp(iValue, this.setOfElements{i});
                else
                    tf = isequal(iValue, this.setOfElements{i});
                end
                if tf, return; end
            end
        end
        
%         function tf = doIsValid( this, iValue )
%             if isempty(iValue)
%                 tf = true; return;
%             end
% 
%             tf = false;
%             
%             if ~iscell(iValue)
%                 listOfValues = {iValue};
%             end
%             
%             for j=1:length(listOfValues)
%                 val = listOfValues{j};
%                 for i=1:length(this.setOfElements)
%                     if ischar(val) && ischar(this.setOfElements{i})
%                         tf = strcmp(val, this.setOfElements{i});
%                     else
%                         tf = isequal(val, this.setOfElements{i});
%                     end
%                     if tf, break; end
%                 end
%                 if ~tf, break; end
%             end
%         end
        
    end
    
end

