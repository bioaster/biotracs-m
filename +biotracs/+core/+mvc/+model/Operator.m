%"""
%biotracs.core.mvc.model.Operator
%Defines the operator object. An operator is a person how creates a BaseObject.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%* See: biotracs.core.mvc.model.BaseObject 
%"""

classdef Operator < handle
    
    properties(SetAccess = protected)
        id = 0;
        firstName = '';
        lastName = '';
        email = '';
        profession = ''; %{'bioinformatician','informatician','biologist','chemist','biochemist'};
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        %
        %> @fn this = Operator( iOperator )
        %
        %> @fn this = BaseObject( iFirstName, iLastName, iEmail, iProfession )
        %> @param[in] iFirstname [string, default = ''] 
        %> @param[in] iSurname [string, default = ''] 
        %> @param[in] iEmail [string, default = ''] 
        %> @param[in] iProfession [Cell of string] Type of operator in {'biochemist','bioinfo','biologist'}
        function this = Operator( iFirstName, iLastName, iEmail, iProfession )
            this@handle();
            
            if nargin >= 2 && isa(iFirstName, 'char')
                this.firstName = iFirstName;
            end
            if nargin >= 3 && isa(iLastName, 'char')
                this.lastName = iLastName;
            end
            if nargin >= 4 && isa(iEmail, 'char')
                this.email = iEmail;
            end
            if nargin >= 4 && isa(iProfession, 'cell')
                this.profession = iProfession;
            end
        end

    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
    end
    
    methods(Static)

    end
end

