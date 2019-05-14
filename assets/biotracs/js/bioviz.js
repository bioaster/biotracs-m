/** 
 * @file 		bioviz.js
 * @link		http://www.bioaster.org
 * @license		Bioaster
 * @author		D. A. Ouattara
 * @date		04 Sep 2015
 * @brief	    Bioaster Technology Research Institute (http://www.bioaster.org)
 */
 
!function() {
    'use strict';
	var bioviz = {
		version: "0.1",
		
		// File loader
		readXmlFile		: null,
		readSbmlFile	: null,
		readBiopaxFile	: null,
		
		// Plots & Graphs visualisation
		Plot			: null,
		Pathway			: null,
		
		// Resources & Data
		BaseData		: null,
		Sbml2			: null,
		Biopax			: null,
		
		// Collectors
		plotList		: [],
		pathwayList		: [],
        
        // Utility library
        numeric         : {},
        array           : {}
	};
    
	window.bioviz = bioviz;
}();


/** **************************************************************************
 * 
 * Pathway class
 *
 ***************************************************************************** */
 
(function() {
	'use strict';
    
	/**
	 * @class bioviz.Pathway 
	 * @param divId [string] Id of the <div> used as container
	 *
	 */	 
	bioviz.Pathway = function( divId ){
		var self = this;
		
		if( divId == undefined ){
			throw "No container found. It is recommended to use a div as container.";
		}
	
	/**
	 * > Attributes
	 * --------------------------------------------------------------------------
	 */	
		this.data	= null;	

		var canevas = document.getElementById(divId);	
		if( canevas == null ){
			throw "No container found. It is recommended to use a div as container.";
		}
		
		this.width 		= canevas.offsetWidth - 5;
		this.height 	= canevas.offsetHeight - 5;
		this.canevas 	= canevas;
		
		if( this.width <= 0 || this.height <= 0 ){
			throw "Cannot determine the width or height of the container";
		}
		
		this.svg = d3.select( canevas )
				.append("svg")
				.attr("width", this.width)
				.attr("height", this.height);
				
		
		this.force = d3.layout.force()
				.charge(-250)
				.linkDistance(50)
				.linkStrength(0.9)
				.friction(0.8)
				.size([this.width, this.height]);
		
		//styles
        //this.nodeSize 				= 8;
		//this.linkColor 				= "#ccc";
		//this.highlightedStrokeColor   = "blue";
		//this.strokeWidth			    = 1;
		//this.highlightedStrokeWidth   = 2;
        //this.defaultOpacity           = 1;
        //this.fadeOpacity              = 0.4;
		
        self.nodeColor = function(){ return "orange" };
        
        this.css = {
            'node-size'                 : 8,
            'link-color'                : '#aaa', //'#555',
            'highlighted-stroke-color'  : 'blue',
            'stroke-width'              : 1,
            'highlighted-stroke-width'  : 2,
            'default-opacity'           : 1,
            'fade-opacity'              : 0.4,
            'stroke-color'              : '#555',
            'leaf-stroke-color'         : '#fff',
        };
        
		//Zoom
		var zoom = d3.behavior.zoom().scaleExtent([0.3, 5]);
		
	/**
	 * > Public Methods
	 * --------------------------------------------------------------------------
	 */	
	
		/**
		 * View the pathway
		 * @param The url of the file 
		 * @param Type of data to view  'json' || 'sbml' || 'biopax'
		 * 
		 */
		this.view = function( url, dataType ){
			if( dataType == "json" || dataType == undefined ){
				bioviz.readJsonFile( url, self.m_viewGraph );
			} else if( dataType == "sbml" ){
				bioviz.readXmlFile( url, self.m_viewSbml2 );
			} else if( dataType == "biopax" ){
				bioviz.readBiopaxFile( url, self.m_viewBiopax );
			}
		}

		this.viewJsonGraph = function( jsonData ){
			self.m_viewGraph(false, jsonData);
		}
		
	/**
	 * > Private Methods
	 * --------------------------------------------------------------------------
	 */
		
		this.m_initSvgZoomEvent = function(){
			zoom.on("zoom", function(){
				self.svg.attr("transform", "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
			});
			self.svg.call(zoom);
		}
			
		this.m_viewGraph = function( error, jsonGraph ){
			if (error){ throw "Cannot load JSON data"; }
			//console.log(jsonGraph)
			var data = new bioviz.BaseData(jsonGraph);
			self.m_viewBaseData(false, data);
		}
		
		this.m_viewSbml2 = function( error, jsonSbml ){
			if (error){ throw "Cannot load SBML data"; }
			var data = new bioviz.Sbml2(jsonSbml);
			self.m_viewBaseData(false, data);
		}
		
		this.m_viewBiopax = function( error, jsonBiopax ){
			throw "Not yet available";
		}
			
		/**
		 * View json data
		 * @function _renderBaseData
		 * @used by @a view
		 */
		this.m_viewBaseData = function( error, baseData ) {			
			if (error){ throw error; }
            if (self.force) self.force.stop();
            
			if( self.data == null) self.data= baseData;
			var graph = self.data.getGraph();
			            
            if( graph.autocolor ){
                self.nodeColor = d3.scale.category20();
            };
            
			self.force.nodes(graph.nodes)
				.links(graph.links)
				.start();
			
			var links = self.svg.selectAll(".link")
				.data(graph.links)
				.enter().append("line")
				.attr("class", "link")
				.style("stroke-width", function(d) { return Math.sqrt(d.value); })
                .style("stroke-opacity", self.css["default-opacity"])
				.style("stroke", self.css["link-color"]);
            
            /*
            //build arrows
            self.svg.append("defs").selectAll("marker")
                .data(["end"])
                .enter().append("svg:marker")
                .attr("id", String)
                .attr("viewBox", "0 -5 10 10")
                .attr("refX", 15)
                .attr("refY", -1.5)
                .attr("markerWidth", 6)
                .attr("markerHeight", 6)
                .attr("orient", "auto")
                .append("path")
                .attr("d", "M0,-5L10,0L0,5");

            var links = self.svg.append("g").selectAll("path")
                            .data(graph.links)
                            .enter().append("path")
                            .attr("class", function(d) { return "link" })
                            .attr("marker-end", "url(#end)");
            */
            
			var nodes = self.svg.selectAll(".node")
				.data(graph.nodes)
				.enter().append("g")
				.attr("class", "node")
				.call(self.force.drag());
			
			nodes.on("mouseover", function(d) {
					setHighlightNode(d);
				}).on("mouseout", function(d) {
					resetHighlightNeighbors(d);
                }).on("mousedown", function(d) { 
					d3.event.stopPropagation();
                    setHighlightNeighbors(d);
					setFade(d);
				}).on("mouseup",  function() {
                    resetFade();
				}).on("click", function(d){
                    d3.event.stopPropagation();
					d3.select(this).classed("fixed", d.fixed = !d.fixed);
				}).on("dblclick.zoom", function(d) { 
                    d3.event.stopPropagation();
                    centerOnNode(d);
                });
            
            nodes.append("path")
                .attr("d", d3.svg.symbol()
                            .type(function(d) { return d.type || "circle"; })
                            .size(function(d) { return Math.PI*Math.pow(d.size || self.css["node-size"], 2) }))
                .attr("class", "node")
                .style("fill", function(d) { return d.color || self.nodeColor(d.group); })
				.style("fill-opacity", self.css["default-opacity"])
				.style("stroke", function(d) { return d.color || self.nodeColor(d.group); })
				.style("stroke-width", self.css["stroke-width"])
                .style("stroke-opacity", self.css["default-opacity"])
            
			nodes.append("text")
				.attr("dx", 12)
				.attr("dy", ".35em")
				.text(function(d) { return d.name; });
			
            //------------------------------------------
            
            
			self.force.on("tick", function(e) {
                /*links.attr("d", function(d) {
                    var dx = d.target.x - d.source.x,
                        dy = d.target.y - d.source.y,
                        dr = Math.sqrt(dx * dx + dy * dy);
                    return "M" + 
                            d.source.x + "," + 
                            d.source.y + "A" + 
                            dr + "," + dr + " 0 0,1 " + 
                            d.target.x + "," + 
                            d.target.y;
                });*/
                
                links.attr("x1", function(d) { return d.source.x; })
					.attr("y1", function(d) { return d.source.y; })
					.attr("x2", function(d) { return d.target.x; })
					.attr("y2", function(d) { return d.target.y; });
                
				nodes.attr("cx", function(d) { return d.x; })
					.attr("cy", function(d) { return d.y; });
					
				nodes.attr("transform", function(d) { return "translate(" + d.x + "," + d.y + ")"; });
			});	

			self.m_initSvgZoomEvent();


			function keydown() {
				if (d3.event.keyCode==32) {  
					force.stop(); 
				} else if (d3.event.keyCode >= 48 && d3.event.keyCode<=90 && !d3.event.ctrlKey && !d3.event.altKey && !d3.event.metaKey) {
					switch (String.fromCharCode(d3.event.keyCode)) {
						case "C": keyc = !keyc; break;
						case "S": keys = !keys; break;
						case "T": keyt = !keyt; break;
						case "R": keyr = !keyr; break;
						case "X": keyx = !keyx; break;
						case "D": keyd = !keyd; break;
						case "L": keyl = !keyl; break;
						case "M": keym = !keym; break;
						case "H": keyh = !keyh; break;
						case "1": key1 = !key1; break;
						case "2": key2 = !key2; break;
						case "3": key3 = !key3; break;
						case "0": key0 = !key0; break;
					}
					links.style("display", function(d) {
					});

					nodes.style("display", function(d) {
					});

				}	
			}
            
            function centerOnNode(d){
                var dcx = (self.width/2-d.x*zoom.scale());
                var dcy = (self.height/2-d.y*zoom.scale());
                zoom.translate([dcx,dcy]);
                self.svg.attr("transform", "translate("+ dcx + "," + dcy  + ")scale(" + zoom.scale() + ")");
            }
            
			//Highlighting
            function setHighlightNode(d){
                nodes.select("path")
                    .style("stroke", function(o) {
                        return o.index == d.index ? self.css["highlighted-stroke-color"] : ( o.color || self.nodeColor(o.group) );
                    }).style("stroke-width", function(o) {
                        return o.index == d.index ? self.css["highlighted-stroke-width"] : self.css["stroke-width"];
                    });
            }
            
			function setHighlightNeighbors(d){
                nodes.select("path")
                    .style("stroke", function(o) {
                        return self.data.areNodesNeighbors(d, o) || d.index == o.index ? self.css["highlighted-stroke-color"] : ( o.color || self.nodeColor(o.group) );
                    }).style("stroke-width", function(o) {
                        return self.data.areNodesNeighbors(d, o) || d.index == o.index ? self.css["highlighted-stroke-width"] : self.css["stroke-width"];
                    });
                
                links.style("stroke", function(o) { 
                        return  self.data.areNodeAndLinkConnected(d, o) || d.index == o.index ? self.css["highlighted-stroke-color"] : self.css["link-color"]; 
                    });
			}
            
            function resetHighlightNeighbors(d){
                nodes.select("path")
					.style("stroke", function(o) { return o.color || self.nodeColor(o.group) })
                    .style("stroke-width", self.css["stroke-width"]);
				
				links.style("stroke",  self.css["link-color"]);
			}
            
			function setFade(d){
                nodes.select("path")
					.style("opacity", function(o) {
						return self.data.areNodesNeighbors(d, o) || d.index == o.index ? self.css["default-opacity"] : self.css["fade-opacity"];
					})
                    .style("stroke-opacity", function(o) {
						return self.data.areNodesNeighbors(d, o) || d.index == o.index ? self.css["default-opacity"] : self.css["fade-opacity"];
					});
                
                links.style("opacity", function(o) { 
						return  self.data.areNodeAndLinkConnected(d, o) || d.index == o.index ? 1 : self.css["fade-opacity"]; 
					});
			}
            
            function resetFade(){
                nodes.select("path")
					.style("opacity", self.css["default-opacity"])
                    .style("stroke-opacity", self.css["default-opacity"]);
                
                links.style("opacity", self.css["default-opacity"]);
			}
		}
		
		
		bioviz.pathwayList.push(self);
	}	
})( bioviz, $ );



	
/** **************************************************************************
 * 
 * Asynchronous File readers (Static Methods)
 *
 ***************************************************************************** */
(function() {
	
	/**
	 * Read xml file
	 */
	bioviz.readXmlFile = function( url, callback ){
		xmljson.read( url, function( error, xmlStr ){ 
			if( error ) throw error;
			jsonStr = xmljson.toJsonString( xmlStr );
			callback( error, JSON.parse(jsonStr) )
		});
	}
	
	/**
	 * Read SBML file
	 */
	bioviz.readSbmlFile = function( url, callback ){
		bioviz.readXmlFile( url, callback );
	}
	
	/**
	 * Read BioPAX file
	 */
	bioviz.readBiopaxFile = function( url, callback ){
		bioviz.readXmlFile( url, callback );
	}
	
	/**
	 * Read json file
	 */
	bioviz.readJsonFile = function( url, callback ){
		d3.json(url, callback);
	}
})( bioviz );


/** **************************************************************************
 * 
 * Data definition 
 *
 ***************************************************************************** */
 
(function() {
	'use strict';
    
	/**
	 * @class Node
	 * @param inner data [JSON object]
	 */
	bioviz.Node = function( node ){
		this.data = node;
	}
	
	/**
	 * @class Link
	 * @param inner data [JSON object]
	 */
	bioviz.Link = function( link ){
		this.data = link;
	}
	
	/**
	 * @class BaseData
	 * @param inner data [JSON object]
	 */
	bioviz.BaseData = function( data ){
        /** D3js node type
        circle - a circle.
        cross - a Greek cross or plus sign.
        diamond - a rhombus.
        square - an axis-aligned square.
        triangle-down - a downward-pointing equilateral triangle.
        triangle-up - an upward-pointing equilateral triangle
        */
        
		this.graph = null;
		//this.neighboringLevel = 1;

		var adjMatrix = null;
		
		if( data != undefined ){
			this.graph = data;
            if( this.graph.autocolor == null ){
                this.graph.autocolor    = true;
            };
		}
		
        //-- A --
		
		/**
		 * Check that two basic node A and B are neighbors
		 * @param Node A [d3js node object]
		 * @param Node B [d3js node object]
		 */
        this.areNodesNeighbors = function ( nodeA, nodeB ){   // d3Node objects
			//if( nodeA.index ==  nodeB.index )  return true;
			
			adjMatrix = this.getAdjMatrix();
            return ( adjMatrix[ nodeA.index ][ nodeB.index ] ) 
						|| ( adjMatrix[ nodeB.index ][ nodeA.index ] );

			/*if( this.neighboringLevel == 1 ){
				return ( adjMatrix[ nodeA.index ][ nodeB.index ] ) 
						|| ( adjMatrix[ nodeB.index ][ nodeA.index ] );
			} 
            else {
				var currentNodeVector =  this.nodeVector( nodeA );
				
				//next step
				var walkMatrix = bioviz.numeric.exponent( adjMatrix, this.neighboringLevel );
				var nextNodeVector = numeric.mul( walkMatrix, currentNodeVector );
				//console.log(nextNodeVector);
				
				if( nextNodeVector[nodeB.index] == [1] ){ return true; }
				
				//previous step
				var walkMatrix = bioviz.numeric.exponent( numeric.transpose(adjMatrix), this.neighboringLevel );
				var prevNodeVector = numeric.mul( walkMatrix, currentNodeVector );
				return prevNodeVector[nodeB.index] == [1]
				
			}*/
		}
		
		/**
		 * Check that a basic node and a link are connected
		 * @param Node [d3js node object]
		 * @param Link [d3js link object]
		 */
		this.areNodeAndLinkConnected = function( node, link ){  // d3Node & d3Link objects
			return ( link.source.index == node.index 
					|| link.target.index == node.index );		
		}
        
		/**
		 * Check that tow actors A and B link are connected
		 * An actor may be a basic node or specific nodes (tagged as actors for exemple) depending on the application domain
		 * @param Node actor A [d3js node object]
		 * @param Link actor B [d3js link object]
		 */
		this.areActorsConnected = function( nodeActorA, nodeActorB ){  // d3Node objects
			return this.areNodesNeighbors(nodeActorA, nodeActorB);	
		}
		
		//-- G --
		
		this.getNodes = function(){
			return this.graph.nodes;
		}
		
		this.getLinks = function(){
			return this.graph.links;
		}
		
		this.getType = function(){
			return this.graph.type;
		}
		
		this.getData = function(){
			return this.graph
		}
		
		this.getGraph = function(){
			return this.graph;	
		}
		
		this.getAdjMatrix = function(){
			if( adjMatrix != null ) return adjMatrix;
			adjMatrix = bioviz.numeric.zeros( this.graph.nodes.length );
			for( var j=0; j<this.graph.links.length; j++){
				var link = this.graph.links[j];
				adjMatrix[ link.source.index ][ link.target.index ] = 1;
			}
			return adjMatrix;
		}
		
		this.getNbNodes = function(){
			var dim = numeric.dim( this.getAdjMatrix() );
			return dim[0];
		}
		
		//-- I --
		
		//-- N --
		
		this.nodeVector = function( node ){
			var n = this.getNbNodes();
			var v = numeric.rep([n, 1],0);
			v[ node.index ] = [1];
			return v
		}

		//-- S --
		
		this.setData = function( data ){
			this.graph = data
			return this;
		}
	}
	
	/**
	 * @class Sbml2
	 * @param inner data [JSON object]
	 */
	
	bioviz.Sbml2 = function( data ){	
		this.level = 2;
		this.data = data;
        
        //-- A --
        
		// Overload
        this.areActorsConnected = function( nodeActorA, nodeActorB ){  // d3Node objects
			if( this.isReaction( nodeActorA ) || this.isReaction( nodeActorB ) ){
				return false;
			}
			
			adjMatrix = this.getAdjMatrix();
            if( this.areNodesNeighbors( nodeActorA, nodeActorB ) ){
                return true;       
            } else{
                
            }
			/*return ( adjMatrix[ nodeA.index ][ nodeB.index ] ) 
					|| ( adjMatrix[ nodeB.index ][ nodeA.index ] );
			*/		
		}
        

		this.areSpeciesAndReactionConnected = function( speciesNode, reactionNode ){  // d3Node objects
			return this.areNodesNeighbors(speciesNode, reactionNode);	
		}
		
        //-- G --
        
		this.getListOfReactions = function(){
			return this.data.sbml.model.listOfReactions;
		}

		this.getData = function(){
			return this.data
		}
        
		//-- I --
		
		/**
		 * Check if a node is a molecular species
		 * @param Node [d3js node object]
		 * @return true or false [logical]
		 */
		this.isSpecies = function( node ){
			return node["isa"] != "reaction";
			
		}
		
		/**
		 * Check if a node is a reaction
		 * @param Node [d3js node graph object]
		 * @return true or false [logical]
		 */
		this.isReaction = function( node ){
			return node["isa"] == "reaction";
			
		}
		
        //-- S --
        
        this.setData = function( dara ){
			this.data = data
            this.m_parseSbmlTree();
			return this;
		}
    
    /**
	 * > Public Methods
	 * --------------------------------------------------------------------------
	 */	
     
		//-- P --
        
		this.m_parseSbmlTree = function(){
			var nodeIndexes         = {}
			var currentNodeIndex 	= 0;
			
            this.graph              = {};
			this.graph.nodes		= [];
			this.graph.links 		= [];
            this.graph.autocolor    = false;
			
            var listOfReactions = bioviz.array.toArray(this.data.sbml.model.listOfReactions.reaction);    
                
			for( var i=0; i<listOfReactions.length; i++) {
				var reaction = listOfReactions[i];
				
                /*var ok = false;
                if( reaction['@id'] == "re6" ){
                    ok = true;
                }*/
            
				if( nodeIndexes[ reaction['@id'] ] == null ){
					nodeIndexes[ reaction['@id'] ] = currentNodeIndex;
					this.graph.nodes[ currentNodeIndex ] = {
						"id"		: reaction['@id'],
						"name"		: reaction['@id'],
						"long_name"	: reaction['@name'],
						"sbo_term"	: reaction['@sboTerm'],
                        "type"      : "square",
                        "color"     : "#aaa",
                        "size"      : 5,
						"group"		: 1,
						"isa"		: "reaction"
					}
					currentNodeIndex++;
				}
                
                /*if( ok ){
                    console.log("reaction");
                    console.log( this.graph.nodes[currentNodeIndex-1] );
                    console.log( reaction );
                }*/
                
				//Links from Reactants => ReactionNode
                var listOfReactants = bioviz.array.toArray(reaction.listOfReactants.speciesReference);
				for( var j = 0; j < listOfReactants.length; j++ ){
					var speciesReference = listOfReactants[j];
					
					var reactantAlias = speciesReference.annotation['celldesigner:extension']['celldesigner:alias'];
					if( nodeIndexes[ reactantAlias ] == null ){
						nodeIndexes[ reactantAlias ] = currentNodeIndex;
						this.graph.nodes[ currentNodeIndex ] = {
							"id"		: speciesReference['@metaid'],
							"name"		: speciesReference['@species'],
							"alias"		: reactantAlias,
							"group"		: 1
						}
						currentNodeIndex++;
					};
					
					this.graph.links.push({
						"source"		: nodeIndexes[ reactantAlias ],
						"target"		: nodeIndexes[ reaction['@id'] ],
						"side"			: "left",
						"value"			: 1
					});
                    
                    /*if( ok ){
                    console.log("product node");
                    console.log( this.graph.nodes[ nodeIndexes[ reactantAlias ] ] );
                    console.log("link");
                    console.log( this.graph.links[this.graph.links.length-1] );
                    }*/
				}
				
				//Links from ReactionNode to Products
                var listOfProducts = bioviz.array.toArray(reaction.listOfProducts.speciesReference);
				for( var j = 0; j < listOfProducts.length; j++ ){
					var speciesReference = listOfProducts[j];
					
					var productAlias = speciesReference.annotation['celldesigner:extension']['celldesigner:alias'];
					if( nodeIndexes[ productAlias ] == null ){
						nodeIndexes[ productAlias ] = currentNodeIndex;
						this.graph.nodes[ currentNodeIndex ] = {
							"id"		: speciesReference['@metaid'],
							"name"		: speciesReference['@species'],
							"alias"		: productAlias,
							"group"		: 1
						}
						currentNodeIndex++;
					}
	
					this.graph.links.push({
						"source"		: nodeIndexes[ reaction['@id'] ],
						"target"		: nodeIndexes[ productAlias ],
						"side"			:"right",
						"value"			: 1
					});
                    
                    /*if( ok ){
                    console.log("reactant node");
                    console.log( this.graph.nodes[ nodeIndexes[ productAlias ] ] );
                    console.log("link");
                    console.log( this.graph.links[this.graph.links.length-1] );
                    }*/
				}
				
				//Link from Modifiers (Enzyme) to ReactionNode
                var listOfModifiers = bioviz.array.toArray(reaction.listOfModifiers.modifierSpeciesReference);
				for( var j = 0; j < listOfModifiers.length; j++ ){
					var modifierSpeciesReference = listOfModifiers[j];
                    
					var modifierAlias = modifierSpeciesReference.annotation['celldesigner:extension']['celldesigner:alias'];										
					if( nodeIndexes[ modifierAlias ] == null ){
						nodeIndexes[ modifierAlias ] = currentNodeIndex;
						this.graph.nodes[ currentNodeIndex ] = {
							"id"		: modifierSpeciesReference['@metaid'],
							"name"		: modifierSpeciesReference['@species'],
							"alias"		: modifierAlias,
                            "type"      : "triangle-up",
                            "size"      : 4,
							"group"		: 1,
						}
						currentNodeIndex++;
					}
					
					this.graph.links.push({
						"source"		: nodeIndexes[ modifierAlias ],
						"target"		: nodeIndexes[ reaction['@id'] ],
						"side"			:"middle",
						"value"			: 1,
					});
                    
                    /*if( ok ){
                    console.log("modifier node");
                    console.log( this.graph.nodes[nodeIndexes[ modifierAlias ]] );
                    console.log("link");
                    console.log( this.graph.links[this.graph.links.length-1] );
                    }*/
				}
			}
		}
        

        //parse graph
        this.m_parseSbmlTree();
		
	}
	bioviz.Sbml2.prototype = new bioviz.BaseData();		//Inherits from prototype of bioviz.BaseData
	
	/**
	 * @class Biopax
	 * @param inner data [JSON object]
	 */
	bioviz.Biopax = function( data ){	
		this.data = data;
	}
	bioviz.Biopax.prototype = new bioviz.BaseData();
	
    
    /**
	 * @class Stochiometry matrix
	 * @param inner data [JSON object]
	 */
	bioviz.StochMatrix = function( data ){
        this.data = data;
        
        this.m_parseStochMatrix = function(){
            this.graph              = {};
			this.graph.nodes		= [];
			this.graph.links 		= [];
            this.graph.autocolor    = false;
            
            for(var i=0; i<this.data.links; i++){
            }
            
        }
        
        //parse graph
        this.m_parseStochMatrix();
    }
    bioviz.StochMatrix.prototype = new bioviz.BaseData();		//Inherits from prototype of bioviz.BaseData
    
})( bioviz );


/** **************************************************************************
 * 
 * onResize
 *
 ***************************************************************************** */
 
(function() {
    'use strict';
    
	window.onresize = function(){
		for( var i=0; i < bioviz.pathwayList.length; i++ ){
			var p = bioviz.pathwayList[i];
			var isContainerResized = false;
			if( p.width != p.canevas.offsetWidth - 5){
				p.width = p.canevas.offsetWidth - 5;
				isContainerResized = true;
			}
			
			if( p.height != p.canevas.offsetHeight - 5){
				p.height = p.canevas.offsetHeight - 5;
				isContainerResized = true;
			}
			
			if( isContainerResized ){
				p.svg.attr("width", p.width).attr("height", p.height);
				p.force.size([p.width , p.height]).start();
			}
		}
	}
})( bioviz );


/** **************************************************************************
 *  
 * Math (Utility functions)
 *
 ***************************************************************************** */

 
(function() {
    'use strict';
		
	bioviz.numeric.zeros = function( m, n ){
		if( n == undefined ){ n = m }
		return numeric.rep([m, n], 0);
	}
	
	bioviz.numeric.ones = function( m, n ){
		if( n == undefined ){ n = m }
		return numeric.rep([m, n], 1);
	}
	
	bioviz.numeric.exponent = function( A, n ){
		for( var i=1; i<=n; i++ ){
			A = numeric.mul(A,A);
		}
		return A;
	}
	
})( bioviz );

/** **************************************************************************
 *  
 * Math (Utility functions)
 *
 ***************************************************************************** */

 
(function() {
    'use strict';
    
	bioviz.array.toArray = function( obj ){
		if( obj instanceof Array ){
            return obj;
        } else {
            return [ obj ];
        };
	}
})( bioviz );