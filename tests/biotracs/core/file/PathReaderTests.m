classdef PathReaderTests < matlab.unittest.TestCase

    properties (TestParameter)
    end
    
    methods (Test)

        function testConstructor(testCase)
            filePath = './testdata';
            
            dataFileSet = biotracs.core.file.helper.PathReader.read( filePath );
            testCase.verifyEqual( dataFileSet.getLength, 3 );
            
            dataFileSet = biotracs.core.file.helper.PathReader.read( filePath, 'FileExtensionFilter', '.txt' );
            testCase.verifyEqual( dataFileSet.getLength, 2 );
            
            dataFileSet = biotracs.core.file.helper.PathReader.read( filePath, 'Recursive', true );
            testCase.verifyEqual( dataFileSet.getLength, 4 );
            
            dataFileSet = biotracs.core.file.helper.PathReader.read( filePath, 'FileExtensionFilter', '.txt', 'Recursive', true );
            testCase.verifyEqual( dataFileSet.getLength, 3 );
            
            dataFileSet = biotracs.core.file.helper.PathReader.read( filePath, 'FileNameFilter', 'file1', 'FileExtensionFilter', '.txt', 'Recursive', true );
            testCase.verifyEqual( dataFileSet.getLength, 2 );
        end
        
    end
    
end
