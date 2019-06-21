%"""
%biotracs.core.constraint.IsPath
%Constraint that checks if a Parameter value is a text corresponding to a valid
%file path (alias of `biotracs.core.constraint.IsOutputPath` constraint)
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2017
%* See: biotracs.core.constraint.IsInputPath, biotracs.core.constraint.IsOutputPath, biotracs.core.constraint.Text, biotracs.core.mvc.Parameter
%"""

classdef IsPath < biotracs.core.constraint.IsText
    
    properties(SetAccess = protected)
        pathMustExist = false;
        checkValidity = true;
        applyFilter = true;
    end
    
    methods

        function this = IsPath( varargin ) 
            this@biotracs.core.constraint.IsText( varargin{:} );
            p = inputParser();
            p.addParameter('PathMustExist', false, @islogical);
            p.addParameter('ApplyFilter', true, @islogical);
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            this.pathMustExist = p.Results.PathMustExist;
            this.applyFilter = p.Results.ApplyFilter;
        end
        
        function this = setPathMustExist( this, iValue )
            this.pathMustExist = iValue;
        end
        
        function this = setCheckValidity( this, iValue )
            this.checkValidity = iValue;
        end
        
        function this = setApplyFilter( this, iValue )
            this.applyFilter = iValue;
        end
        
        function value = filter(this, value)
            if ~this.applyFilter
                return;
            end

            value = strrep(value, '?home?', biotracs.core.env.Env.workingDir());  %@DEPRACATED
            value = strrep(value, '%WORKING_DIR%', biotracs.core.env.Env.workingDir());
            value = strrep(value, '%USER_DIR%', biotracs.core.env.Env.userDir());

            vars = biotracs.core.env.Env.vars();
            names = fieldnames(vars);
            for i=1:length(names)
                value = strrep(value, ['%', upper(names{i}),'%'], vars.(names{i}));
            end
            
            value = fullfile(value);
        end
        
    end
    
    methods(Access = protected)
        
        function tf = doIsValidElement(this, iValue)
            if ~this.doIsValidElement@biotracs.core.constraint.IsText(iValue)
                tf = false;
                return; 
            end
            
            if ~this.checkValidity, tf = true; return; end
            
            iValue = fullfile(iValue);
            if this.pathMustExist
                tf = isfile(iValue) || isfolder(iValue);
            else
                tf = true;
                iValue = strrep(iValue, '/', '\');
                tab = strsplit(iValue, '\');
                for i=1:length(tab)
                    if isempty(tab{i}), continue; end
                    if i==1
                        tf = regexp( tab{i}, '^(([a-zA-Z]:)|[^:\*\?\|\\/"<>]*)$', 'once' );
                    else
                        tf = regexp( tab{i}, '^([^:\*\?\|\\/"<>]*)$', 'once' );
                    end
                    tf = ~isempty(tf);
                    if ~tf, break; end
                end
            end
        end
        
    end
    
end

