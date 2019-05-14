classdef FileDispatcherTests < matlab.unittest.TestCase

    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir, '/biotracs/core/adpater/FileDispatcherTests');
    end
    
    methods(TestMethodTeardown)
    end
    
    methods (Test)
        
        function testDemultiplexer(testCase)
            f{1} = biotracs.data.model.DataFile( './mockup_folder/mockup_data1.csv' );
            f{2} = biotracs.data.model.DataFile( './mockup_folder/mockup_data2.csv' );
            f{3} = biotracs.data.model.DataFile( './mockup_folder/mockup_data3.csv' );
            
            resourceSet = biotracs.data.model.DataFileSet();
            resourceSet.add(f{1})...
                .add(f{2})...
                .add(f{3});
            
            demux = biotracs.core.adapter.model.FileDispatcher();
            demux.getConfig()...
                .updateParamValue('WorkingDirectory', testCase.workingDir);
            demux.setInputPortData('DataFileSet', resourceSet);

            %outputs not yet allocated
            try
                r{1} = demux.getOutputPortData('Resource#1');
                error('An error was expected');
            catch err
                testCase.verifySubstring( err.identifier, 'PortSet:UnknownPortName' ); 
            end
            
            demux.resizeOutput(3)
            demux.run();

            %retrieve each output
            r{1} = demux.getOutputPortData('Resource#1');
            r{2} = demux.getOutputPortData('Resource#2');
            r{3} = demux.getOutputPortData('Resource#3');
            
            try
                r{4} = demux.getOutputPortData('Resource#4');
                error('An error was expected');
            catch err
                testCase.verifySubstring( err.identifier, 'PortSet:UnknownPortName' ); 
            end
            
            for i=1:3
                dfs = biotracs.data.model.DataFileSet();
                dfs.add( resourceSet.getAt(i) );
                
                testCase.verifyEqual( r{i}.getAt(1), dfs.getAt(1) );
            end
        end

        
    end
    
end
