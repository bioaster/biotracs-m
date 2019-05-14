classdef DemuxTests < matlab.unittest.TestCase

    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir, '/biotracs/core/adpater/DemuxTests');
    end
    
    methods(TestMethodTeardown)
    end
    
    methods (Test)
        
        function testDemux(testCase)
            fasta{1} = biotracs.data.model.DataFile( './mockup_folder/mockup_data1.csv' );
            fasta{2} = biotracs.data.model.DataFile( './mockup_folder/mockup_data2.csv' );
            fasta{3} = biotracs.data.model.DataFile( './mockup_folder/mockup_data3.csv' );
            resourceSet = biotracs.core.mvc.model.ResourceSet();
            resourceSet.add(fasta{1}, 'Data1')...
                .add(fasta{2}, 'Data2')...
                .add(fasta{3}, 'Data3');
            
            demux = biotracs.core.adapter.model.Demux();
            demux.getConfig()...
                .updateParamValue('WorkingDirectory', testCase.workingDir);

            %outputs not yet allocated
            try
                r{1} = demux.getOutputPortData('Resource#1');
                error('An error was expected');
            catch err
                testCase.verifySubstring( err.identifier, 'PortSet:UnknownPortName' ); 
            end
            
            % Resize with amultiplier N
            demux.resizeOutput(3);
            demux.setInputPortData('ResourceSet', resourceSet);
            demux.run();
            r{1} = demux.getOutputPortData('Resource#1');
            r{2} = demux.getOutputPortData('Resource#2');
            r{3} = demux.getOutputPortData('Resource#3');
            testCase.verifyEqual( r{1}, resourceSet.getAt(1) );
            testCase.verifyEqual( r{2}, resourceSet.getAt(2) );
            testCase.verifyEqual( r{3}, resourceSet.getAt(3) );
            try
                r{4} = demux.getOutputPortData('Resource#4');
                error('An error was expected');
            catch err
                testCase.verifySubstring( err.identifier, 'PortSet:UnknownPortName' ); 
            end

            
            % Resize with a resource set
            demux.reset();
            demux.resizeOutputWith(resourceSet);
            demux.setInputPortData('ResourceSet', resourceSet);
            demux.run();
            r{1} = demux.getOutputPortData('Data1');
            r{2} = demux.getOutputPortData('Data2');
            r{3} = demux.getOutputPortData('Data3');
            testCase.verifyEqual( r{1}, resourceSet.getAt(1) );
            testCase.verifyEqual( r{2}, resourceSet.getAt(2) );
            testCase.verifyEqual( r{3}, resourceSet.getAt(3) );
            try
                r{4} = demux.getOutputPortData('Resource#1');
                error('An error was expected');
            catch err
                testCase.verifySubstring( err.identifier, 'PortSet:UnknownPortName' ); 
            end
        end

        
    end
    
end
