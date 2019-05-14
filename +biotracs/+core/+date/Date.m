%"""
%biotracs.core.date.Date
%Date object to create and manipulate date values and format date values as
%text
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%"""

classdef Date < handle
    
    properties
    end
    
    methods( Static )
        
        function datetime = now( iFormat )
            if nargin == 0
                datetime = datestr(now,'yyyy-mm-dd HH:MM:SS');
            elseif strcmp( iFormat, 'compact' )
                datetime = datestr(now,'yyyymmddHHMMSS');
            else
                error('Wrong format')
            end
        end
        
        function y = year()
            y = datestr(now,'yyyy');
        end
        
        function t = time( iFormat )
            if nargin == 0
                t = datestr(now,'HH:MM:SS');
            elseif strcmp( iFormat, 'compact' )
                t = datestr(now,'HHMMSS');
            else
                error('Wrong format')
            end
        end
        
        function d = date( iFormat )
            if nargin == 0
                d = datestr(now,'yyyy-mm-dd');
            elseif strcmp( iFormat, 'compact' )
                d = datestr(now,'yyyymmdd');
            else
                error('Wrong format')
            end
        end
        
        function str = elapsedTime( sec )
            min = fix(sec/60);
            if min == 0
                str = sprintf('%gs', sec);
                return;
            end
            
            sec = rem(sec,60);
            h = fix(min/60);
            if h == 0
                str = sprintf('%gm %gs', min, sec);
                return;
            end
            
            min = rem(min,60);
            d = fix(h/24);
            if d == 0
                str = sprintf('%gH %gm %gs', h, min, sec);
                return;
            end
            
            h = rem(h,24);
            str = sprintf('%gD %gH %gm %gs', d, h, min, sec);
        end
    end
    
end

