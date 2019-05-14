classdef DocTests < matlab.unittest.TestCase

    properties (TestParameter)
    end

    methods (Test)
        
%         function TestDoc(testCase)
%             file = './testdata/xml/toy.xml';
%             
%             doc = biotracs.core.xml.Doc(file);
% 
%             testCase.verifyClass( doc, 'biotracs.core.xml.Doc' );
%             testCase.verifyEqual( doc.name, 'city' );
%             testCase.verifyEqual( length(doc.children), 1 );
%             testCase.verifyClass( doc.children, 'org.apache.xerces.dom.DeferredElementImpl' );
%             
%             [ domElts ] = doc.parseChildren();
%             testCase.verifyEqual( length(domElts), 3 );
%         end

        function TestDoc2(testCase)
            file = './testdata/xml/toy.xml';
            
            doc = biotracs.core.xml.Doc(file);
            
            testCase.verifyClass( doc, 'biotracs.core.xml.Doc' );
            testCase.verifyEqual( doc.getLength, 1 );
            testCase.verifyEqual( doc.getName, '#document' );
            testCase.verifyEmpty( doc.getAttributes );
            testCase.verifyEmpty( doc.getData );

            node = doc.getFirstChild();
            testCase.verifyClass( node, 'biotracs.core.xml.DomElement' );
            testCase.verifyEqual( node.getLength, 7 );
            testCase.verifyEqual( node.getName, 'city' );
            attr = node.getAttributes();
            testCase.verifyEqual( attr('country'), 'France' );
            testCase.verifyEmpty( node.getData );

            testCase.verifyEqual( node.getPrev(), biotracs.core.xml.DomElement.empty() );
             
            node = node.getFirstChild('zone');
            testCase.verifyEqual( node.getLength, 3 );
            testCase.verifyEqual( node.getName, 'zone' );
            attr = node.getAttributes();
            testCase.verifyEqual( attr('name'), 'north' );
            testCase.verifyEmpty( node.getData ); 
        end
        
        function TestReadXML(testCase)
            file = './testdata/xml/toy.xml';
            doc = biotracs.core.xml.Doc(file);
            
            % ---
            s = doc.parseAsStruct();
            s = s.Children;
            testCase.verifyEqual( s.Name, 'city' );
            testCase.verifyEqual( length(s.Children), 3 );
            testCase.verifyEqual( s.Children(1).Name, 'zone' );
            testCase.verifyEqual( s.Children(2).Name, 'zone' );
            testCase.verifyEqual( s.Children(3).Name, 'doc' );
        end
        
    end
    
end
