%"""
%biotracs.core.color.Color
%Color object to manage color panels
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.color.Rgb
%"""

classdef Color < handle
    
    properties
        rbgPanel = struct(...
                    'blue',       [0 0 1],...
                    'royalblue',  [0.2549  0.4118  0.8824],...
                    'indigo',     [0.2941  0  0.5098],...
                    'cyan',       [0 1 1],...
                    'magenta',    [1 0 1],...
                    'purple',     [0.5020  0  0.5020],...
                    'red',        [1 0 0],...
                    'orange',     [1 0.2706  0],...
                    'coral',      [1 0.4980  0.3137],...
                    'maroon',     [0.5020  0 0],...
                    'green',      [0 1 0],...
                    'brown',      [0.6471  0.1647  0.1647],...
                    'black',      [0 0 0],...
                    'grey',       [0.5 0.5 0.5],...
                    'lightgrey',  [0.8 0.8 0.8],...
                    'darkgrey',   [0.2 0.2 0.2],...
                    'yellow',     [1 1 0]...
         );
    end
    
    methods

        function p = getRgbPanel( this, iColorName )
            if nargin == 2
                if ~isfield(this.rbgPanel, iColorName)
                    error('Undefined color');
                end
                p = this.rbgPanel.(iColorName);
            else
                p = cell2mat(struct2cell(this.rbgPanel));
            end
        end
        
    end
    
    methods( Static )
        
        function map = colormap( iLength )
            map = [
                0         0.4470    0.7410
                0.8500    0.3250    0.0980
                0.9290    0.6940    0.1250
                0.4940    0.1840    0.5560
                0.4660    0.6740    0.1880
                0.3010    0.7450    0.9330
                0.6350    0.0780    0.1840
                0.2157    0.7529    0.7961
                1         0         1
                1         0         0
                0         0         1
                0         0         0
                0.5       0.5       0.5
            ];
            map = repmat(map,10,1);
            if nargin == 1
                iLength = min(iLength, size(map,1));
                map = map(1:iLength,:);
            end
        end
        
    end
    
end

