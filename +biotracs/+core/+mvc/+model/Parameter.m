%"""
%biotracs.core.mvc.model.Parameter
%Defines the parameter object. A parameter is associated to several metadata (`name`, `value`, `description`, `unit`, ...). Parametrable objects are composed of several Parameter objects. 
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2016
%* See: biotracs.core.ability.Parametrable 
%"""

classdef Parameter < biotracs.core.ability.Copyable & biotracs.core.ability.PropListable

    properties (Constant)
        PUBLIC_ACCESS = 'public';
        PROTECTED_ACCESS = 'protected';
        PRIVATE_ACCESS = 'private';
        DEFAULT_ACCESS = biotracs.core.mvc.model.Parameter.PUBLIC_ACCESS;
    end
    
    properties (SetAccess = protected)
        
        % 1) Controlled vocabulary Parameter data
        
        % @ToDo:
        % Role Ontology ID
        % Ontology ID of the role of the parameter
        % E.g. interval (bounds), threshold, convergence limit, ...
        % correlation, ...
        roid = 0;   % 0 for undefined
        
        % @ToDo: 
        % Unit Ontology ID
        % Ontology ID of the International System of Unit (SI) of the parameter
        % Only based on kg, s, m, K, A, mol, cd units
        % See http://www.qudt.org/ (Quantity Ontology)
        % See http://en.wikipedia.org/wiki/International_System_of_Units
        % See http://www.semantic-web-journal.net/sites/default/files/swj177_7.pdf
        % This allows rigorous dimension checking in the model
        uoid = 0;   % 0 for undefined
        
        % 2) Uncontrolled vocabulary
        
        name;
        value;
        description;
        unit = '';   
        isHydratable = true;
        access = biotracs.core.mvc.model.Parameter.DEFAULT_ACCESS;
        isLocked = false;
        preUpdate;
        constraint;
    end
    
    methods
        
        function this = Parameter( iName, iValue, varargin )
            this@biotracs.core.ability.Copyable();
            this@biotracs.core.ability.PropListable();
            
            if nargin >= 1
                this.setName( iName );
            end
            
            if nargin >=2
                this.setValue( iValue );
            end
            
            p = inputParser();
            p.addParameter('IsHydratable', true, @islogical);
            p.addParameter('Constraint',[],@(x)(isequal(x,[]) || isa(x, 'biotracs.core.constraint.Constraint')));
            p.addParameter('PreUpdate',[],@(x)(isa(x, 'function_handle')));
            p.addParameter('Description','',@ischar);
            
            fun = @(x)(any(strcmp(x,{biotracs.core.mvc.model.Parameter.PUBLIC_ACCESS, biotracs.core.mvc.model.Parameter.PROTECTED_ACCESS, biotracs.core.mvc.model.Parameter.PRIVATE_ACCESS})));
            p.addParameter('Access', biotracs.core.mvc.model.Parameter.DEFAULT_ACCESS, fun );
            p.addParameter('Unit','',@ischar);
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            this.unit = p.Results.Unit;
            this.access = p.Results.Access;
            this.description = p.Results.Description;
            this.isHydratable = p.Results.IsHydratable;
            this.preUpdate = p.Results.PreUpdate;
            
            if ~isempty(p.Results.Constraint)
                if isa(p.Results.Constraint, 'biotracs.core.constraint.Constraint')
                    this.setConstraint( p.Results.Constraint );
                else
                    error('The constraint must be a ''biotracs.core.constraint.Constraint''');
                end
            end
        end
        
        %-- A --
        
        function tf = areConstraintsValidated( this )
            tf = true;
            if ~isempty(this.constraint)
                tf = this.constraint.isValid( this.value );
            end
        end
        
        %-- C --

        %-- G --
        
        function oUoid = getUoid( this )
            oUoid = this.uoid;
        end
        
        function oRoid = getRoid( this )
            oRoid = this.roid;
        end
        
        function oDescription = getDescription( this )
            oDescription = this.description;
        end
        
        function oName = getName( this )
            oName = this.name;
        end
        
        function oValue = getValue( this )
            oValue = this.value;
        end
        
        function oUnit = getUnit( this )
            oUnit = this.unit;
        end
        
        function oContraint = getConstraint( this )
            oContraint = this.constraint;
        end
        
        %-- I --
        
        function tf = isEqual( this, iParam, iStrict )
            if nargin >= 3 && iStrict
                tf = isequal(this, iParam);
            else
                tf = isequal(this.name,iParam.name) && isequal(this.value, iParam.value);
            end
        end
        
        % -- L --

        function this = setLock( this, iIsLock)
            this.isLocked = iIsLock;
        end
        
        % -- H --
        
        % Hydrate the parameter with another parameter
        % Hydration action is only possible if property isHydratable = true
        %> @param[in] iParam Parameter used for hydratation
        function this = hydrateWith( this, iParam )
            if this.isHydratable
                this.setValue(iParam.value);
                %this.value = iParam.value;
            else
                %disp( [ 'The parameter ''', iParam.name, ''' is not isHydratable' ] );
            end
        end
        
        function tf = isPublic( this )
            tf = strcmp( this.access, this.PUBLIC_ACCESS );
        end
        
        function tf = isProtected( this )
            tf = strcmp( this.access, this.PROTECTED_ACCESS );
        end
        
        function tf = isPrivate( this )
            tf = strcmp( this.access, this.PRIVATE_ACCESS );
        end
        
        % -- S --
        
        function this = setConstraint(this, iConstraint)
            if ~isa(iConstraint, 'biotracs.core.constraint.Constraint')
                error('Invalid constraint. A biotracs.core.constraint.Constraint is required');
            end
            this.constraint = iConstraint;
        end
        
        function this = setDescription( this, iDescription )
            if ~isa(iDescription, 'char')
                error('The description of the parameter must be a string');
            end
            this.description = iDescription;
        end
        
        function this = setUoid( this, iUoid )
            if ~isa(iUoid, 'char')
                error('The uoid of the parameter must be a string');
            end
            this.uoid = iUoid;
        end
        
        function this = setRoid( this, iRoid )
            if ~isa(iRoid, 'char')
                error('The roid of the parameter must be a string');
            end
            this.roid = iRoid;
        end
        
        function this = setName( this, iName )
            if ~isa(iName, 'char')
                error('The name of the parameter must be string');
            end
            this.name = iName;
        end
        
        % Set the value of the parameter
        %> @param[in] iValue Value
        function this = setValue( this, iValue )
            if this.isLocked
                error('BIOTRACS:Parameter:IsLocked', 'The value of the paramter cannot be altered. Please unlock the parameter before.');
            end
            
            if ~isempty(this.preUpdate) && isa(this.preUpdate, 'function_handle')
                iValue = this.preUpdate( iValue );
            end
            if ~isempty(this.constraint)
                iValue = this.constraint.filter(iValue);
                if ~this.constraint.isValid( iValue )
                    error('BIOTRACS:Parameter:InvalidArgument', 'Parameter ''%s'' must validate constraint %s.\nThe current value is %s\n', this.name, this.getConstraint().summary(), biotracs.core.utils.stringify(iValue));
                end
            end
            this.value = iValue;
        end
        
        function this = setUnit( this, iUnit )
            if ~isa(iUnit, 'char')
                error('The unit of the parameter must be a string');
            end
            this.unit = iUnit;
        end
        
        function this = setHydratable( this, iHydratable )
            this.isHydratable = iHydratable;
        end
        
        %-- U--
        
    end
    
    
    methods(Access = protected)
        
        function doCopy( this, iParameter, varargin )
            this.roid           = iParameter.roid;
            this.uoid           = iParameter.uoid;
            this.name           = iParameter.name;
            this.value          = iParameter.value;
            this.description    = iParameter.description;
            this.unit           = iParameter.unit;
            this.isHydratable   = iParameter.isHydratable;
            this.access         = iParameter.access;
            this.isLocked       = iParameter.isLocked;
            this.preUpdate      = iParameter.preUpdate;
            this.constraint     = iParameter.constraint;    %shallow copy
        end
        
    end
end

