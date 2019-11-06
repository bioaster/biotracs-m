%"""
%biotracs.core.container.Set
%A set of elements
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%"""

classdef Set < biotracs.core.ability.Copyable & biotracs.core.ability.Comparable 
    properties( Constant )
		ANY_CLASS_NAMES = {'any'}
	end
	
	properties(SetAccess = protected)
        elements = {};
        elementNames = {};        
        nameMap;  
        classNameOfElements = biotracs.core.container.Set.ANY_CLASS_NAMES;     
    end
    
    methods
        
        % Contructor
        %> @param[in] iLength The length of the set. Allow to pre-allocate memory
        %> @param[in] iClassNameOfElements The class of the elements of the set.<br/>
        % If given, the elements of the set will have to statify
        %
        %> @fn this = Set( iSet )
        %> @fn this = Set( iLength, iClassNameOfElements )
        function this = Set( varargin )
            this@biotracs.core.ability.Copyable();
            this@biotracs.core.ability.Comparable();
            this.nameMap = containers.Map('KeyType','char','ValueType','double');
            
            if nargin == 0
                %nothing...
            elseif isnumeric( varargin{1} )
                if nargin == 2
                    this.setClassNameOfElements( varargin{2} );
                end
                %allocate after setting ClassNameOfElements
                this.allocate( varargin{1} );
            elseif isa(varargin{1}, 'biotracs.core.container.Set')
                % copy constructor
                this.doCopy( varargin{1} );
            else
                error('BIOTRACS:Set:InvalidArguments', 'Invalid arguments');
            end   
        end

        %-- A --
        
        % Clear the set and allocate memory
        function this = allocate(this, iLength)
            this.elements = cell(1, iLength);
            this.elementNames = biotracs.core.utils.uuid(iLength); 
            if iLength == 0
                this.nameMap = containers.Map('KeyType','char','ValueType','double');
            else
                this.nameMap = containers.Map(this.elementNames, 1:iLength);
            end
        end
        
        % Add one element at to end position of the set
        %> @param[in] Element to add
        %> @param[in] [optional, char] Unique name of the spectrum. If not
        %provided a unique name is created and returned
        %> @return this
        %> @return the unique name of the element
        function [this, iName] = add( this, iElement, iName )
            if this == iElement
                error('BIOTRACS:Set:ReccursiveAddForbidden', 'A set cannot contain it-self');
            end
            
            if ~this.isCompatibleWithElement(iElement)
                error('BIOTRACS:Set:ElementNotAllowed', 'The set can only contain {''%s''}', strjoin(this.classNameOfElements,''','''));
            end
            
            if nargin == 2 || isempty(iName)
                iName = biotracs.core.utils.uuid();
            elseif ~ischar(iName)
                error('BIOTRACS:Set:InvalidArguments', 'The name must be a string');
            end
            
            %this.doPreSet( iElement );
            this.elements{ end+1} = iElement;
            
            if isKey(this.nameMap, iName)
                error('BIOTRACS:Set:Duplicate', 'The name ''%s'' already exists', iName);
            else
                this.elementNames{ end+1 } = iName;
                this.nameMap(iName) = length(this.elementNames);
            end
        end

        % Add a list of elements after the end position of the set
        function this = addElements( this, varargin )
            if iscell(varargin)
                n = length(varargin);
                for i=1:2:n
                    name = varargin{i};
                    if ~ischar(name)
                        error('BIOTRACS:Set:InvalidArguments', 'A cell of {key,value} list is required. Key must be a string.');
                    end
                    value = varargin{i+1};
                    this.add( value, name );
                end
            else
                error('BIOTRACS:Set:InvalidArguments', 'A cell of {key,value} list is required. Key must be a string.');
            end
        end
        
        function tf = areSomeElementsUnnamed( this )
            tf = false;
            for i=1:length(this.elementNames)
               if isempty( this.elementNames{i} )
                   tf = true;
                   return;
               end
            end
        end
        
        %-- C --
        
        function oSet = concat( varargin )
            areSets = all(cellfun( @(x)(isa(x,'biotracs.core.container.Set')), varargin ));
            if ~areSets
                error('BIOTRACS:Set:InvalidArguments', 'All the arguments must be instances of biotracs.core.container.Set');
            end
            
            this = varargin{1};
            if length(varargin) == 1
                oSet = this.copy(); return;
            end
            
            if isEmpty(this) && length(varargin) == 2
                oSet = feval(class(this));
                oSet.doCopy(varargin{2});
                return;
            end
            
            elts = cellfun( @getElements, varargin, 'UniformOutput',false );
            elts = horzcat(elts{:});
            names = cellfun( @getElementNames, varargin, 'UniformOutput',false );
            names = horzcat(names{:});
            oSet = feval(class(this));
            oSet.setElements(elts, names);        
        end

        %-- D --

        %-- E --

        %-- G --

        % Get the elements of the set using an (or a list of) index(es)
        %> @param[in] iIndexesOrName May be an integer,  array of integer, a char
        %> @return An element if @a iIndexes is an integer or a char (the
        % name of the element); a cell of elements if @a iIndexes is an array of integers.
        function elt = get( this, iName )
            if ischar(iName)
                if isKey( this.nameMap, iName )
                    iIndex = this.nameMap(iName);
                    elt = this.elements{iIndex};
                else
                    maxNumOfNamesWritten = 20;
                    if this.getLength() > maxNumOfNamesWritten
                        c = [this.elementNames(1:maxNumOfNamesWritten), {'... truncated list.'}];
                        validNames = strjoin(c,''',''');
                    else
                        validNames = strjoin(this.elementNames,''',''');
                    end
                    error('BIOTRACS:Set:ElementNotFound','No element found with name ''%s''. Valid names are {''%s''}', iName, validNames);
                end
            else
                error('BIOTRACS:Set:InvalidArguments','The name must be a string');
            end
        end
        
        %> @param[in] iIndexes A scalar or vector of integer
        %> @return An element
        function elts = getAt( this, iIndexes )
            if ~isnumeric(iIndexes) && ~islogical(iIndexes)
                error('BIOTRACS:Set:InvalidArguments', 'The index must be a numeric or logical array');
            end
            if isscalar(iIndexes)
                elts = this.elements{iIndexes};
            else
                elts = this.elements(iIndexes);
            end
        end
        
        function cn = getClassNameOfElements( this )
            cn = this.classNameOfElements;
        end
        
        
        %> @param[in] iName A char
        %> @return An element
        function elt = getElementByName( this, iName )
            if ~ischar(iName)
                error('BIOTRACS:Set:InvalidArguments', 'The name must be a string');
            end
            if isKey(this.nameMap, iName)
                index = this.nameMap(iName);
            else
                error('BIOTRACS:Set:ElementNotFound', 'No element found with name ''%s''', iName);
            end
            elt = this.elements{index};
        end
        
        function elt = getElementsByNames( this, iNameList )
            index = this.getElementIndexesByNames(iNameList);
            elt = this.elements{index};
        end
        
        function oNames = getElementName( this, iIndexes )
            if isscalar(iIndexes)
                oNames = this.elementNames{iIndexes};
            else
                oNames = this.elementNames(iIndexes);
            end
        end
        
        function oNames = getElementNames( this )
            oNames = this.elementNames;
        end
        
        function index = getElementIndexByName( this, iName )
            if isKey(this.nameMap, iName)
                index = this.nameMap(iName);
            else
                index = [];
            end
        end
        
        function index = getElementIndexesByNames( this, iNameList )
            if ischar(iNameList)
                iNameList = {iNameList};
            end
            
            n = length(iNameList);
            index = zeros(1,n);
            indexFound = false(1,n);
            for i=1:n
                if isKey(this.nameMap, iNameList{i})
                    index(i) = this.nameMap(iNameList{i});
                    indexFound(i) = true;
                end
            end
            index = unique(index(indexFound));
        end
        
        % Retrieve all the elements of the Set
        %> @return A cell of elements
        function elts = getElements( this )
            elts = this.elements;
        end

        function oLength = getLength( this )
            if numel(this) == 0			%for Object.empty() objects
                oLength = 0;
            else
                oLength = length(this.elements);
            end
        end
        
        %-- I --
        
        function tf = isCompatibleWithElement( this, iElement, isStrict )
            if nargin <= 2, isStrict = false; end
            
            tf = false;
            for i=1:length(this.classNameOfElements)
                if strcmpi( this.classNameOfElements{i}, this.ANY_CLASS_NAMES )
                    tf = true;
                elseif isStrict
                    tf = strcmp( class(iElement), this.classNameOfElements{i} );
                else
                    tf = isa( iElement, this.classNameOfElements{i} );
                end
                
                if tf, return; end
            end
        end

        function tf = isEqualTo( this, iSet, iIsStrict )
            tf = false;
            
            if ~isa(iSet, 'biotracs.core.container.Set')
                return;
            end
            
            if this.getLength() ~= iSet.getLength()
                return;
            end

            if nargin < 3
                iIsStrict = false;
            end
            
            if iIsStrict && ~all(strcmp(this.elementNames, iSet.elementNames))
                return;
            end
 
            tf = any(ismember(this.elementNames, iSet.elementNames)) ...
                & any(ismember(iSet.elementNames, this.elementNames));
            if ~tf
                return;
            end
            
            for i=1:length(this.elementNames)
                name = this.elementNames{i};
                lhsElt = this.get(name);
                rhsElt = iSet.get(name);
                if isa(lhsElt, 'biotracs.core.ability.Comparable')
                    tf = isEqualTo(lhsElt, rhsElt);
                else
                    tf = isequal(lhsElt, rhsElt);
                end
                if ~tf, break; end
            end
        end
        
        function tf = isEmpty( this )
            tf = numel(this) == 0 || this.getLength() == 0;
        end
        
        function tf = hasElement( this, iIndexesOrName )
            if isempty(iIndexesOrName)
                tf = false;
            else
                if ischar(iIndexesOrName)
                    tf = isKey( this.nameMap, iIndexesOrName );
                elseif isnumeric(iIndexesOrName)
                    tf = iIndexesOrName > 0 && iIndexesOrName <= length(this.elements);
                else
                    tf = false;
                end
            end
        end
        
        %-- R --
        
        function removeAll( this )
            this.elements = {};
            this.elementNames = {};
            this.nameMap = containers.Map('KeyType','char','ValueType','double');
        end
        
        
        function eltRemoved = remove( this, iIndexesOrName )
            if ~this.hasElement( iIndexesOrName ), return; end
            if ischar(iIndexesOrName)
               index = this.getElementIndexByName(iIndexesOrName);
               name = iIndexesOrName;
            elseif isnumeric(iIndexesOrName)
               name = this.getElementName(iIndexesOrName);
               index = iIndexesOrName;
            end
            
            if nargout == 1
                eltRemoved = this.elements(index);
            end

            this.elements(index) = [];
            this.elementNames(index) = [];
            
            %refresh indexes in map
            this.nameMap.remove(name);
            n = length(this.elements);
            for i=index:n
                name = this.elementNames{i};
                this.nameMap(name) = this.nameMap(name)-1;
            end
        end
        
        %-- S --
        
        % Set the class name of element
        %> @throw Error if the Container is not empty
        function this = setClassNameOfElements( this, iClassNameOfElements )
            if this.getLength() > 0
                error('BIOTRACS:Set:NonEmptySet', 'The set is not empty. Cannot change the class of elements.')
            end
            if ischar( iClassNameOfElements )
                this.classNameOfElements = { iClassNameOfElements };
            elseif iscellstr( iClassNameOfElements )
                this.classNameOfElements = iClassNameOfElements;
            else
                error('BIOTRACS:Set:InvalidArguments', 'ClassNameOfElements must be a string or a cell of string');
            end                    
        end
        
        % Set an element in the Container. Add a new element if the element
        % does not exists
        %> @param[in] iName Name of th element
        %> @param[in] iElement The element to add to the set
        function this = set( this, iName, iElement )
            if ischar(iName)
                if isKey( this.nameMap, iName )
                    iIndex = this.nameMap(iName);
                    this.setAt(iIndex, iElement);
                else
                    this.add(iElement, iName);
                end
            else
                error('BIOTRACS:Set:InvalidArguments','Element name must be a string');
            end
        end

        function this = setAt( this, iIndex, iElement )
            if ~this.isCompatibleWithElement(iElement)
                error('BIOTRACS:Set:ElementNotAllowed', 'The set can only contain {%s}. A %s is given', strjoin(this.classNameOfElements,', '), class(iElement));
            end
            
            if iIndex(1) <= this.getLength()
                this.elements{iIndex(1)} = iElement;
            else
                error('BIOTRACS:Set:IndexOutOfRange', 'Index out of range');
            end

        end
        
        % Set elements
        %> @param[in] iElements Elements to set
        % This Set and @a iElements must have the same length. This means
        % that setElements can not alter the initial dimension of this Set.
        function this = setElements( this, iElements, iNames )
            if ~iscell(iElements)
                error('BIOTRACS:Set:InvalidArguments', 'Elements must be a cell'); 
            end

            areAllEmentCompatible = all(cellfun( @(x)isCompatibleWithElement( this, x ), iElements ));
            if ~areAllEmentCompatible
                error('BIOTRACS:Set:ElementNotAllowed', 'The set can only contain {''%s''}', strjoin(this.classNameOfElements,''','''));
            end
            
            this.elements = iElements;
            n = length(iElements);
            if nargin < 3
                iNames = biotracs.core.utils.uuid(n);
            end
            this.setElementNames( iNames );
        end
        
        
        function this = setElementName( this, iIndex, iName )
            if ~ischar(iName)
                error('BIOTRACS:Set:InvalidArguments', 'The mame must be string'); 
            end
            
            n = length(iName);
            if iIndex > n
                error('BIOTRACS:Set:IndexOutOfRange', 'Index out of range'); 
            end
            
            if any(ismember( iName,  this.elementNames))
                error('BIOTRACS:Set:Duplicate', 'This name already exists'); 
            end 
            
            oldKey =  this.elementNames{iIndex};
            this.elementNames{iIndex} = iName;
            this.nameMap(iName) = iIndex;
            remove(this.nameMap, oldKey);
        end
        
        function setElementNames( this, iNames  )
            if ~iscellstr(iNames)
                error('BIOTRACS:Set:InvalidArguments', 'Names must be a cell of string'); 
            end
            
            areNamesUnique = length(unique(iNames)) == length(iNames);
            if ~areNamesUnique
                error('BIOTRACS:Set:Duplicate', 'The names of the elements are not unique.');
            end
            
            n = length(iNames);
            if n ~= this.getLength()
                error('BIOTRACS:Set:DimensionMismatch', 'The number of names lengths do not match with the length of the set. Please, preallocate the necessary size of the Set.'); 
            end
            
            this.elementNames = iNames;
            this.nameMap = containers.Map(this.elementNames,  num2cell(1:n));
        end
        
        
        function summary( this, varargin )
            t = table(this.elements', 'RowNames', this.elementNames', 'VariableNames', {'Elements'});
            disp(this);
            disp(t);
            
            p = inputParser();
            p.addParameter('Deep', false, @islogical);
            p.parse( varargin{:} );
            if p.Results.Deep
               n = this.getLength();
               for i=1:n
                   e = this.getAt(i);
                   fprintf('\nElement %d: <strong>%s</strong>\n', i, this.elementNames{i});
                   fprintf('_____________________________________________________________\n');
                   if isa(e,'biotracs.core.ability.Copyable')
                       e.summary();
                   else
                       disp(e);
                   end
               end
            end
        end
        
    end
    
    methods(Access = protected)

        function doCopy( this, iSet, varargin )
            n = length(iSet.elements);
            if n == 0
                this.elements = {};
            else
                this.elements = cell(size(iSet.elements));
                for i=1:n
                    if isa( iSet.elements{i}, 'biotracs.core.ability.Copyable' )
                        this.elements{i} = iSet.elements{i}.copy();
                    else
                        this.elements{i} = iSet.elements{i};
                    end
                end
            end
            
            this.elementNames = iSet.elementNames;
            this.classNameOfElements = iSet.classNameOfElements;
            if isempty(iSet.nameMap)
                this.nameMap = containers.Map('KeyType','char','ValueType','double');
            else
                this.nameMap = containers.Map(iSet.nameMap.keys(), iSet.nameMap.values());
            end
        end
        
    end
    
end

