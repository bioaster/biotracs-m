%"""
%biotracs.core.mvc.view.Report
%Report view object
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2015
%* See: biotracs.core.mvc.model.Report
%"""

classdef Report < biotracs.core.mvc.view.BaseObject

    properties(SetAccess = protected)
    end
    
    methods

        function this = Report()
            this@biotracs.core.mvc.view.BaseObject();          
        end

    end
    
    methods(Access = protected)
        
%         % Overload this method to generate a custom html
%         function html = doGenerateHtml( this )
%             report = this.getModel();
%             
%             domElement = biotracs.core.html.HtmlElement();
%             domElement.setInnerHtml( report.htmlContent );
%             domElement.generateHtml();
%             html = domElement.docHtml;
%         end
        
    end
    
end

