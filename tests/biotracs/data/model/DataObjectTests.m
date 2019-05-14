classdef DataObjectTests < matlab.unittest.TestCase
    
    methods (Test)
        
        function testDefaultConstructor(testCase)
            
            data = biotracs.data.model.DataObject();
            testCase.verifyClass(data, 'biotracs.data.model.DataObject');
            testCase.verifyEqual(data.label, 'biotracs.data.model.DataObject');
            testCase.verifyEqual(data.description, '');
            
            process = biotracs.core.mvc.model.Process();
            data.setProcess( process );
            testCase.verifyEqual(data.process, process);
            
        end
        
        function testCopyConstructor(testCase)
            do = biotracs.data.model.DataObject();
            do.setData({1,2,3,4});
            do.createParam('param1', 123);
            e = biotracs.core.mvc.model.Process();
            e.setLabel('MyProcess');
            do.setProcess( e );
            
            do2 = do.copy();
            testCase.verifyEqual(do2.data, do.data);
            testCase.verifyTrue(do2 ~= do);
            
            do.setLabel('new label');
            testCase.verifyEqual(do.getLabel(), 'new label');
            testCase.verifyEqual(do2.getLabel(), 'biotracs.data.model.DataObject');
        end
    
    end
    
end
