%"""
%biotracs.core.waitbar.Waitbar
%Waitbar object to create text or graphical wait bars
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2018
%"""

classdef Waitbar < handle
    
    properties(Constant)
        STYLES = {'text','graphic'};
        DEFAULT_STYLE = biotracs.core.waitbar.Waitbar.STYLES{1};
    end
    
    properties(SetAccess = protected)
        style = biotracs.core.waitbar.Waitbar.DEFAULT_STYLE;
        name = 'Please wait';
        isStarted = false;
    end
    
    properties(Access = private)
        strCR;  %   Carriage return pesistent variable
        h;
        lastPercentage = -1;
    end
    
    methods
        function this = Waitbar( varargin )
            this@handle();
            p = inputParser();
            p.addParameter('Style', biotracs.core.waitbar.Waitbar.DEFAULT_STYLE, @ischar);
            p.addParameter('Name', this.name, @ischar);
            p.parse( varargin{:} );
            
            if ~any(strcmp(this.STYLES, p.Results.Style))
                error('BIOTRACS:Waitbar:InvalidArgument', 'Invalid style. Valid styles are ''%s''', strjoin(this.STYLES,''','''))
            end
            
            if biotracs.core.env.Env.isGraphicalMode() && exist('waitbar','file') == 2
                this.style = p.Results.Style;
            end
            
            this.name = p.Results.Name;
        end
        
        function delete( this )
            if ~isa(this.h, 'matlab.ui.Figure')
                delete(this.h);
            end
        end
        
        function show( this, iPercentage )
            if nargin == 1 || isempty(iPercentage)
                if ~this.isStarted
                    iPercentage = 0;
                else
                    error('BIOTRACS:Waitbar:InalidArgument', 'Invalid progression percentage value. Must be a scalar numeric value in interval [0, 1]');
                end
            end
            
            if ~isscalar(iPercentage) || ~isnumeric(iPercentage) || iPercentage > 1 || iPercentage < 0
                error('BIOTRACS:Waitbar:InalidArgument', 'Invalid progression percentage value. Must be a scalar numeric value in interval [0, 1]');
            end

            if floor(100*this.lastPercentage) == floor(100*iPercentage)
                return;
            end
            
            this.lastPercentage = iPercentage;
            
            if strcmp(this.style, 'text')
                if ~this.isStarted
                    this.textprogressbar([this.name,' ']);
                    this.isStarted = true;
                    this.doWriteLog('%s', this.name);
                end
               	this.textprogressbar(iPercentage*100);
                this.doWriteLog('%d%%', floor(iPercentage*100));
                if iPercentage >= 1
                    this.textprogressbar(' Done');
                    this.doWriteLog('%s', 'Done');
                end
            else
                if ~this.isStarted
                    this.h = waitbar(iPercentage, this.name, 'Name', this.name);
                    this.isStarted = true;
                    this.doWriteLog('%s', this.name);
                else
                    waitbar(iPercentage, this.h);
                    this.doWriteLog('%d%%', floor(100*iPercentage));
                    if iPercentage >= 1
                        waitbar(iPercentage, this.h, 'Done');
                        this.doWriteLog('%s', 'Done');
                        delete(this.h);
                    end
                end
            end
        end
    end
    
    methods(Access = protected)
        
        function doWriteLog( ~, varargin )
            logger = biotracs.core.env.Env.currentLogger();
            if ~isempty(logger) && logger.isLogOpen()
                savedScreenState = logger.showOnScreen;
                savedLineBreakState = logger.noLineBreak;
                logger.setShowOnScreen(false);
                logger.setNoLineBreak(true);
                
                logger.writeLog(varargin{:});
                
                logger.setShowOnScreen(savedScreenState);
                logger.setNoLineBreak(savedLineBreakState);
            end
        end
        
        function textprogressbar(this, c)
            % This function creates a text progress bar. It should be called with a
            % STRING argument to initialize and terminate. Otherwise the number correspoding
            % to progress in % should be supplied.
            % INPUTS:   C   Either: Text string to initialize or terminate
            %                       Percentage number to show progress
            % OUTPUTS:  N/A
            % Example:  Please refer to demo_textprogressbar.m
            
            % Author: Paul Proteus (e-mail: proteus.paul (at) yahoo (dot) com)
            % Version: 1.0
            % Changes tracker:  29.06.2010  - First version
            
            % Inspired by: http://blogs.mathworks.com/loren/2007/08/01/monitoring-progress-of-a-calculation/

            % Vizualization parameters
            strPercentageLength = 10;   %   Length of percentage string (must be >5)
            strDotsMaximum      = 10;   %   The total number of dots in a progress bar
            
            %% Main
            
            if isempty(this.strCR) && ~ischar(c)
                % Progress bar must be initialized with a string
                error('The text progress must be initialized with a string');
            elseif isempty(this.strCR) && ischar(c)
                % Progress bar - initialization
                fprintf('%s',c);
                this.strCR = -1;
            elseif ~isempty(this.strCR) && ischar(c)
                % Progress bar  - termination
                this.strCR = [];
                fprintf([c '\n']);
            elseif isnumeric(c)
                % Progress bar - normal progress
                c = floor(c);
                percentageOut = [num2str(c) '%%'];
                percentageOut = [percentageOut repmat(' ',1,strPercentageLength-length(percentageOut)-1)];
                nDots = floor(c/100*strDotsMaximum);
                dotOut = ['[' repmat('.',1,nDots) repmat(' ',1,strDotsMaximum-nDots) ']'];
                strOut = [percentageOut dotOut];
                
                % Print it on the screen
                if this.strCR == -1
                    % Don't do carriage return during first run
                    fprintf(strOut);
                else
                    % Do it during all the other runs
                    fprintf([this.strCR strOut]);
                end
                
                % Update carriage return
                this.strCR = repmat('\b',1,length(strOut)-1);
            else
                % Any other unexpected input
                error('Unsupported argument type');
            end
        end
        
    end
    
end

