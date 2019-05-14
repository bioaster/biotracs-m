%"""
%biotracs.core.parser.model.BaseParserConfig
%Configuration of the BaseParser object
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.parser.model.BaseParser
%"""

classdef BaseParserConfig < biotracs.core.mvc.model.ProcessConfig
	 
	 properties(Constant)
	 end
	 
	 properties(SetAccess = protected)
	 end

	 % -------------------------------------------------------
	 % Public methods
	 % -------------------------------------------------------
	 
	 methods
		  
		  % Constructor
		  function this = BaseParserConfig()
				this@biotracs.core.mvc.model.ProcessConfig();
				this.setDescription('Configuration parameters of the BaseParser');
                this.createParam('FileDirectoryFilter', '.*', 'Constraint', biotracs.core.constraint.IsText());
                this.createParam('FileExtensionFilter', '.*', 'Constraint', biotracs.core.constraint.IsText());
                this.createParam('FileNameFilter', '.*', 'Constraint', biotracs.core.constraint.IsText());
                this.createParam('Recursive', false, 'Constraint', biotracs.core.constraint.IsBoolean()); 
		  end
		  
		  
	 end
	 
	 % -------------------------------------------------------
	 % Protected methods
	 % -------------------------------------------------------
	 
	 methods(Access = protected)
	 end

end
