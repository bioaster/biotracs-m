classdef MuxTests < matlab.unittest.TestCase
    
    properties
        workingDir = fullfile(biotracs.core.env.Env.workingDir, '/biotracs/core/adpater/MuxTests');
    end
    
    methods(TestMethodTeardown)
    end
    
    methods (Test)
        
        function r = testMultiplexer(testCase)
            data{1} = biotracs.data.model.DataTable.import( '../testdata/datatable1.csv' );
            data{2} = biotracs.data.model.DataTable.import( '../testdata/datatable2.csv' );
            data{3} = biotracs.data.model.DataTable.import( '../testdata/datatable2.csv' );
            
            
            mux = biotracs.core.adapter.model.Mux();
            mux.resizeInput(3);
            c = mux.getConfig();
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            
            mux.setInputPortData('Resource#1', data{1});
            mux.setInputPortData('Resource#2', data{2});
            mux.setInputPortData('Resource#3', data{3});
            
            try
                mux.setInputPortData('Resource#4', data{3});
                error('An error was expected');
            catch err
                testCase.verifyEqual( err.identifier, 'PortSet:UnknownPortName' );
            end
            
            mux.run();
            r = mux.getOutputPortData('ResourceSet');
            
            testCase.verifyEqual( getLength(r), 3 );
            testCase.verifyEqual( numel(r), 1 );
            testCase.verifyEqual( class(r), 'biotracs.core.mvc.model.ResourceSet' );
            for i=1:3
                testCase.verifyEqual( r.getAt(i), data{i} );
            end
        end
        
        function r = testMultiplexerOneFile(testCase)
            data{1} = biotracs.data.model.DataTable.import( '../testdata/datatable1.csv' );

            mux = biotracs.core.adapter.model.Mux();
            mux.resizeInput(1);
            c = mux.getConfig();
            c.updateParamValue('WorkingDirectory', testCase.workingDir);     
            mux.setInputPortData('Resource', data{1});
            mux.run();
            
            r = mux.getOutputPortData('ResourceSet');
            
            testCase.verifyEqual( getLength(r), 1 );
            testCase.verifyEqual( numel(r), 1 );
            testCase.verifyEqual( class(r), 'biotracs.core.mvc.model.ResourceSet' );
            testCase.verifyEqual( r.getAt(1), data{1} );
        end
        
        
        function r = testMultiConnect(testCase)
            f{1} = biotracs.data.model.DataFile( '../mockup_folder/toy_fasta.fa' );
            f{2} = biotracs.data.model.DataFile( '../mockup_folder/toy_fasta.fa' );
            f{3} = biotracs.data.model.DataFile( '../mockup_folder/toy_fasta.fa' );
            dfs = biotracs.data.model.DataFileSet();
            dfs.add(f{1}).add(f{2}).add(f{3});
                        
            demux = biotracs.core.adapter.model.Demux();
            c = demux.getConfig();
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            demux.setInputPortData('ResourceSet', dfs);
            demux.resizeOutput(3);
                 
            mux = biotracs.core.adapter.model.Mux();
            c = mux.getConfig();
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            
            %test connection error
            try
                demux.connectOutput( mux.getInput() );
                error('An error was expected');
            catch err
                testCase.verifyEqual( err.identifier, 'PortSet:CannotConnectPortSet' );
            end
            
            %connect all input ports in one shut!
            demux.connectOutput( mux.getInput(), 'ResizeWhenUnmatch', true );
            
            try
                mux.setInputPortData('Resource#4', f{3});
                error('An error was expected');
            catch err
                testCase.verifyEqual( err.identifier, 'PortSet:UnknownPortName' );
            end

            demux.run();
            mux.run();
            
            r = mux.getOutputPortData('ResourceSet');
            testCase.verifyEqual( getLength(r), 3 );
            testCase.verifyEqual( numel(r), 1 );
            testCase.verifyEqual( class(r), 'biotracs.core.mvc.model.ResourceSet' );
        end
        
        
          function r = testMultiConnectFileDispacherMux(testCase)
            f{1} = biotracs.data.model.DataFile( '../mockup_folder/toy_fasta.fa' );
            f{2} = biotracs.data.model.DataFile( '../mockup_folder/toy_fasta.fa' );
            f{3} = biotracs.data.model.DataFile( '../mockup_folder/toy_fasta.fa' );
            dfs = biotracs.data.model.DataFileSet();
            dfs.add(f{1}).add(f{2}).add(f{3});
                        
            fileDispatcher = biotracs.core.adapter.model.FileDispatcher();
            c = fileDispatcher.getConfig();
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            fileDispatcher.setInputPortData('DataFileSet', dfs);
            fileDispatcher.resizeOutput(3);
             
            mux = biotracs.core.adapter.model.Mux();
            c = mux.getConfig();
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            mux.resizeInput(3);
            
            %connect all input ports in one shut!
            fileDispatcher.connectOutput( mux.getInput, 'ConnectionStrategy', 'indices' );

            try
                mux.setInputPortData('Resource#4', f{3});
                error('An error was expected');
            catch err
                testCase.verifyEqual( err.identifier, 'PortSet:UnknownPortName' );
            end

            fileDispatcher.run();
            mux.run();
            r = mux.getOutputPortData('ResourceSet');
            
            testCase.verifyEqual( getLength(r), 3 );
            testCase.verifyEqual( numel(r), 1 );
            testCase.verifyEqual( class(r), 'biotracs.core.mvc.model.ResourceSet' );
        end
        
    end
    
end
