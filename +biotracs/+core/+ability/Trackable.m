%"""
%biotracs.core.ability.Trackable
%Base class to handle process tracking. A Trackable is Parametrable object
%that is also associated with a Logger. It parameters and logs can be saved
%for traceability purposes.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.logger.Logger
%"""

classdef (Abstract) Trackable < biotracs.core.ability.Parametrable
    
    properties( Constant )
    end
    
    properties(SetAccess = protected)
        logger;
    end
    
    methods
        
        % Constructor
        function this = Trackable( )
            this@biotracs.core.ability.Parametrable();
            biotracs.core.logger.Logger(this);            
        end

        %-- A --
        
        %-- B --
        
        function this = bindLogger( this, iLogger )
            if ~isa(iLogger, 'biotracs.core.logger.Logger')
                error('BIOTRACS:Logger:InvalidArguments', 'The logger must be a biotracs.core.logger.Logger');
            end
            this.logger = iLogger;
        end
        
%         %-- C --
%         
%         function closeLog( this )
%             this.logger.closeLog();
%         end
%         
%         %-- G --
%         
%         %-- O --
%         
%         function openLog( this, iPermission )
%             if ~isa( this.logger, 'biotracs.core.logger.Logger' )
%                 error('BIOTRACS:Logger:NoLoggerDefined', 'Please, bind a logger to the Trackable object');
%             end
%             if nargin == 1
%                 iPermission = 'w';
%             end
%             this.logger.openLog(iPermission);   
%         end
%         
%         %-- R --
%         
%         %-- S --
%         
%         % Set the log interval
%         function this = setLogInterval( this, iInterval )
%             this.logger.setLogInterval( iInterval );
%         end
%         
%         %-- W --
%         
%         function writeLog( this, varargin )
%             this.logger.writeLog( varargin{:} );
%         end
        
    end
    
    methods(Access = protected)
        
        function doCopy( this, iTrackable, varargin )
            this.doCopy@biotracs.core.ability.Parametrable( iTrackable, varargin{:} );
            % logger is empty ...
            % will be automatically created when opening log
        end
        
    end
    
end

