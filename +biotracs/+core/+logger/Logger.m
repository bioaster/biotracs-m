%"""
%biotracs.core.logger.Logger
%Logger objects allows manipulating and creating process logs
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%* See: biotracs.data.model.Trackable
%"""

classdef Logger < handle
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
        %trackable;          %the trackable object to log
        logDirectory = '';
        logFileName = '';
        logInterval = 1;
        fileId = -1;
        creationDateTime = biotracs.core.date.Date.now( 'compact' );
        showOnScreen = true;
        noLineBreak = false;
        
        %isInSharedMemory = false;
    end
    
    properties(Access = private)
        trackedClassName = '';
        counter = 0;
        buffer = '';
        sepLine = '-------------------------------------------------------';
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        %Constructor
        function this = Logger( iTrackable )
            this@handle();
            if ~isa(iTrackable, 'biotracs.core.ability.Trackable')
                error('BIOTRACS:Logger:InvalidArguments', 'Invalid argument. A ''biotracs.core.ability.Trackable'' is required')
            end
            %this.trackable = iTrackable;
            iTrackable.bindLogger(this);
            
            this.trackedClassName = class(iTrackable);
            %this.buffer = sprintf('Log file for %s.\nCreation date: %s\n', trackableClassName, biotracs.core.date.Date.now() );
        end
  
        %Destructor
        function delete( this )
            %if ~this.isInSharedMemory
                this.closeLog();
            %end
            this.delete@handle();
        end
        
        % -- D --
        
        function deleteLog( this )
            try
                this.closeLog();
            catch
            end
            
            try
                delete( this.getLogFilePath() );
            catch err
                error('BIOTRACS:Logger:CannotDeleteLogFile', 'Cannot delete the log file ''%s''.\n%s', this.getLogFilePath(), err.message());
            end
        end
        
        %-- C --
        
        function closeLog( this, iSilent )
            if this.isLogOpen()
                if ~isempty( this.buffer )
                    fprintf(this.fileId, '%s\n', this.buffer);
                end
                
                if nargin == 1 || ~iSilent
                    fprintf(this.fileId, '\n\nClosing date: %s', biotracs.core.date.Date.now() );
                end
                fclose(this.fileId);
                this.fileId = -1;
                this.buffer = '';
            end
        end
        
        %-- G --
        
        function oDir = getLogDirectory( this )
            %oDir = trackableConfig.getParamValue('WorkingDirectory');
            oDir = this.logDirectory;
        end
        
        function oDir = getLogFileName( this )
            oDir = this.logFileName;
        end
        
        function oPath = getLogFilePath( this )
            oPath = fullfile(this.getLogDirectory(), [this.logFileName, '.log']);
        end

        %-- I --
        
        function tf = isLogOpen( this )
            tf = (this.fileId ~= -1);
        end
        
        
        %-- O --
        
        function openLog( this, iPermission )
            if this.isLogOpen()
                return;
            end

            if nargin < 2
                iPermission = 'w';
            end
            
            if isempty(this.logFileName)
                %this.logFileName = this.trackable.getLabel();
                error('BIOTRACS:Logger:EmptyLogFileName', 'The name of the log file is empty');
            end
            
            workingDir = this.getLogDirectory();
            if ~isempty(workingDir) && ~isfolder(workingDir) && ~mkdir(workingDir)
                error('BIOTRACS:Logger:CannotCreateLogDirectory', 'Cannot create log directory %s', workingDir );
            end
                
            if ~this.isLogOpen()
                this.fileId = fopen(this.getLogFilePath(), iPermission);	  %discard, write
            end
            
            if ~this.isLogOpen()
                error('BIOTRACS:Logger:CannotCreateLogFile', 'Cannot create or open log file ''%s''.\nPlease check that the log directory exists or is not empty.', this.getLogFilePath());
            end
            
            if ismember(iPermission, {'w','w+'})
                this.buffer = sprintf('Log file for %s.\nCreation date: %s\n', this.trackedClassName, biotracs.core.date.Date.now() );
            end
        end
        
        function section( this, iSectionName )
            this.buffer = sprintf('%s\n\n%s\n%s\n%s', this.buffer, this.sepLine, iSectionName, this.sepLine );
        end
        
        %-- L --
        
        %-- R -

        %-- S --
        
        function setLogDirectory( this, iDirectory )
            if this.isLogOpen()
                error('BIOTRACS:Logger:LogFileOpen', 'The current log file is open. Please close the file before'); 
            end
            this.logDirectory = fullfile(iDirectory);
        end
        
        function setLogFileName( this, iFileName )
            if this.isLogOpen()
               error('BIOTRACS:Logger:LogFileOpen', 'The current log file is open. Please close the file before'); 
            end
            this.logFileName = iFileName;
        end
        
        function setNoLineBreak( this, tf )
            this.noLineBreak = tf;
        end
        
        
        function setShowOnScreen( this, tf )
            this.showOnScreen = tf;
        end
        
        function setLogInterval( this, iValue )
            if ~isscalar(iValue)
                error('BIOTRACS:Logger:InvalidArguments', 'Invalid value, a scalar numeric is required')
            end
            this.logInterval = iValue;
        end
        
        %-- W --
        
        function writeLog( this, varargin )
            if ~this.isLogOpen()
                %will differ the writing  of log on disk
                %error('BIOTRACS:Logger:NoLogFileOpened', 'No log file opened');
            end
            
            if ~iscell(varargin)
                error('BIOTRACS:Logger:InvalidArguments', 'Invalid arguments. Function wirteLog takes same arguments as sprintf function');
            end
            
            str = sprintf(varargin{:});
            if this.noLineBreak
                this.buffer = sprintf('%s %s', this.buffer, str);
            else
                str = sprintf('%s:\t%s', biotracs.core.date.Date.now(), str);
                this.buffer = sprintf('%s\n%s', this.buffer, str);
            end
            
            %write in file
            if mod( this.counter, this.logInterval ) == 0 && this.isLogOpen()
                fprintf(this.fileId, '%s', this.buffer);
                this.buffer = '';
            end

            % write on sreen
            if this.showOnScreen
                fprintf(varargin{:});
                fprintf('\n');
            end
            
            this.counter = this.counter+1;
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function doCopy( this, iLogger, varargin )
            this.doCopy@biotracs.core.ability.Copyable( iLogger, varargin{:} );
            %this.trackable = biotracs.core.ability.Copyable.deepCopy(iLogger.trackable);
            this.buffer = iLogger.buffer;
            this.logInterval = iLogger.logInterval;
            this.fileId = iLogger.fileId;
            this.logFileName = iLogger.logFileName;
            this.creationDateTime = iLogger.logFileName;
            this.counter = 0; 
        end
        
    end
    
%     methods(Access = {?biotracs.core.env.Env})
%         function setIsInSharedMemory( this, tf )
%             this.isInSharedMemory = tf;
%         end
%     end
    
    % -------------------------------------------------------
    % Static methods
    % -------------------------------------------------------
    
    methods (Static)
    end
    
end
