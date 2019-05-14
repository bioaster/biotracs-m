classdef OutputSwitchTests < matlab.unittest.TestCase

    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir, '/biotracs/core/adpater/OutputSwitchTests');
    end
    
    methods(TestMethodTeardown)
    end
    
    methods (Test)
        
        function testOutputSwitch(testCase)
            fileExporter1 = biotracs.core.adapter.model.FileExporter();
            fileExporter1.getConfig()...
                .updateParamValue('FileExtension', '.csv');
            
            fileExporter2 = biotracs.core.adapter.model.FileExporter();
            fileExporter2.getConfig()...
                .updateParamValue('FileExtension', '.csv');
            
            fileExporter3 = biotracs.core.adapter.model.FileExporter();
            fileExporter3.getConfig()...
                .updateParamValue('FileExtension', '.csv');

            oSwitch = biotracs.core.adapter.model.OutputSwitch();
            oSwitch.resizeOutput(3);
            oSwitch.switchOn(2);
            
            dataMatrix = biotracs.data.model.DataTable({'Paris','Dog';'Cat','NY'}, {'C1','C2'}, {'R1', 'R2'});
            dataMatrix.setLabel('MyData');
            passer = biotracs.core.adapter.model.Passer();
            passer.setInputPortData('Resource',dataMatrix);

            passer.getOutputPort('Resource').connectTo( oSwitch.getInputPort('Resource') );
            oSwitch.getOutputPort('Resource#1').connectTo( fileExporter1.getInputPort('Resource') );
            oSwitch.getOutputPort('Resource#2').connectTo( fileExporter2.getInputPort('Resource') );
            oSwitch.getOutputPort('Resource#3').connectTo( fileExporter3.getInputPort('Resource') );
                        
            w = biotracs.core.mvc.model.Workflow();
            w.addNode( passer, 'Passer' );
            w.addNode( fileExporter1, 'FileExporter1' );
            w.addNode( fileExporter2, 'FileExporter2' );
            w.addNode( fileExporter3, 'FileExporter3' );
            w.addNode( oSwitch, 'OutputSwitch' );
            w.getConfig()....
                .updateParamValue('WorkingDirectory', testCase.workingDir);
            
            w.run();

            wdir1 = fileExporter1.getConfig().getParamValue('WorkingDirectory');
            wdir2 = fileExporter2.getConfig().getParamValue('WorkingDirectory');
            wdir3 = fileExporter3.getConfig().getParamValue('WorkingDirectory');

            testCase.verifyTrue( ~isfile([wdir1, '/MyData.csv']) );
            testCase.verifyTrue( isfile([wdir2, '/MyData.csv']) );
            testCase.verifyTrue( ~isfile([wdir3, '/MyData.csv']) );
            
            exportedDataMatrix = biotracs.data.model.DataTable.import( [wdir2, '/MyData.csv'] );
            testCase.verifyEqual( exportedDataMatrix.data, dataMatrix.data );
            testCase.verifyEqual( exportedDataMatrix.rowNames, dataMatrix.rowNames );
            testCase.verifyEqual( exportedDataMatrix.columnNames, dataMatrix.columnNames );
        end

        
    end
    
end
