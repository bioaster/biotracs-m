%"""
%biotracs.core.env.Env
%Environment object (behaves like a Singleton,
%https://en.wikipedia.org/wiki/Singleton_pattern). This object is stores all the environment variables of BioTracs.
%All environment variables are persistent variables (as global variables) and are accessible all along the execution of all BioTracs processes.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%"""

classdef Env < handle
    
    properties(Access = private)
        currentLogger_
        externalDir_
        isGraphicalMode_
        logDir_
        name_
        rootDir_
        workingDir_
    end
    
    methods(Access = private)
        
        function this = Env()
            this@handle()
        end
        
    end
    
    methods(Static)
        
        %-- A --
        
        function oPath = appName( iPath )
            persistent persistentRootDir;
            if nargin
                persistentRootDir = iPath;
            else
                persistentRootDir = biotracs.core.env.Env.name();
            end
            oPath = persistentRootDir;
        end
        
        %-- B --

        %-- C --
        
        function company = company()
            company = 'BIOASTER';
        end
        
        %-- D --

        %-- G --

        function oLogger = currentLogger( iLogger )
            persistent logger;
            if nargin
                logger = iLogger;
            end
            oLogger = logger;
        end
        
        %-- E --

        %-- I --
        
        function tf = isGraphicalMode()
            tf = false;
            return;
            %tf = java.lang.System.getProperty( 'java.awt.headless' );
            %tf = isempty(tf) || ~tf;
        end
        
        %-- L --
        
        function oPath = logDir( iPath )
            persistent persistentLogDir;
            if nargin
                persistentLogDir = iPath;
            end
            oPath = persistentLogDir;
        end
        
        %-- N --
        
        function name = name()
            name = 'BIOTRACS';
        end
        
        %-- M --
        
        %-- O --
        
        %-- P --
        
        
        %-- R --

        function oPath = depNames( iNames )
            persistent persistentRootDir;
            if nargin
                persistentRootDir = iNames;
            end
            oPath = persistentRootDir;
        end
        
        function oPath = depPaths( iPaths )
            persistent persistentRootDir;
            if nargin
                persistentRootDir = iPaths;
            end
            oPath = persistentRootDir;
        end
        
        function oPath = depPathTokens( iTokens )
            persistent persistentRootDir;
            if nargin
                persistentRootDir = iTokens;
            end
            oPath = persistentRootDir;
        end
        
        %-- T --
        
        function oPath = tempDir()
            oPath = tempdir();
        end
        
        function oPath = tempFolderPath()
            oPath = fullfile(biotracs.core.env.Env.tempFilePath());
        end
        
        function oPath = tempFilePath()
            oPath = fullfile(tempdir(), [biotracs.core.env.Env.name(), '_', biotracs.core.utils.uuid()]);
        end
        
        %-- U --
        
        function udir = userDir()
            if ispc
                udir = getenv('USERPROFILE');
            else
                udir = getenv('HOME');
            end
        end
        
        %-- V --
        
        function oVars = vars( iVariables )
            persistent vars;
            if nargin
                if isstruct(iVariables)
                    if ~isstruct(vars) 
                        vars = struct();
                    end
                    
                    names = fieldnames(iVariables);
                    for i=1:length(names)
                        if ischar(names{i})
                            vars.(names{i}) = iVariables.(names{i});
                        end
                    end
                    oVars = vars;
                elseif ischar(iVariables)
                    if isempty(vars)
                        error('BIOTRACS:Env:VariableNotSet', 'No variables are set');
                    end
                    oVars = vars.(iVariables);
                    
                    %replace wildcards
                    depPaths = biotracs.core.env.Env.depPaths();
                    depPathTokens = strcat('%',biotracs.core.env.Env.depPathTokens(),'%');

                    if ischar(oVars)
                        oVars = regexprep(...
                            oVars, ...
                            regexptranslate('escape', [{'%WORKING_DIR%', '%USER_DIR%'}, depPathTokens]), ...
                            strrep([{biotracs.core.env.Env.workingDir(), biotracs.core.env.Env.userDir()}, depPaths],'\','\\') ...
                        );
                    end
                end
            else
                oVars = vars;
            end
        end
        
        function tf = varExists( iVariableName )
            try 
                biotracs.core.env.Env.vars(iVariableName);
                tf = true;
            catch
                tf = false;
            end
        end
        
        function v = version( full )
            if nargin == 1 && full
                v = [biotracs.core.env.Env.name(),' 0.1'];
            else
                v = '0.1';
            end
        end
        
        %-- W --

        function oPath = workingDir( iPath )
            persistent persistentWorkingDirectory;
            if nargin
                persistentWorkingDirectory = iPath;
            end
            oPath = persistentWorkingDirectory;
            if isempty(oPath)
                oPath = biotracs.core.env.Env.tempFolderPath();
            end
            
            oPath = fullfile(oPath);
        end
        
        function writeLog( varargin )
           logger = biotracs.core.env.Env.currentLogger();
           if ~isempty(logger)
               logger.writeLog(varargin{:});
           else
               fprintf( varargin{:} );
               fprintf('\n');
           end
        end
    end
    
end

