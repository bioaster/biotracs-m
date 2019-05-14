classdef DataFileTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)
        function testDefaultConstructor(testCase)
            data = biotracs.data.model.DataFile('c:/test/test/oui.txt');
            testCase.verifyClass(data, 'biotracs.data.model.DataFile');
            testCase.verifyEqual(data.label, 'oui');
            testCase.verifyEqual(data.data, 'c:\test\test\oui.txt');
            
            process = biotracs.core.mvc.model.Process();
            data.setProcess( process );
            testCase.verifyEqual(data.process, process);
        end
      
        
        function testCopy(testCase)
             df = biotracs.data.model.DataFile('c:/test/test/oui.txt');
             dfCopy =  df.copy();
             testCase.verifyFalse(df == dfCopy)
             testCase.verifyEqual(df, dfCopy)
        end
        
    end
    
end
