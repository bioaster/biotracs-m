%"""
%biotracs.dataproc.model.DataMerger
%DataMerger process allows merging several DataTable in a single DataTable vertically or horizontally. Row/column names are checked before merging and only rows/columns with identical names are merged together. An error is thrown if their a row/column of a DataTable does not match with any row/column in the other DataTable objects. If the merge is forced, no error is thrown in case of unmatch, but the unmatched rows/columns are discarded before merge.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.dataproc.model.DataMergerConfig
%"""

classdef DataMerger < biotracs.core.mvc.model.Process
    
    properties(Constant)
    end
    
    properties(Dependent)
    end
    
    events
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = DataMerger()
            this@biotracs.core.mvc.model.Process();
            
            % define input and output specs
            this.addInputSpecs({...
                struct(...
                'name', 'DataTable',...
                'class', {{'biotracs.data.model.DataTable','biotracs.core.mvc.model.ResourceSet'}}, ...
                'multiplicity', 1 ...
                )...
                });
            % define input and output specs
            this.addOutputSpecs({...
                struct(...
                'name', 'DataTable',...
                'class', 'biotracs.data.model.DataTable' ...
                )...
                });
            this.input.setIsResizable(true);
        end
        
    end
    
    % -------------------------------------------------------
    % Private methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
        function doBeforeRun( this )
            this.doBeforeRun@biotracs.core.mvc.model.Process();
            if this.input.getLength() == 1
                data = this.input.getPortAt(1).getData();
                this.setIsPhantom( isa(data, 'biotracs.data.model.DataTable') );
            end
        end
        
        function doRun( this )
            data = this.input.getPortAt(1).getData();
            if ~isa(data, 'biotracs.data.model.DataTable')
                list = data.getElements();
            else
                n = this.input.getLength();
                list = cell(1,n);
                for i=1:n
                    list{i} = this.input.getPortAt(i).getData();
                end
            end

            if strcmp(this.config.getParamValue('Direction'), 'row')
                mergedData = horzmerge( list{:}, 'Force', this.config().getParamValue('Force') );
            else
                mergedData = vertmerge( list{:}, 'Force', this.config().getParamValue('Force') );
            end

            this.setOutputPortData('DataTable', mergedData);
        end
        
    end
end
