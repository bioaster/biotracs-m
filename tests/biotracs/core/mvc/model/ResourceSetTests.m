classdef ResourceSetTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)
        function testDefaultConstructor(testCase)
            import biotracs.core.mvc.model.*;
            resource = ResourceSet();
            testCase.verifyClass(resource, 'biotracs.core.mvc.model.ResourceSet');
            testCase.verifyEqual(resource.label, 'biotracs.core.mvc.model.ResourceSet');
            testCase.verifyEqual(resource.description, '');
            testCase.verifyEqual(resource.getClassName(), 'biotracs.core.mvc.model.ResourceSet');
        end
        
        
        function testConstructorWithAttributes(testCase)
            import biotracs.core.mvc.model.*;
            process = Process();
            res = ResourceSet();
            res.setProcess(process);
            res.setDescription('Short description');
            testCase.verifyClass(res, 'biotracs.core.mvc.model.ResourceSet');
            testCase.verifyEqual(res.description, 'Short description');
            testCase.verifyEqual(res.process, process);
            testCase.verifyEqual(res.getClassName(), 'biotracs.core.mvc.model.ResourceSet');
        end
        
        
        function testCopyConstructor(testCase)
            r = biotracs.core.mvc.model.ResourceSet();
            e = biotracs.core.mvc.model.Process();
            e.setLabel('MyProcess');
            r.setProcess(e);
            r.add( biotracs.data.model.DataMatrix([1,2,3]), 'MyMatrix' );
            
            r2 = biotracs.core.mvc.model.ResourceSet(r);
            testCase.verifyEmpty(r2.getProcess());
            testCase.verifyEqual(r.getElements(), r2.getElements());
            testCase.verifyTrue(r ~= r2);
        end
        
        function testAddAssignResource(testCase)
            import biotracs.core.mvc.model.*;
            resource = ResourceSet();

            element1 = ResourceSet();
            resource.add( element1 );
            testCase.verifyEqual(length(resource.getElements()), 1);
            testCase.verifyEqual(resource.getAt(1), resource.elements{1});
            
            element2 = ResourceSet();
            resource.add( element2 );
            testCase.verifyEqual(length(resource.getElements()), 2);
            testCase.verifyEqual(resource.getAt(2), resource.elements{2});
            
            element3 = ResourceSet();
            resource.setAt( 2, element3 );
            testCase.verifyEqual(length(resource.getElements()), 2);
            testCase.verifyEqual(resource.getAt(2), element3);
            
            %duplicate elements => OK;
            resource.add( element2 );
            testCase.verifyEqual(length(resource.getElements()), 3);
            testCase.verifyEqual(getLength(resource), 3);
        end
        
        function testCopy(testCase)
            r1 = biotracs.core.mvc.model.ResourceSet();
            
            r2 = biotracs.core.mvc.model.Resource();
            r2.setLabel('Resource1');
            r3 = biotracs.core.mvc.model.Resource();
            r2.setLabel('Resource2');
            
            r1.add(r2).add(r3);

            testCase.verifyEqual( r1, r1.copy() );
        end
        
    end
    
end
