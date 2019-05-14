%"""
%biotracs.core.db.Query
%Query object used to manage queries on DataTable objects
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.db.Query, biotracs.core.ability.Queriable,
%biotracs.data.model.DataTable, biotracs.data.model.DataMatrix,
%biotracs.data.model.DataSet
%"""

classdef Query < handle
    
    properties( SetAccess = protected )
        columns = '.*';
        predicate;
    end
    
    properties(SetAccess = protected)
    end
    
    events
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        % param[in] iColumns Column on which the query must applied. By
        % default, @a iColumns = '*' i.e. the query is applied on all the
        % columns
        % param[in] iPredicateType Type of predicate to apply (@see
        % biotracs.core.db.Predicate) : 'MatchAgainst', 'GreaterThan',
        % 'LessThan'
        % param[in] iPredicateValue The value of the predicate
        function this = Query( iColumns, iPredicateType, iPredicateValue )
            if nargin >= 1
                this.columns = iColumns;
            end
            if nargin < 2
                iPredicateValue = biotracs.core.db.Predicate.ANY;
            end
            this.predicate = biotracs.core.db.Predicate(iPredicateType, iPredicateValue);
        end
        
        function f = getColumns( this )
            f = this.columns;
        end
        
        function p = getPredicate( this )
            p = this.predicate;
        end
        
        function setPredicateType( this, iType )
            this.predicate.setType( iType );
        end
    end
    
    % -------------------------------------------------------
    % Static
    % -------------------------------------------------------
    
    methods(Static)
        
        % Create Query with a predicate <match>
        %> @param[in] iColumns Column on which the query must applied. By
        % default, @a iColumns = '*' i.e. the query is applied on all the
        % columns
        %> @param[in] iPredicateValue The value of the predicate
        % Predicate <MatchAgainst> applies for any type of data. If it is applied on
        % a string, its behaves as a regular expression; otherwise absolute
        % comparison is done
        function q = matchAgainst( iColumns, iPredicateValue )
            q = biotracs.core.db.Query( iColumns, 'MatchAgainst', iPredicateValue );
        end
        
        function q = notMatchAgainst( iColumns, iPredicateValue )
            q = biotracs.core.db.Query( iColumns, 'NotMatchAgainst', iPredicateValue );
        end
        
        % Create Query with a predicate <greater_than>
        %> @param[in] iColumns Column on which the query must applied. By
        % default, @a iColumns = '*' i.e. the query is applied on all the
        % columns
        %> @param[in] iPredicateValue The value of the predicate
        function q = greaterThan( iColumns, iPredicateValue )
            q = biotracs.core.db.Query( iColumns, 'GreaterThan', iPredicateValue );
        end
        
        function q = greaterOrEqualTo( iColumns, iPredicateValue )
            q = biotracs.core.db.Query( iColumns, 'GreaterOrEqualTo', iPredicateValue );
        end
        
        % Create Query with a predicate <less_than>
        %> @param[in] iColumns Column on which the query must applied. By
        % default, @a iColumns = '*' i.e. the query is applied on all the
        % columns
        %> @param[in] iPredicateValue The value of the predicate
        function q = lessThan( iColumns, iPredicateValue )
            q = biotracs.core.db.Query( iColumns, 'LessThan', iPredicateValue );
        end
        
        function q = lessOrEqualTo( iColumns, iPredicateValue )
            q = biotracs.core.db.Query( iColumns, 'LessOrEqualTo', iPredicateValue );
        end
        
        % Create Query with a predicate <equals>
        %> @param[in] iColumns Column on which the query must applied. By
        % default, @a iColumns = '*' i.e. the query is applied on all the
        % columns
        %> @param[in] iPredicateValue The value of the predicate
        % Predicate <equals> is used for absolute comparison on any data
        % type (function isequal() is used).
        function q = equalTo( iColumns, iPredicateValue )
            q = biotracs.core.db.Query( iColumns, 'EqualTo', iPredicateValue );
        end
        
        
        function q = between( iColumns, iPredicateValue )
            q = biotracs.core.db.Query( iColumns, 'Between', iPredicateValue );
        end
        
    end
    
end
