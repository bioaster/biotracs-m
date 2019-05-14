%"""
%biotracs.core.model.shell.Shell
%Defines the Shell process. The Shell process allows executing external binary file through shell commands.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.model.shell.ShellConfig, biotracs.core.model.shell.Option, biotracs.core.model.shell.OptionSet
%"""

classdef Shell < biotracs.core.mvc.model.Process
    
    properties
        %outputFileExtension;
    end
    
    methods
        
        function this = Shell()
            this@biotracs.core.mvc.model.Process()
        end

    end
    
    methods(Access = protected)
        
        function [ outputDataFilePath ] = doPrepareInputAndOutputFilePaths( this, iIndex )
            dataFileSet = this.getInputPortData('DataFileSet');
            inputDataFile = dataFileSet.getAt(iIndex);
			
			outputFileExtension = this.config.getParamValue('OutputFileExtension');
			if strcmpi(outputFileExtension, '?inherit?')
				outputFileExtension = inputDataFile.getExtension();
			end
			
            outputDataFilePath = fullfile([this.config.getParamValue('WorkingDirectory'), '/', inputDataFile.getName(),  '.', outputFileExtension]);
            this.config.updateParamValue('InputFilePath', inputDataFile.getPath());
            this.config.updateParamValue('OutputFilePath', outputDataFilePath);
        end
        
        function [ n ] = doComputeNbCmdToPrepare( this )
            dataFileSet = this.getInputPortData('DataFileSet');
            n = dataFileSet.getLength();
        end
        
        function [listOfCmd, outputDataFilePaths, nbOut ] = doPrepareCommand (this)
            nbOut = this.doComputeNbCmdToPrepare();
            outputDataFilePaths = cell(1,nbOut);
            listOfCmd = cell(1,nbOut);
            for i=1:nbOut
                % -- prepare file paths
                [  outputDataFilePaths{i} ] = this.doPrepareInputAndOutputFilePaths( i );
                % -- config file export
                if this.config.getParamValue('UseShellConfigFile')
                    this.doUpdateConfigFilePath();
                    this.exportConfig( this.config.getParamValue('ShellConfigFilePath'), 'Mode', 'Shell' );
                end
                % -- exec
                [ listOfCmd{i} ] = this.doBuildCommand();
            end
            %nbOut = length(listOfCmd);
        end
        
        % Run conversion
        function doRun( this )
            [listOfCmd, outputDataFilePaths, nbOut] = this.doPrepareCommand();
            nbCmd = length(listOfCmd);
            cmdout = cell(1,nbOut);
            outputFileName = cell(1,nbOut);
            biotracs.core.parallel.startpool();
            if nbOut == 0
                this.logger.writeLog('%s', 'No input data found');
            else
                parfor sliceIndex=1:nbCmd
                    [~, cmdout{sliceIndex}] = system( listOfCmd{sliceIndex} );
                    [~, outputFileName{sliceIndex}, ~] = fileparts( outputDataFilePaths{sliceIndex} );
                end
            end
            this.doSetResultAndWriteOutLog(nbOut, outputFileName, listOfCmd, cmdout, outputDataFilePaths);  
        end
        
        function this = doSetResultAndWriteOutLog(this, numberOfOutFile, outputFileName, listOfCmd, cmdout, outputDataFilePaths) 
            results = this.getOutputPortData('DataFileSet');
            results.allocate(numberOfOutFile);
            
            %store main log file name
            mainLogFileName = this.logger.getLogFileName();
            this.logger.closeLog(true);
            
            %shell log streams in separate files
            for i=1:numberOfOutFile
                this.logger.setLogFileName(outputFileName{i});
                this.logger.openLog('w');
                this.logger.setShowOnScreen(false);
                
                this.logger.writeLog('# Command');
                this.logger.writeLog('%s', listOfCmd{i});
                this.logger.writeLog('# Command outputs');
                this.logger.writeLog('%s', cmdout{i});
                outputDataFile = biotracs.data.model.DataFile(outputDataFilePaths{i});
                results.setAt(i, outputDataFile);

                this.logger.closeLog();
            end
            
            %restore maim log stream
            this.logger.setLogFileName(mainLogFileName);
            this.logger.openLog('a');
            this.logger.setShowOnScreen(true);
            for i=1:numberOfOutFile
                this.logger.writeLog('Resource %s processed', outputFileName{i});
            end

            this.setOutputPortData('DataFileSet', results);
        end
        
        function cmd = doBuildCommand( this )
            bin = this.config.getParamValue('ExecutableFilePath');
            useConfigFilePath = this.config.getParamValue('UseShellConfigFile');
            if useConfigFilePath
                cmd = [ '"', bin, '" ', this.config.formatOptionsAsString( 'OptionsToUse', {'ShellConfigFilePath'} )  ];
            else
                cmd = [ '"', bin, '" ', this.config.formatOptionsAsString()  ];
            end
        end
        
        function doUpdateConfigFilePath( this )
            outputFilePath = this.config.getParamValue('OutputFilePath');
            [dir, name, ~] = fileparts( outputFilePath );
            configFileName = [ dir, '/', name, '.shellconfig.params', this.config.configFileExtension ];
            this.config.updateParamValue('ShellConfigFilePath', configFileName);
        end
    end
    
    methods(Static)
        
    end
    
end

