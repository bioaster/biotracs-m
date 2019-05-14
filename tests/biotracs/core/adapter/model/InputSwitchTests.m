classdef InputSwitchTests < matlab.unittest.TestCase

    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir, '/biotracs/core/adpater/InputSwitchTests');
    end
    
    methods(TestMethodTeardown)
    end
    
    methods (Test)
        
        function testOutputSwitch(testCase)
            fileImporter1 = biotracs.core.adapter.model.FileImporter();
            fileImporter1.addInputFilePath('../testdata/zip/');
            
            fileImporter2 = biotracs.core.adapter.model.FileImporter();
            fileImporter2.getConfig()...
                .updateParamValue('Recursive', true);
            fileImporter2.addInputFilePath('../testdata/');
            
            fileImporter3 = biotracs.core.adapter.model.FileImporter();
            fileImporter3.addInputFilePath('../testdata/zip/');
            
            iSwitch = biotracs.core.adapter.model.InputSwitch();
            iSwitch.resizeInput(3);
            iSwitch.switchOn(2);
            
            fileImporter1.getOutputPort('DataFileSet').connectTo( iSwitch.getInputPort('Resource#1') );
            fileImporter2.getOutputPort('DataFileSet').connectTo( iSwitch.getInputPort('Resource#2') );
            fileImporter3.getOutputPort('DataFileSet').connectTo( iSwitch.getInputPort('Resource#3') );
            
            w = biotracs.core.mvc.model.Workflow();
            w.addNode( fileImporter1, 'FileImporter1' );
            w.addNode( fileImporter2, 'FileImporter2' );
            w.addNode( fileImporter3, 'FileImporter3' );
            w.addNode( iSwitch, 'InputSwitch' );
            w.getConfig()....
                .updateParamValue('WorkingDirectory', testCase.workingDir);

            w.run();
            
            r = iSwitch.getOutputPortData('Resource');
            testCase.verifyEqual( r.getLength, 3 );
            testCase.verifyEqual( r.getAt(1).getName(), 'datatable1' );
            testCase.verifyEqual( r.getAt(2).getName(), 'datatable2' );
            testCase.verifyEqual( r.getAt(3).getName(), 'datatable2' );
        end

        
    end
    
end
