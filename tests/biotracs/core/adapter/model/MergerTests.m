classdef MergerTests < matlab.unittest.TestCase
    
    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir, '/biotracs/core/adpater/MergerTests');
    end
    
    methods(TestMethodTeardown)
    end
    
    methods (Test)
        
        function r = testMergeSingle(testCase)
            dataFiles{1} = biotracs.data.model.DataFile( '../mockup_folder/mockup_data1.csv' );
            dataFiles{2} = biotracs.data.model.DataFile( '../mockup_folder/mockup_data2.zip' );
            dataFileSet = biotracs.data.model.DataFileSet();
            dataFileSet.setElements( dataFiles );
            
            merger = biotracs.core.adapter.model.Merger();
            merger.resizeInput(1);
            merger.getConfig()...
                .updateParamValue('WorkingDirectory', fullfile(testCase.workingDir,'MergeSingle'));
            
            merger.setInputPortData('ResourceSet', dataFileSet);

            merger.run();
            r = merger.getOutputPortData('ResourceSet');
            
            r.summary();
            testCase.verifyEqual( r, dataFileSet );
        end
        
        
        function r = testMergeSeveral(testCase)
            dataFiles{1} = biotracs.data.model.DataFile( '../mockup_folder/mockup_data1.csv' );
            dataFiles{2} = biotracs.data.model.DataFile( '../mockup_folder/mockup_data2.csv' );
            dataFiles{3} = biotracs.data.model.DataFile( '../mockup_folder/mockup_data22.tab' );
            dataFiles{4} = biotracs.data.model.DataFile( '../mockup_folder/mockup_data21.xml' );
            dataFileSet1 = biotracs.data.model.DataFileSet();
            dataFileSet1.setElements( dataFiles );
            
            dataFiles{1} = biotracs.data.model.DataFile( '../mockup_folder/mockup_data3.csv' );
            dataFiles{2} = biotracs.data.model.DataFile( '../mockup_folder/mockup_data4.csv' );
            dataFiles{3} = biotracs.data.model.DataFile( '../mockup_folder/mockup_data5.fa' );
            dataFileSet2 = biotracs.data.model.DataFileSet();
            dataFileSet2...
                .add(dataFiles{1}, 'File1')...
                .add(dataFiles{2}, 'File2')...
                .add(dataFiles{3}, 'File3');
            
            dataFiles{1} = biotracs.data.model.DataFile( '../mockup_folder/mockup_data11.fa' );
            dataFiles{2} = biotracs.data.model.DataFile( '../mockup_folder/mockup_data12.fa' );
            dataFiles{3} = biotracs.data.model.DataFile( '../mockup_folder/mockup_data13.fa' );
            dataFileSet3 = biotracs.data.model.DataFileSet();
            dataFileSet3...
                .add(dataFiles{1}, 'File1#')...
                .add(dataFiles{2}, 'File2#')...
                .add(dataFiles{3}, 'File3#');
                
            merger = biotracs.core.adapter.model.Merger();
            merger.resizeInput(3);
            merger.getConfig()...
                .updateParamValue('WorkingDirectory', fullfile(testCase.workingDir,'MergeSeveral'));
            
            merger.setInputPortData('ResourceSet#1', dataFileSet1)...
                .setInputPortData('ResourceSet#2', dataFileSet2)...
                .setInputPortData('ResourceSet#3', dataFileSet3);

            merger.run();
            r = merger.getOutputPortData('ResourceSet');
            
            r.summary();
            testCase.verifyEqual( getLength(r), 10 );
            testCase.verifyEqual( r.getElementNames(), [dataFileSet1.getElementNames(), dataFileSet2.getElementNames(), dataFileSet3.getElementNames()] );
            testCase.verifyEqual( r.getAt(5), dataFileSet2.getAt(1) );
            testCase.verifyEqual( r.getAt(10), dataFileSet3.getAt(3) );
        end

    end
    
end
