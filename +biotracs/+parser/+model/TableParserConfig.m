%"""
%biotracs.parser.model.TableParserConfig
%Configuration of TableParser process
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.parser.model.TableParser
%"""

classdef TableParserConfig < biotracs.core.parser.model.BaseParserConfig
	 
	 properties(Constant)
	 end
	 
	 properties(SetAccess = protected)
	 end

	 % -------------------------------------------------------
	 % Public methods
	 % -------------------------------------------------------
	 
	 methods
		  
		  % Constructor
		  function this = TableParserConfig( )
				this@biotracs.core.parser.model.BaseParserConfig( );
				this.setDescription('Configuration parameters of the table parser');
                this.createParam('ReadRowNames', true,      'Constraint', biotracs.core.constraint.IsBoolean());
                this.createParam('ReadColumnNames', true,   'Constraint', biotracs.core.constraint.IsBoolean());
                this.createParam('Replace', {});
                this.createParam('Delimiter', '\t',         'Constraint', biotracs.core.constraint.IsText());
                this.createParam('FileEncoding', 'UTF-8',   'Constraint', biotracs.core.constraint.IsText());
                this.createParam('NbHeaderLines', 0,        'Constraint', biotracs.core.constraint.IsGreaterThan(0));
                this.createParam('MissingValues', '',       'Constraint', biotracs.core.constraint.IsText());
                this.createParam('FileType', '',            'Constraint', biotracs.core.constraint.IsInSet({'','text','spreadsheet'}));
                this.createParam('Mode', 'simple',          'Constraint', biotracs.core.constraint.IsInSet({'simple','extended'}));
                this.createParam('NamesOfRowsToIgnore', {}, 'Constraint', biotracs.core.constraint.IsText('IsScalar', false));
                this.createParam('Sheet', 1);
                this.createParam('TableClass', '',          'Constraint', biotracs.core.constraint.IsText(), 'Description', 'The expected class of the table to be parsed'); 
                this.createParam('RowNamePatterns', {},     'Constraint', biotracs.core.constraint.IsText('IsScalar', false));
                this.createParam('ColumnNamePatterns', {},  'Constraint', biotracs.core.constraint.IsText('IsScalar', false));
                
                this.updateParamValue('FileExtensionFilter', '.xlsx,.xls,.csv,.tsv,.txt');
		  end
		  
		  
	 end
	 
	 % -------------------------------------------------------
	 % Protected methods
	 % -------------------------------------------------------
	 
	 methods(Access = protected)
	 end

end
