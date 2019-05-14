%"""
%biotracs.data.model.DataFileSet
%Set of DataFile objects
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.data.model.DataFile
%"""

classdef DataFileSet < biotracs.core.mvc.model.ResourceSet
    
    properties(Constant)
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        %> @param[in] iRepository [string, default = ''] Repository of the file
        function this = DataFileSet( varargin )
            this@biotracs.core.mvc.model.ResourceSet( varargin{:} );
            this.classNameOfElements = {'biotracs.data.model.DataFile'};
        end

        %-- C --
        
        %-- E --
        
        function tf = exist( this )
            n = getLength(this);
            tf = false(1,n);
            for i=1:n
                tf(i) = this.getAt(i).exist();
            end
        end
        
        %-- I --

        function tf = arefiles( this )
            n = getLength(this);
            tf = false(1,n);
            for i=1:n
                tf(i) = this.getAt(i).isfile();
            end
        end
        
        function tf = arefolders( this )
            n = getLength(this);
            tf = false(1,n);
            for i=1:n
                tf(i) = this.getAt(i).isfolder();
            end
        end
        
        %-- G --
        
        function filePaths = getFilePaths( this )
            n = getLength(this);
            filePaths = cell(1,n);
            for i=1:n
                filePaths{i} = this.getAt(i).getPath();
            end
        end
    end
    
end

