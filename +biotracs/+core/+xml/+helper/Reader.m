classdef Reader
    
    properties
    end
    
    methods
        
    end
    
    methods(Static)
        
        function theStruct = parseFile(filename, iAsStruct, iIndexes)
            if nargin <= 1, iAsStruct = false; end 
            if nargin <= 2, iIndexes = []; end
            try
                tree = xmlread(filename);
            catch err
                error('%s\nFailed to read XML file %s.', err.message, filename);
            end
            
            try
                theStruct = biotracs.core.xml.helper.Reader.parseChildNodes(tree, iAsStruct, iIndexes);
            catch err
                error('%s\nUnable to parse XML file %s.', err.message, filename);
            end
        end
        
        
        function children = parseChildNodes(theNode, iAsStruct, iIndexes)
            if nargin <= 1, iAsStruct = false; end
            if nargin <= 2, iIndexes = []; end

            if islogical(iIndexes)
                error('Indexes must be numeric array');
            end
            
            % Recurse over node children.
            children = [];
            if theNode.hasChildNodes
                childNodes = theNode.getChildNodes;
                numberOfChildNodes = childNodes.getLength;
                if nargin < 2 || isempty(iIndexes)
                    iIndexes = 1:numberOfChildNodes;
                end
                
                %read all the nodes
                allocCell = cell(1, numberOfChildNodes);
                children = struct(...
                    'Name', allocCell, ...
                    'Attributes', allocCell,    ...
                    'Data', allocCell, ...
                    'Children', allocCell);
                n = length(iIndexes); i = 1;
                while i <= n
                    count = iIndexes(i);
                    if count-1 >= numberOfChildNodes
                        break;
                    end
                    theChild = childNodes.item(count-1);
                    
                    child = biotracs.core.xml.helper.Reader.makeStructFromNode(theChild, iAsStruct);
                    
                    isBlankTextNode = strcmp(child.Name, '#text') && isempty(child.Data);
                    if isBlankTextNode
                        %this item is null, move forward
                        iIndexes(i:end) = iIndexes(i:end)+1;
                    else
                        children(i) = child;
                        i = i+1;
                    end
                end
                
                children(i:end) = [];
            end
        end
        
        function nodeStruct = makeStructFromNode(theNode, iAsStruct)
            if nargin <= 1, iAsStruct = false; end
            
            children = [];
            if iAsStruct
                children = biotracs.core.xml.helper.Reader.parseChildNodes(theNode, iAsStruct);
            elseif theNode.hasChildNodes
                children = theNode.getChildNodes;
            end
            
            nodeStruct = struct(                        ...
                'Name', char(theNode.getNodeName),       ...
                'Attributes', biotracs.core.xml.helper.Reader.parseAttributes(theNode),  ...
                'Data', '',                              ...
                'Children', children);
            
            if any(strcmp(methods(theNode), 'getData'))
                nodeStruct.Data = deblank(char(theNode.getData));
            else
                nodeStruct.Data = '';
            end
        end
        
        function attributes = parseAttributes(theNode)
            attributes = containers.Map('KeyType','char','ValueType','char');
            if theNode.hasAttributes
                theAttributes = theNode.getAttributes;
                numAttributes = theAttributes.getLength;
                %allocCell = cell(1, numAttributes);
                %attributes = struct('Name', allocCell, 'Value', ...
                %    allocCell);
                
                for count = 1:numAttributes
                    attrib = theAttributes.item(count-1);
                    key = char(attrib.getName);
                    val = char(attrib.getValue);
                    attributes(key) = val;
                    %attributes(count).Name = char(attrib.getName);
                    %attributes(count).Value = char(attrib.getValue);
                end
            end
        end
    end
    
    
end

