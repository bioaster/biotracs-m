%"""
%biotracs.core.utils.savefig
%Save a MATLAB figure as image (`.jpg, .png, ...`) or `.fig` file
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%* See: biotracs.core.fig.helper.Figure
%"""

function [oImageName, oFigureName] = savefig( iDirPath, iFileName, varargin )
    fprintf('Function biotracs.core.utils.savefig is deprecated. Please use function biotracs.core.fig.helper.Figure.save instead\n');

    p = inputParser();
    p.addParameter('Format', 'jpg', @ischar);
    p.addParameter('Resolution', '300', @ischar);
    p.addParameter('FigureHandle', [], @(x)(isa(x,'clustergram') || isa(x,'matlab.ui.Figure')));
    p.parse(varargin{:});
    
    iFormat = p.Results.Format;
    iHandle = p.Results.FigureHandle;
    iResolution = p.Results.Resolution;

    closeAfterSave = false;

    if isempty(iHandle)
        h = get(groot,'CurrentFigure'); %avoid forcing figure creation
        if isempty(h)
            error('No figure handle found.')
        end
    elseif isa(iHandle, 'clustergram')
        ncols = length(iHandle.ColumnLabels);
        nrows = length(iHandle.RowLabels);
        if ncols > nrows
            width = 1;
            height = max(0.25, nrows/ncols);
            set(iHandle, 'DisplayRatio', [0.2, 0.2*height])
        else
            width = max(0.25, ncols/nrows);
            height = 1;
            set(iHandle, 'DisplayRatio', [0.2*width, 0.2])
        end
        
        iHandle.plot();
        if all( iHandle.Data(:) >= 0 ) || all( iHandle.Data(:) <= 0 )
            mMin = min(iHandle.Data(:));
            mMax = max(iHandle.Data(:));
        else
            lim = max(abs(iHandle.Data(:)));
            mMin = -lim;
            mMax = lim;
        end
        h = gcf;
        colorbar(gca, 'location', 'manual', 'limits', [mMin, mMax], 'position', [0.05 0.1 0.01 0.8])
        set(h,'PaperPositionMode','auto','units','normalized','outerposition',[0.1 0.1 width height]*0.8);
        set(gca, 'FontSize', 6);
        closeAfterSave = false;
    else
        h = iHandle;
    end
    
    if isempty(h)
        error('No figure handle found.')
    end
    
    set(h,'PaperPositionMode','auto');
    if ~isfolder(iDirPath)
        mkdir(iDirPath);
    end
    
    try
        oFigureName = [iFileName, '.fig'];
        savefig(h, [iDirPath, '/', oFigureName], 'compact');
    catch
        fprintf('Cannot save as .fig. The file is maybe too large\n');
    end
    
    figure(h)  %set figure a
    
    if any(strcmp(iFormat, {'tiff', 'tif'}))
        oImageName = [iFileName, '.tiff'];
        print('-dtiff', [iDirPath, '/', oImageName], ['-r', num2str(iResolution)]);
    elseif strcmp(iFormat, 'jpg')
        oImageName = [iFileName, '.jpg'];
        print('-djpeg', [iDirPath, '/', oImageName], ['-r', num2str(iResolution)]);
    end
    
    if closeAfterSave
        close(h);
    end
end
