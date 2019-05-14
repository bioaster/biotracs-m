classdef FileExporterTests < matlab.unittest.TestCase

    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir, '/biotracs/core/adpater/FileExporterTests');
    end
    
    methods(TestMethodTeardown)
    end
    
    methods (Test)
        
        function testWriteMatFiles(testCase)
            dataTable1 = biotracs.data.model.DataTable.import( '../testdata/datatable1.csv' );
            dataTable2 = biotracs.data.model.DataTable.import( '../testdata/datatable2.csv' );
            
            adapter = biotracs.core.adapter.model.FileExporter();
            adapter.getConfig()...
                .updateParamValue('WorkingDirectory', testCase.workingDir);
            
            rset = biotracs.core.mvc.model.ResourceSet();
            rset.add(dataTable1)....
                .add(dataTable2);
            
            adapter.setInputPortData('Resource', rset);
            adapter.run();
                
            testCase.verifyTrue( isfile(fullfile(testCase.workingDir, rset.label, '/datatable1.mat')) ); 
            testCase.verifyTrue( isfile(fullfile(testCase.workingDir, rset.label, '/datatable2.mat')) ); 
        end

        function testWriteTextFiles(testCase)
            dataTable1 = biotracs.data.model.DataTable.import( '../testdata/datatable1.csv' );
            dataTable2 = biotracs.data.model.DataTable.import( '../testdata/datatable2.csv' );

            adapter = biotracs.core.adapter.model.FileExporter();
            adapter.getConfig()...
                .updateParamValue('WorkingDirectory', testCase.workingDir)...
                .updateParamValue('FileExtension', '.txt');
            
            rset = biotracs.core.mvc.model.ResourceSet();
            rset.add(dataTable1)...
                .add(dataTable2);
            
            adapter.setInputPortData('Resource', rset);
            adapter.run();
            
            testCase.verifyTrue( isfile(fullfile(testCase.workingDir, rset.label, '/dataTable1.txt')) ); 
            testCase.verifyTrue( isfile(fullfile(testCase.workingDir, rset.label, '/dataTable2.txt')) ); 
        end
        
    end
    
end
