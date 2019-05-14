classdef FileImporterTests < matlab.unittest.TestCase
    
    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir, '/biotracs/core/adpater/FileImporterTests');
    end
    
    methods(TestMethodTeardown)
    end
    
    methods (Test)
        
        function testReadFiles(testCase)
            adapter = biotracs.core.adapter.model.FileImporter();
            adapter.getConfig()...
                .updateParamValue('WorkingDirectory', testCase.workingDir);
            adapter.addInputFilePath(fullfile(pwd,'/../testdata/'));
            adapter.run();
            dataFileSet = adapter.getOutputPortData('DataFileSet');
            testCase.verifyEqual( dataFileSet.getLength(), 2 );
            testCase.verifyEqual( [dataFileSet.getAt(1).getName(),'.', dataFileSet.getAt(1).getExtension()], 'datatable1.csv' );
            testCase.verifyEqual( [dataFileSet.getAt(2).getName(),'.', dataFileSet.getAt(1).getExtension()], 'datatable2.csv' );
        end
        
        
        function testReadFilesRecursive(testCase)
            adapter = biotracs.core.adapter.model.FileImporter();
            adapter.getConfig()...
                .updateParamValue('Recursive', true)...
                .updateParamValue('WorkingDirectory', testCase.workingDir);
            adapter.addInputFilePath([pwd,'/../testdata/']);
            adapter.run();
            
            dataFileSet = adapter.getOutputPortData('DataFileSet');
            testCase.verifyEqual( dataFileSet.getLength(), 3 );
            testCase.verifyEqual( [dataFileSet.getAt(1).getName(),'.', dataFileSet.getAt(1).getExtension()], 'datatable1.csv' );
            testCase.verifyEqual( [dataFileSet.getAt(2).getName(),'.', dataFileSet.getAt(2).getExtension()], 'datatable2.csv' );
            testCase.verifyEqual( [dataFileSet.getAt(3).getName(),'.', dataFileSet.getAt(3).getExtension()], 'datatable2.zip' );
        end
        
        function testDuplicateFiles(testCase)
            adapter = biotracs.core.adapter.model.FileImporter();
            adapter.getConfig()...
                .updateParamValue('WorkingDirectory', testCase.workingDir);
            adapter.addInputFilePath([pwd,'/../testdata/']);
            adapter.addInputFilePath([pwd,'/../testdata/']);
            
            try
                adapter.run();
                error('An error was expected');
            catch exception
                testCase.verifyEqual( exception.identifier, 'BIOTRACS:Set:Duplicate' );
            end
        end

        function testReadFilesRecursiveWithFilters(testCase)
            adapter = biotracs.core.adapter.model.FileImporter();
            adapter.getConfig()...
                .updateParamValue('Recursive', true)...
                .updateParamValue('FileExtensionFilter', '.zip')...
                .updateParamValue('WorkingDirectory', testCase.workingDir);
            adapter.addInputFilePath([pwd,'/../testdata/']);
            adapter.run();
            dataFileSet = adapter.getOutputPortData('DataFileSet');
            
            testCase.verifyEqual( dataFileSet.getLength(), 1 );
            testCase.verifyEqual( [dataFileSet.getAt(1).getName(),'.', dataFileSet.getAt(1).getExtension()], 'datatable2.zip' );
        end
        
        function testErrorFileNotFound(testCase)
            adapter = biotracs.core.adapter.model.FileImporter();
            adapter.getConfig()...
                .updateParamValue('Recursive', true)...
                .updateParamValue('WorkingDirectory', testCase.workingDir);
            adapter.addInputFilePath([pwd,'/../testdata/not_found_folder/']);
            try
                adapter.run();
                error('An error wes expected')
            catch err
                testCase.verifyEqual( err.identifier,  'BIOTRACS:PathReader:PathAccessRestricted' );
            end
        end
        
    end
    
end
