%"""
%biotracs.data.view.DataTable
%DataTable view
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%* See: biotracs.data.model.DataTable
%"""

classdef DataTable < biotracs.data.view.DataObject
    
    properties(SetAccess = protected)      
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        function this = DataTable()
            this@biotracs.data.view.DataObject();
        end
        
        
        function this = viewHtml( this, varargin )
			p = inputParser();
			p.addParameter('WorkingDirectory', '', @ischar)
			p.parse(varargin{:});
			
            table = biotracs.core.html.Table( this.model );
            website = biotracs.core.html.Website();
            doc = website.getIndexDoc();
            doc.append( table );
            
			wd = '';
			if ~this.model.getProcess().isNil() && isempty( p.Results.WorkingDirectory )
				wd = this.model.getProcess()...
					.getConfig()...
					.getParamValue('WorkingDirectory');
			else
				wd = fullfile(p.Results.WorkingDirectory);
			end
			
			if isempty(wd)
				wd = biotracs.core.env.Env.tempFolderPath();
			end
		
			if ~isfolder(wd) && ~mkdir(wd)
				error('BIOTRACS:DataTable:DiskAccessRestriction', 'The working dorectory does not exist and cannot be created. Please check disk access rights');
			end
				
            website.setBaseDirectory( wd );
            website.generateHtml();
            website.show();
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)  

    end
    
    % -------------------------------------------------------
    % Static methods
    % -------------------------------------------------------
    
    methods(Static)

    end
end
