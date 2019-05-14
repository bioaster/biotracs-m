%"""
%biotracs.data.helper.GroupStrategy
%GroupStrategy object to analyze DataTable row and column names and split data according to regular expression patterns
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.data.model.DataTable
%"""

classdef GroupStrategy
    properties
        labels;
        patterns;
        sep = '_';
        strategy;
    end
    
    methods
        
        function this = GroupStrategy( iLabels, iPatternsOrGroupList, iSep )
            this.labels = iLabels;
            if isstruct(iPatternsOrGroupList)
                this.patterns = iPatternsOrGroupList;
            elseif iscell(iPatternsOrGroupList)
                this.patterns = this.buildNamePatternsFromGroupList( iPatternsOrGroupList, this.sep );
            else
                error('The patterns must be a struct or a cell of strings ');
            end
            
            if nargin == 3
                if length(iSep) == 1
                    this.sep = iSep;
                else
                    error('The separator must be a character');
                end
            end
            
            this.strategy = this.parseNamesUsingNamePattern( this.labels, this.patterns, this.sep );
        end
        
        % @ToDo : New changes for clarification
        % - Groups will be Categories
        % - Slices will be Groups
        % e.g.: State:Good, State:Bad means that State is the category, and
        % {Bad and Good} are two groups in this category
        function [oLogicalIndexes, oSliceNames, oNumericIndexes] = getSlicesIndexes( this )
            if isempty(this.strategy)
                oLogicalIndexes = []; oSliceNames = {}; oNumericIndexes = [];
                return;
            end
            
            grpLabels = this.getGroupLabels();
            nbGroups = length(grpLabels);
            nrows = length(this.strategy)-1;
            
            oLogicalIndexes = false(nrows,nbGroups);
            oSliceNames = cell(1,nbGroups);
            cpt = 1;
            for i=1:nbGroups
                grpLabel = grpLabels{i};
                [tmpIdx, tmpSliceNames] = this.getSlicesIndexesOfGroup( grpLabel );
                offset = length(tmpSliceNames)-1;
                oLogicalIndexes(:,cpt:cpt+offset) = tmpIdx;
                oSliceNames(cpt:cpt+offset) = tmpSliceNames;
                cpt = cpt+offset+1;
            end
            
            [oSliceNames, sortedIdx] = sort(oSliceNames);
            oLogicalIndexes = oLogicalIndexes(:,sortedIdx);
            
            if nargout == 3
                oNumericIndexes = oLogicalIndexes * (1:size(oLogicalIndexes,2))';
                if sum(oNumericIndexes) == 0
                    oNumericIndexes = ones(1,nrows);
                end
            end
        end
        
        % will be 
        % - getSlicesIndexesOfCategory or 
        % - getGroupIndexesOfCategory
        function [oLogicalIndexes, oSliceNames, oNumericIndexes] = getSlicesIndexesOfGroup( this, iGroupLabel )
            if ~ischar(iGroupLabel)
                error('A char is required');
            end
            
            if isempty(this.strategy)
                oLogicalIndexes = []; oSliceNames = {}; oNumericIndexes = [];
                return;
            end
            
            n = length(this.strategy)-1;
            nbSlices =  this.getNbSlicesOfGroup(iGroupLabel);
            oSliceNames = this.getSliceNamesOfGroup(iGroupLabel);
            oLogicalIndexes = false(n,nbSlices);
            for i=1:n
                for j=1:nbSlices
                    sliceName = oSliceNames{j};
                    if strcmp(sliceName, this.strategy{i}.(iGroupLabel).name)
                        oLogicalIndexes(i,j) = true;
                        break;
                    end
                end
            end
            
            [oSliceNames, sortedIdx] = sort(oSliceNames);
            oLogicalIndexes = oLogicalIndexes(:,sortedIdx);
            
            if nargout == 3
                oNumericIndexes = oLogicalIndexes * (1:nbSlices)';
            end
        end
        
        function [oLogicalIndexes]= getSliceIndexesInGroup( this, iGroupLabel, iSliceName )
            if isempty(this.strategy)
                oLogicalIndexes = [];
                return;
            end
            
            n = length(this.strategy)-1;
            oLogicalIndexes = false(1,n);
            for i=1:n
                if strcmp(iSliceName, this.strategy{i}.(iGroupLabel).name)
                    oLogicalIndexes(i) = true;
                end
            end
        end
        
        function [ oStrategy ] = getStrategy( this )
            oStrategy = this.strategy;
        end
        
        function [ oGroupLabels ] = getGroupLabels(this)
            oGroupLabels = {};
            if isempty(this.strategy)
                return;
            end
            
            field = fieldnames(this.strategy{end});
            %@ToDo: improve this part
            for i=1:length(field)
                if isnumeric(this.strategy{end}.(field{i}))
                    oGroupLabels{end+1} = field{i};
                end
            end
        end
        
        function [ oSliceNames ] = getSliceNames(this)
            oSliceNames = {};
            if isempty(this.strategy)
                return;
            end
            
            field = fieldnames(this.strategy{end});
            for i=1:length(field)
                if iscellstr(this.strategy{end}.(field{i}))
                    oSliceNames = [oSliceNames, this.strategy{end}.(field{i})];
                end
            end
        end
        
        function [ oNames ] = getSliceNamesOfGroup(this, iGroupLabel)
            if isempty(this.strategy)
                oNames = {};
                return;
            end
            oNames = this.strategy{end}.([iGroupLabel, 'List']);
        end
        
        function [ oNbSlices ] = getNbSlicesOfGroup(this, iGroupLabel)
            if isempty(this.strategy)
                oNbSlices = 0;
                return;
            end
            oNbSlices = this.strategy{end}.(iGroupLabel);
        end
        
    end
    
    methods(Static)
        
        function namePatterns = buildNamePatternsFromGroupList( iGroupList, iSep )
            if ischar(iGroupList)
                iGroupList = {iGroupList};
            end
            
            if ~iscellstr(iGroupList)
                error('Invalid group list');
            end
            
            namePatterns = struct();
            
            if ~isempty(iGroupList)
                for i=1:length( iGroupList )
                    group = iGroupList{i};
                    namePatterns.(group) = ['^',group,':([^',iSep,']*)', '|', '_',group,':([^',iSep,']*)'];
                end
            end
        end
        
        % Parse a list of names (typically row and column names) and return
        % a detailed description for each name
        %> @see parseNames
        function oResult = parseNamesUsingGroupList( iListOfNames, iGroupList, iSep )
            pattern = biotracs.data.helper.GroupStrategy.buildNamePatternsFromGroupList( iGroupList, iSep );
            oResult = biotracs.data.helper.GroupStrategy.parseNamesUsingNamePattern( iListOfNames, pattern, iSep );
        end
        
        function oResult = parseNamesUsingNamePattern( iListOfNames, iPattern, iSep )
            if isempty(iPattern)
                oResult = {}; return;
            end
            n = length(iListOfNames);
            oResult = cell(1,n+1);
            %start parsing ...
            tokens = fields(iPattern);
            tokenGroupMaps  = struct();
            tokenGroups = struct();
            for j=1:length(tokens)
                tokenName = tokens{j};
                tokenGroupMaps.(tokenName) = containers.Map();
                tokenGroups.(tokenName) = 0;
                tokenGroups.([tokenName, 'List']) = {};
                pattern = iPattern.(tokenName);
                expr = [ '(?<', tokenName, '>(', pattern, '))' ];
                for i=1:n
                    foundTokenValues = regexpi( iListOfNames{i}, expr, 'names' );
                    if isempty(foundTokenValues), continue; end
                    for k=1:length(foundTokenValues)
                        tokenValue = foundTokenValues(k).(tokenName);
                        tokenValue = regexprep(tokenValue,iSep,''); %trim separators
                        currentTokenGroupMap = tokenGroupMaps.(tokenName);
                        
                        if isKey( currentTokenGroupMap, tokenValue )
                            % the group exists: retrieve the index of the group
                            groupIndex = currentTokenGroupMap( tokenValue );
                        else
                            % it is a new group: increment groupIndex
                            groupIndex = tokenGroups.(tokenName)  + 1;
                            tokenGroups.([tokenName,'List']){end+1} = tokenValue;
                            tokenGroups.(tokenName) = groupIndex;
                            currentTokenGroupMap( tokenValue ) = groupIndex; %#ok<NASGU>
                        end
                        oResult{i}.(tokenName) = struct( ...
                            'name', tokenValue, ...
                            'index', groupIndex ...
                            );
                    end
                end
            end
            %store tokenGroups in the last index
            if isempty(tokenGroups)
                oResult = {};
            else
                oResult{n+1} = tokenGroups;
            end
        end
        
    end
    
end

