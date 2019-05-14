%"""
%biotracs.core.ability.Parametrable
%Base class to handle Parametrable objects. A Parametrable is an object
%associated with a set of Parameter objects. For instance a ProcessConfig
%is a Parametrable.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.mvc.model.ProcessConfig, biotracs.core.mvc.model.Parameter
%"""

classdef (Abstract) Parametrable < biotracs.core.ability.Comparable
    
    properties(Constant)
    end
    
    properties(GetAccess = private, SetAccess = protected)
        paramData = containers.Map.empty();
    end
    
    events
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = Parametrable()
            this@biotracs.core.ability.Comparable();
            this.paramData = containers.Map();
        end

        %-- A --
        
        % Add a new Parameter
        %> @param[in] iParam Parameter to add
        %> @throw Error if a parameter with the same name already exists
        function this = addParam( this, iParam )
            if this.paramExist( iParam.getName() )
                error('BIOTRACS:Parametrable:Duplicate','This parameter already exists');
            else
                this.paramData(iParam.getName()) = iParam;
            end
        end
        
        % Test that all the constraints of the parameters are validated
        %> @return True if constraints are valid, False otherwise
        function [tf, message] = areConstraintsValidated( this )
            tf = true;
            message = '';
            paramNames = this.getParamNames();
            for i=1:length( paramNames  )
                name = paramNames{i};
                param = this.paramData(name);
                tf = param.areConstraintsValidated();
                if ~tf
                    message = [ 'Parameter ''', name ,''' does not fullfill constraints. Actual value is: ', biotracs.core.utils.stringify(param.getValue()) ];
                    return;
                end
            end
        end
        
        %-- C --

        % Test that all the constraints are validated
        %> @throw Error if the cosntraints are not valid
        function checkParameterConstraints( this )
            [tf, message] = this.areConstraintsValidated();
            if ~tf
                error('BIOTRACS:Parametrable:ConstraintNotValidated', message);
            end
        end
        
        % Create an instance of Parameter and add it
        %> @param[in] iParamName Name ot the Parameter
        %> @param[in] iValue [default = []] Value ot the Parameter
        %> @param[in] iHydratable [default = true] Hydratable property of the Parameter
        %> @return The created parameter
        function param = createParam( this, iParamName, iValue, varargin )
            if nargin < 3, iValue = []; end
            param = biotracs.core.mvc.model.Parameter( iParamName, iValue, varargin{:} );
            this.addParam( param );
        end
        
        % Create several instances of Parameter and add them
        % By default all the parameters are hydratable
        %> @param[in] iListOfParamsAndValues A cell containing parameters
        % names and 'values {'ParamName_1', 'ParamValue_1', 'ParamName_2', 'ParamValue_2', ...}
        %> @param[in] iHydratable Hydratable property of the Parameter
        function this = createParams( this, iListOfParamsAndValues, iHydratable )
            if isempty(iListOfParamsAndValues)
                return;
            end
            if nargin < 3, iHydratable = true; end
            for i = 1:2:length(iListOfParamsAndValues)
                name = iListOfParamsAndValues{i};
                val = iListOfParamsAndValues{i+1};
                param = biotracs.core.mvc.model.Parameter( name, val, iHydratable );
                this.addParam( param );
            end
        end
        
        %-- E --

        function exportParams(this, iFilePath, varargin)
            if nargin == 1
                error('BIOTRACS:Parametrable:InvalidFilePath','An output file path is required');
            end
            
            p = inputParser();
            p.addParameter('DisplayContent', false, @islogical);
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
            
            [filedir,~,ext] = fileparts(iFilePath);
            if ~isempty(filedir) && ~isfolder(filedir)
                mkdir(filedir);
            end
            
            switch lower(ext)
                case '.mat'
                    param = this.paramData; %#ok<NASGU>
                    save( iFilePath, 'paramData', '-mat' );
                case {'.json'}
                    jsonStr =  this.getParamsAsJson( varargin{:} );
                    fid = fopen( iFilePath, 'w' );
                    fprintf(fid, '%s', jsonStr );
                    fclose(fid);
                    if p.Results.DisplayContent
                        type(iFilePath);
                    end
                case {'.txt','.csv'}
                    textStr =  this.getParamsAsText( varargin{:} );
                    fid = fopen( iFilePath, 'w' );
                    fprintf(fid, '%s', textStr );
                    fclose(fid);
                    if p.Results.DisplayContent
                        type(iFilePath);
                    end
                case {'.xml'}
                    [docNode, ~] = this.getParamsAsXml( varargin{:} );
                    xmlwrite(iFilePath,docNode);
                    if p.Results.DisplayContent
                        type(iFilePath);
                    end
                otherwise
                    textStr =  this.getParamsAsText( varargin{:} );
                    fid = fopen( iFilePath, 'w' );
                    fprintf(fid, '%s', textStr );
                    fclose(fid);
                    if p.Results.DisplayContent
                        type(iFilePath);
                    end
            end
        end
        
        %-- G --
        
        % Get a parameter by it name
        % ToDo: getParamByName()
        function param = getParam( this, iParamName )
            if this.paramExist( iParamName )
                param = this.paramData(iParamName);
            else
                error('BIOTRACS:Parametrable:ParameterNotFound', 'Parameter ''%s'' is not found', iParamName);
            end
        end
        
        function paramValue = getParamValue( this, iParamName )
            if this.paramExist( iParamName )
                paramValue = this.paramData(iParamName).getValue();
            else
                error('BIOTRACS:Parametrable:ParameterNotFound', 'Parameter ''%s'' is not found', iParamName);
            end
        end
        
        function paramNames = getParamNames( this )
            paramNames = keys(this.paramData);
        end
        
        % Get the parameters as regular Matalab struct
        function oParamStruct = getParamsAsStruct( this, varargin )
            paramNames = this.getParamNames();
            n = length(paramNames);
            if n == 0 
                oParamStruct = struct([]); 
                return;
            end
            for i=1:n
                name = paramNames{i};
                oParamStruct.(name) = this.getParam(name).getPropertiesAsStruct( true );
            end
        end
        
        function oParamCell = getParamsAsCell( this, varargin )
            p = inputParser();
            p.addParameter('ListOfParams', {});
            p.parse(varargin{:});
            
            paramNames = this.getParamNames();
            nbParams = length( paramNames  );
            oParamCell = cell(1,nbParams);
            for i=1:nbParams
                name = paramNames{i};
                if ~isempty(p.Results.ListOfParams) && ~any(strcmpi(names,p.Results.ListOfParams))
                    continue;
                end
                oParamCell{i} = {name, this.getParamValue(name)};
            end
            oParamCell = horzcat( oParamCell{:} );
        end
        
        function oJson = getParamsAsJson( this, varargin )
            oJson = jsonencode( this.getParamsAsStruct( varargin{:} ) );
        end

        % By defautl the json format is used
        function [ txtStr ] = getParamsAsText( this, varargin )
            error('BIOTRACS:Parametrable:NotYetImplemented', 'Not implemented for this class');
        end

        function [ docNode, paramNode ] = getParamsAsXml( this, varargin )
            p = inputParser();
            p.addParameter('DocNode', [], @(x)(isa(x, 'org.apache.xerces.dom.DocumentImpl')));
            p.addParameter('Label', '', @ischar);
            p.addParameter('Description', '', @ischar);
            p.addParameter('Version', '1.0', @ischar);
            p.addParameter('XMLSchemaLocation', '', @ischar);
            p.addParameter('XMLNoNamespaceSchemaLocation', '', @ischar);
            p.KeepUnmatched = true;
            p.parse( varargin{:} );
            
            if isempty(p.Results.DocNode)
                docNode = com.mathworks.xml.XMLUtils.createDocument(lower(biotracs.core.env.Env.name()));
            end
            
            docRootNode = docNode.getDocumentElement;
            docRootNode.setAttribute('version',p.Results.Version);
            docRootNode.setAttribute('xmlns:xsi','http://www.w3.org/2001/XMLSchema-instance');
            docRootNode.setAttribute('xsi:schemaLocation',p.Results.XMLSchemaLocation);
            docRootNode.setAttribute('xsi:noNamespaceSchemaLocation',p.Results.XMLNoNamespaceSchemaLocation);
            
            %> parametrable node
            paramNode = docNode.createElement('parametrable');
            paramNode.setAttribute('name', p.Results.Label);
            paramNode.setAttribute('description', p.Results.Description);
            paramNode.setAttribute('class', class(this));
            
            %> meta item
            t = datetime('now','TimeZone','local','Format','yyyy-MM-dd''T''HH:mm:ssZZZZZ');
            item = docNode.createElement('meta');
            item.setAttribute('name', 'meta');
            item.setAttribute('datetime', sprintf('%s',t));
            item.setAttribute('description', [ 'Generated by ' biotracs.core.env.Env.version(true)]);
            item.setAttribute('version', biotracs.core.env.Env.version());
            paramNode.appendChild(item);

            this.doAppendParamItemsToXmlNode( docNode, paramNode );
            docRootNode.appendChild( paramNode );
        end
        
        %-- H --
        
        % Hydrate this object with the Parameter of another object
        %> @param[in] iHydrator A biotracs.core.ability.Parametrable object
        % or a cell of (name,value) pairs
        %> @throw Error if @a iParametrable is not a Parametrable
        function hydrateWith( this, iHydrator, varargin  )
            if isa(iHydrator, 'biotracs.core.ability.Parametrable')
                this.doHydrateWithParametrable( iHydrator, varargin{:} );
            elseif iscell( iHydrator )
                this.doHydrateWithListOfValues( iHydrator, varargin{:} );
            else
                error('BIOTRACS:Parametrable:InvalidArguments', 'The hydrator (or data) must be a Paramterable of a cell of (name,value) pairs');
            end
        end
        
        function tf = isParamValueEqual( this, iParamName, iExpectedValue )
            if this.paramExist(iParamName)
                tf = isequal(this.getParam(iParamName).getValue(), iExpectedValue);
            else
                error('BIOTRACS:Parametrable:ParameterNotFound', 'Parameter ''%s'' is not found', iParamName)
            end
        end
        
        %-- I --
        
        function tf = isEqualTo( this, iParametrable, iIsStrict )
            if nargin <= 2
                iIsStrict = false;
            end
            lhsParamNames = this.getParamNames();
            rhsParamNames = iParametrable.getParamNames;
            n1 = length(lhsParamNames);
            n2 = length(rhsParamNames);
            
            haveSameParamNames = ...
                (n1 == n2) & ...
                ismember(lhsParamNames, rhsParamNames) & ...
                ismember(rhsParamNames, lhsParamNames);
            
            if ~haveSameParamNames
                tf = false; 
                return;
            end

            for i=1:n1
                lhsParam = this.paramData(lhsParamNames{i});
                rhsParam = iParametrable.paramData(lhsParamNames{i});
                tf = lhsParam.isEqual(rhsParam, iIsStrict);
                if ~tf, break; end
            end
        end
        
        function tf = isParamValueEmpty( this, iParamName )
            if this.paramExist(iParamName)
                tf = isempty( this.getParam(iParamName).getValue() );
            else
                error('BIOTRACS:Parametrable:ParameterNotFound', 'Parameter ''%s'' is not found', iParamName)
            end
        end
        
        % Import paramter values from a xml file
        function this = importParams( this, iFilePath )
            [ ~, ~, ext ] = fileparts(iFilePath);
            switch lower(ext)
                case {'.mat'}
                    var = load( iFilePath, '-mat' );
                    this.paramData = var.paramData;
                case {'.xml'}
                    keyVals = this.readKeyValParamFromXmlFile(iFilePath); 
                    this.hydrateWith(keyVals, 'SkipPrivateParam', true);
                case {'.json'}
                    error('BIOTRACS:Parametrable:NotYetImplemented', 'Not yet available');
                case {'.txt','.csv'}
                    error('BIOTRACS:Parametrable:InvalidFormat', 'Parameters can only be imported from .mat, .xml, .json');
                otherwise
                    error('BIOTRACS:Parametrable:InvalidFormat', 'Parameters can only be imported from .mat, .xml, .json');
            end
        end
        
        %-- P --

        function tf = paramExist( this, iParamName )
            tf = isKey(this.paramData, iParamName);
        end
        
        %-- R --
        
        function this = removeParam( this, iParamName )
            if this.paramExist(iParamName )
                this.paramData = remove( this.paramData, iParamName );
            else
                error('BIOTRACS:Parametrable:ParameterNotFound', 'Parameter ''%s'' is not found', iParamName);
            end
        end
        
        %-- S --
        
        %-- U --
        
        % Update a parameter value
        %> @param[in] iParamName Name of the parameter to update
        %> @param[in] iValue) pairs
        %> @return The parametrable
        %> @throw Error if the parameter does not exist
        function this = updateParamValue( this, iParamName, iValue )
            if this.paramExist( iParamName )
                param = this.paramData(iParamName);
                param.setValue( iValue );
            else
                error(...
                    'BIOTRACS:Parametrable:ParameterNotFound', ...
                    'Parameter ''%s'' is not found. Valid names are {''%s''}', iParamName, strjoin(this.getParamNames(),''',''')...
                    );
            end
        end
        
        % Update a parameter value
        %> @param[in] iParamName Name of the parameter to update
        %> @param[in] iValue Value to set
        %> @return The parametrable
        %> @throw Error if the parameter does not exist
        function this = updateParamConstraint( this, iParamName, iConstraint )
            if this.paramExist(iParamName )
                param = this.paramData(iParamName);
                param.setConstraint( iConstraint );
            else
                error('BIOTRACS:Parametrable:ParameterNotFound', 'Parameter  ''%s'' is not found', iParamName);
            end
        end
        
    end
    
    methods(Access = protected)
        
        function doCopy( this, iParametrable, varargin )
            this.doCopy@biotracs.core.ability.Comparable( iParametrable, varargin{:} );
            this.hydrateWith( iParametrable, 'CreateParamIfNotExists', true );
        end
        
        function doHydrateWithParametrable( this, iParametrable, varargin  )
            if ~isa(iParametrable, 'biotracs.core.ability.Parametrable')
                error('BIOTRACS:Parametrable:InvalidArguments', 'Can only hydrate with another biotracs.core.ability.Parametrable')
            end

            p = inputParser();
            p.addParameter('CreateParamIfNotExists', false, @islogical);
            p.addParameter('ParamToSkip', {}, @iscellstr);
            p.addParameter('SkipPrivateParam', true, @islogical);
            p.addParameter('SkipProtectedParam', true, @islogical);
            p.KeepUnmatched(true);
            p.parse( varargin{:} );
            
            
            paramNames = iParametrable.getParamNames();
            for i=1:length( paramNames  )
                paramName = paramNames{i};
                if any(ismember(p.Results.ParamToSkip, paramName)), return; end
                
                if this.paramExist(paramName)
                    param = this.getParam(paramName);
                    if p.Results.SkipPrivateParam && param.isPrivate(), continue; end
                    if p.Results.SkipProtectedParam && param.isProtected(), continue; end
                    param.hydrateWith( iParametrable.getParam(paramName) );
                elseif p.Results.CreateParamIfNotExists
                    %this.addParam( ...
                    %    iParametrable.getParam(paramName) ...
                    %);
                    param = iParametrable.getParam(paramName).copy();
                    this.addParam(param);
                end
            end
        end
        
        function doHydrateWithListOfValues( this, iListOfValues, varargin  )           
            n = length(iListOfValues);
            if n == 0
                return;
            end
            
            if ~iscell(iListOfValues) || rem(n,2) ~= 0
                error('BIOTRACS:Parametrable:InvalidArguments', 'The list must be a cell of (name,value) pairs');
            end

            p = inputParser();
            p.addParameter('CreateParamIfNotExists', false, @islogical);
            p.addParameter('ParamToSkip', {}, @iscellstr);
            p.addParameter('SkipPrivateParam', true, @islogical);
            p.addParameter('SkipProtectedParam', true, @islogical);
            p.KeepUnmatched(true);
            p.parse( varargin{:} );
            
            paramNames = iListOfValues(1:2:end);
            paramValues = iListOfValues(2:2:end);

            for i=1:length( paramNames  )
                paramName = paramNames{i};
                if any(ismember(p.Results.ParamToSkip, paramName)), return; end
                if this.paramExist(paramName)
                    param = this.getParam(paramName);
                    if p.Results.SkipPrivateParam && param.isPrivate(), continue; end
                    if p.Results.SkipProtectedParam && param.isProtected(), continue; end
                    param.setValue( paramValues{i} );
                elseif p.Results.CreateParamIfNotExists
                    param = biotracs.core.mvc.model.Parameter( paramNames{i}, paramValues{i} );
                    this.addParam( param );
                end
            end
        end
        
        function this = doAppendParamItemsToXmlNode( this, docNode, sectionNode )
            paramNames = this.getParamNames();
            for i=1:length(paramNames)
                name = paramNames{i};
                param = this.getParam(name);   
                
                if param.isPrivate()
                    continue;
                end

                node = docNode.createElement('parameter');
                node.setAttribute('name', param.name);
                node.setAttribute('description', param.description);
                node.setAttribute('unit', param.unit);
                node.setAttribute('access', biotracs.core.utils.stringify(param.access));
                node.setAttribute('class', class(param));
                
                if iscellstr(param.value)
                    for j=1:length(param.value)
                        item = docNode.createElement('vdata');
                        item.setAttribute('value', biotracs.core.utils.stringify(param.value{j}));
                        node.appendChild(item);
                    end
                else
                    node.setAttribute('value', biotracs.core.utils.stringify(param.value));
                end
                
                for j=1:length(param.constraint)
                    item = docNode.createElement('constraint');
                    c = param.getConstraint();
                    props = c.getPropertiesAsList();
                    n = size(props,1);
                    
                    item.setAttribute('class', class(c));
                    for k=1:n
                        item.setAttribute(...
                            biotracs.core.utils.stringify(props{k,1}), ...
                            biotracs.core.utils.stringify(props{k,2}));
                    end
                    node.appendChild(item);
                end
                
                sectionNode.appendChild(node);
            end
        end

    end
    
    
    methods(Static)
  
        function keyVals = readKeyValParamFromXmlFile( iFilePath )
            docXML = biotracs.core.xml.Doc(iFilePath);
            biotracsXML = docXML.getFirstChild(lower(biotracs.core.env.Env.name()));
            xmlStruct = biotracsXML.getFirstChild('parametrable').parseAsStruct();

            n = length(xmlStruct.Children);
            keyVals = cell(1,2*n); cpt1 = 1;
            for i=1:n
                paramStruct = xmlStruct.Children(i);
                if strcmp(paramStruct.Name, 'meta'), continue; end
                if ~strcmp(paramStruct.Name, 'parameter'), continue; end

                attrMap = paramStruct.Attributes;
                hasNameAttribute = isKey(attrMap, 'name');
                hasValueAttribute = isKey(attrMap, 'value');
                
                if ~hasNameAttribute, continue; end
                
                % read param value(s)
                name = attrMap('name');
                if hasValueAttribute
                    try
                        value = eval(attrMap('value'));
                    catch
                        value = attrMap('value');
                    end
                else
                    %read vdata chidren
                    paramChildrenStruct = paramStruct.Children;
                    m = length(paramChildrenStruct);
                    value = cell(1,n); cpt2 = 1;
                    for k=1:m
                        paramChild = paramChildrenStruct(k);
                        if strcmp(paramChild.Name, 'vdata')
                            vDataAttr = paramChild.Attributes;
                            try
                                value{cpt2} = eval(vDataAttr('value'));
                            catch
                                value{cpt2} = vDataAttr('value');
                            end
                            cpt2 = cpt2 + 1;
                        end
                    end
                    value(cpt2:end) = [];
                end

                keyVals{cpt1} = name;
                keyVals{cpt1+1} = value;
                cpt1 = cpt1 + 2;
            end
            
            keyVals(cpt1:end) = [];
        end
        
    end
    
end
