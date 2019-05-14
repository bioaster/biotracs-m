%"""
%biotracs.core.mvc.controller.Controller
%Defines the Controller object. A controller is associated with a single working session.
%* License: BIOASTER License
%* Created by: Bioinformatics team, Omics Hub, BIOASTER Technology Research Institute (http://www.bioaster.org), 2014
%* See: biotracs.core.mvc.model.Session, biotracs.core.mvc.view.View
%"""

classdef Controller < biotracs.core.ability.Parametrable
    
    properties(Access = protected)
        %nodes;
        session;
    end
    
    methods
        
        function this = Controller()
            this@biotracs.core.ability.Parametrable();
            this.session = biotracs.core.mvc.model.Session(0, 'biotracs.core.mvc.model.BaseObject');
            this.createParam('WorkingDirectory', '', 'Constraint', biotracs.core.constraint.IsText());
        end

        %-- A --
        
        function [this, iName] = add( this, iElement, iName )
            [this, iName] = this.session.add( iElement, iName );
        end
        
        function [this, iName] = addNode( this, varargin )
            warning('Deprecated method. Please use add() instead of addNode().');
            [this, iName] = this.add(varargin{:});
        end
        
        %-- G --
        
        function [ node ] = get( this, iName )
            if ~this.session.hasElement(iName)
                names = strjoin(this.session.getElementNames(),''',''');
                error('BIOTRACS:Controller:ElementNotFound', 'No element found with name ''%s''. Valid names are {''%s''}.', iName, names);
            end
            node = this.session.get( iName );
        end
        
        function [ node ] = getNode( this, iName )
            warning('Deprecated method. Please use get() instead of get().');
            node = this.get(iName);
        end
        %--H--
        function [ tf ] = hasElement(this, iName) 
         tf = this.nodes.hasElement(iName);
        end
        %-- R -- 
        
        function this = run( this, iName )
            node = this.get(iName);
            if isa( node, 'biotracs.core.ability.Runnable')
                if this.isParamValueEmpty('WorkingDirectory')
                    error('No working directory found');
                end
                wd = this.getParamValue('WorkingDirectory');
                node.getConfig().updateParamValue( 'WorkingDirectory', [wd, '/', iName] );
                node.run();
            else
                error('BIOTRACS:Controller:ElementMustBeRunnable', 'Element %s is not an instance of biotracs.core.ability.Runnable', iName);
            end
        end
        
        function this = runNode( this, varargin )
            warning('Deprecated method. Please use runProcess() instead of runNode().');
            this.runProcess( varargin{:} );
        end
        
        %-- S --
        
        function this = summary( this )
            disp('Summary of nodes:');
            this.session.summary();
        end
        
        %-- V --
        
        function h = view( this, iNodeName, iViewFunctionName, varargin )
            node = this.get(iNodeName);
            h = feval('view', node, iViewFunctionName, varargin{:} );
        end
        
    end
    
    methods(Access = protected)

    end
    
end

