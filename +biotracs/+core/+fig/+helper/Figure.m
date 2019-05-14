%"""
%biotracs.core.fig.helper.Figure
%Helper class that provides some functionalities to save figures
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%"""

classdef Figure < handle
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    methods
        function this = Figure( varargin )
        end
    end
    
    
    methods(Static)
        
        function save( iFilePath, varargin )
            [dirPath, fileName, fileExtension] = fileparts(iFilePath);
            if isempty(fileName)
                fileName = 'figure';
                %error('BIOTRACS:Figure:InvalidArgument','Invalid file path');
            end
            
            if ~isempty(fileExtension)
                fileExtension = fileExtension(2:end);
            else
                fileExtension = 'jpg';
            end
            
            if isempty(dirPath)
                dirPath = fullfile('./');
            end

            p = inputParser();
            p.addParameter('FigureHandle',[],@(x)(isa(x,'matlab.ui.Figure') || isa(x,'clustergram')));
            p.addParameter('AlsoSaveAsMatFile', true, @islogical);
            p.addParameter('Resolution', 300, @isnumeric);            
            p.addParameter('CloseAfterSaving',false,@islogical);
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            closeAfterSave = p.Results.CloseAfterSaving;
            format = fileExtension; %p.Results.Format;
            resolution = p.Results.Resolution;    
            figHandle = p.Results.FigureHandle;
            
            if isempty(figHandle)
                figHandle = get(groot,'CurrentFigure'); %avoid forcing figure creation
                if isempty(figHandle)
                    error('No figure handle found.')
                end 
            end
            
            if isa(figHandle, 'clustergram')
                ncols = length(figHandle.ColumnLabels);
                nrows = length(figHandle.RowLabels);
                if ncols > nrows
                    width = 1;
                    height = max(0.25, nrows/ncols);
                    set(figHandle, 'DisplayRatio', [0.2, 0.2*height])
                else
                    width = max(0.25, ncols/nrows);
                    height = 1;
                    set(figHandle, 'DisplayRatio', [0.2*width, 0.2])
                end
                
                figHandle.plot();
                if all( figHandle.Data(:) >= 0 ) || all( figHandle.Data(:) <= 0 )
                    mMin = min(figHandle.Data(:));
                    mMax = max(figHandle.Data(:));
                else
                    lim = max(abs(figHandle.Data(:)));
                    mMin = -lim;
                    mMax = lim;
                end
                h = gcf;
                colorbar(gca, 'location', 'manual', 'limits', [mMin, mMax], 'position', [0.05 0.1 0.01 0.8])
                set(h,'PaperPositionMode','auto','units','normalized','outerposition',[0.1 0.1 width height]*0.8);
                set(gca, 'FontSize', 6);
                closeAfterSave = false;
            else
                h = figHandle;
            end
                
            set(h,'PaperPositionMode','auto');
            if ~isfolder(dirPath)
                mkdir(dirPath);
            end

            flist = strsplit(format,',');

            figure(h);  %set the handle as current active figure
            
            if any(strcmpi(flist, 'fig')) || p.Results.AlsoSaveAsMatFile
                try
                    savefig(h, fullfile(dirPath, [fileName, '.fig']));
                catch err
                    flist{end+1} = 'jpg';
                    fprintf('Cannot save the figure as .fig format. The figrue is maybe too large. Save as .jpg format.\n%s\n', err.message)
                end
            end
            
            if any(strcmpi(flist, 'tif'))
                print('-dtiff', fullfile(dirPath, [fileName, '.tif']), ['-r', num2str(resolution)]);
            end
            
            if any(strcmpi(flist, 'jpg'))
                print('-djpeg', fullfile(dirPath, [fileName, '.jpg']), ['-r', num2str(resolution)]);
            end
            
            if isa(figHandle, 'clustergram')
                close(h);
                if closeAfterSave
                    close force;
                end
            else
                if closeAfterSave
                    close(h);
                end
            end
        end
        
        
        function xRotate( delay, shift )
            if nargin < 1, delay = 0.1; end
            if nargin < 2, shift = 5; end
            camorbit(shift,0,'data',[1 0 0]);
            drawnow;
            pause(delay);
        end
        
        function yRotate( delay, shift )
            if nargin < 1, delay = 0.1; end
            if nargin < 2, shift = 5; end
            camorbit(shift,0,'data',[0 1 0]);
            drawnow;
            pause(delay);
        end
        
        function zRotate( delay, shift )
            if nargin < 1, delay = 0.1; end
            if nargin < 2, shift = 5; end
            camorbit(shift,0,'data',[0 0 1]);
            drawnow;
            pause(delay);
        end
        
    end
end

