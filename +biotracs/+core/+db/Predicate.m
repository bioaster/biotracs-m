%"""
%biotracs.core.db.Predicate
%Predicate of a query
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.db.Query, biotracs.core.ability.Queriable
%"""

classdef Predicate < handle
    
    properties( Constant )
        ANY = '.*';
        NOTHING = '';
    end
    
    properties( SetAccess = protected )
        
        % type of predicate
        %match, greater_than, less_than, equals
        type; 
        
        % value of the predicate
        % expression = char || regexp || numeric || cell || ... || handle
        % biotracs.core.db.Predicate.ANY match true with ANY value
        value = biotracs.core.db.Predicate.ANY;
    end
    
    properties( SetAccess = private )
    end
    
    events
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = Predicate( iType, iValue )
            this.type = iType;
            this.value = iValue;
        end
        
        function e = getValue( this )
            e = this.value;
        end
        
        %-- I --
        
        function tf = isAny( this )
            tf = ischar(this.value) && strcmp(this.value, biotracs.core.db.Predicate.ANY);
        end
        
        %-- S --
        
        function setType( this, iType )
            this.type =  iType;
        end
        
        %-- V --
        
        function tf = validate( this, iValue )
            switch this.type
                case 'MatchAgainst'
                    if ~ischar(this.value)
                        error('The value must be a string data');
                    end
                    
                    if ~ischar(iValue)
                        tf = false; return;
                    end
                    
                    if strcmp(this.value, biotracs.core.db.Predicate.ANY)
                        tf = true; return;
                    else
                        tf = ~isempty( regexp(iValue, this.value, 'once') );
                    end
                case 'NotMatchAgainst'
                    if ~ischar(this.value)
                        error('The value must be a string data');
                    end
                    
                    if strcmp(this.value, biotracs.core.db.Predicate.ANY)
                        tf = false; return;
                    else
                        tf = isempty( regexp(iValue, this.value, 'once') );
                    end
                case 'EqualTo'
                    tf = isequaln(this.value, iValue);
                case 'GreaterThan'
                    if ~isnumeric(this.value)
                        error('The value must be a numeric data');
                    end
                    tf = iValue > this.value;
                case 'LessThan'
                    if ~isnumeric(this.value)
                        error('The value must be a numeric data');
                    end
                    tf = iValue < this.value;
                case 'GreaterOrEqualTo'
                    if ~isnumeric(this.value)
                        error('The value must be a numeric data');
                    end
                    tf = iValue >= this.value;
                case 'LessOrEqualTo'
                    if ~isnumeric(this.value)
                        error('The value must be a numeric data');
                    end
                    tf = iValue <= this.value;
                case 'Between'
                    if ~isnumeric(this.value)
                        error('The value must be a numeric data');
                    end
                    tf = iValue > this.value(1) && iValue < this.value(2);
                otherwise
                    error('Unknown predicate');
            end

        end
        
    end
    
    % -------------------------------------------------------
    % Public abstract methods/interfaces
    % -------------------------------------------------------
    
    methods(Abstract, Access = public)
        
    end
    
end
