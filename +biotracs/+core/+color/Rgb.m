%"""
%biotracs.core.color.Rgb
%Rgb object to manage color panels. Deprecated: Will be discared.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.color.Color
%"""

classdef Rgb < biotracs.core.color.Color
	 
	 properties(Access = private)
		  base	 = 1;
		  yellow	=	[1 1 0];
		  magenta	=	[1 0 1];
		  cyan	=	[0 1 1];
		  red	  =	[1 0 0];
		  green	=	[0 1 0];
		  blue	=	[0 0 1];
		  white	=	[1 1 1];
		  black	=	[0 0 0];
	 end
	 
	 methods
	 end
	 
end

