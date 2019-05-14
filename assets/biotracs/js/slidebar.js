/** 
 * @file 		sliderbar.js
 * @link		http://www.bioaster.org
 * @license		Bioaster
 * @author		D. A. Ouattara (@source: form personal project)
 * @date		12 Sep 2017
 * @brief	    Bioaster Technology Research Institute (http://www.bioaster.org)
 */
 
+function ($){
	
	if( typeof window.cogito == "undefined" ){
		var cogito = {};
		window.cogito = cogito;
	} else{
		var cogito = window.cogito;
	}

	cogito.Slidebar = function( divId, options ){
		var that = this;
		if(typeof options == "undefined"){ options = {}; }

		this.uid				= (Math.random()+"").replace(/\./, "");
		this.container 			= document.getElementById(divId);
		this.cmap 				= (typeof options.cmap == 'undefined') ? null : options.cmap;
		this.toggler 			= (typeof options.toggler == 'undefined') ? null : options.toggler;
		this.url				= (typeof options.url == 'undefined') ? "" : options.url; 
		this.width 				= (typeof options.width == 'undefined') ?  Math.min($(window).width()-50, 350) : options.width;
		this.offsetTop 			= (typeof options.offsetTop == 'undefined') ? 0 : options.offsetTop;
		this.showOnReady		= (typeof options.showOnReady == 'undefined') ? false : options.showOnReady;
		this.isFreezed			= (typeof options.isFreezed == 'undefined') ? false : options.isFreezed;
		this.position			= (typeof options.position == 'undefined' || options.position != 'right' ) ? 'left' : options.position;
		
		this.isMouseOver 		= false;
		this.isVisible			= false;
		//-- F --
		
		this.freeze = function( iFreeze ){
			this.freezeState = (iFreeze == true);
		}

		//-- H --
		
		this.hide = function(){
			if(this.isFreezed) return;
			if(!this.isVisible) return;
			if(this.position == 'left'){
				$(that.container).css("left", "-"+this.width+"px");
			} else{
				$(that.container).css("left", $(window).width()+"px");
			}
			this.isVisible = false;
			return this;
		}
		
		//-- I --
		
		this.init = function() {
			if(that.url == ''){ 
				that.initCssAndSwipe();
				that.showOnReady || that.isFreezed ? that.show() : that.hide();
				if( typeof callback == 'function' ){
					callback();
				}
			} else{
				$.ajax({
					url: that.url,
				}).done(function( data ) {
						that.initCssAndSwipe();
						that.updateHtml(data);
						that.resize();
						that.showOnReady || that.isFreezed ? that.show() : that.hide();
						if( typeof callback == 'function' ){
							callback();
						}
					}).error(function( xhr, status, error ){
					var err = eval("(" + xhr.responseText + ")");
					console.log("Error while loading slidebar. " + err.Message);
				});
			}
			return this;
		}

		this.initCssAndSwipe = function(){
			$(that.container).addClass("slidebar")
							.addClass("animated-slidebar")
							.css({"top": that.offsetTop+"px"})
							.swipe({
								maxTimeThreshold: 1000,
								threshold: null,
								triggerOnTouchEnd: true,
								fingers: 'all',
								swipeLeft: function(){
									that.hide();
								},
								swipeRight: function(){
									that.show();
								}
							});
			
			this.hide();
			
			$(that.container).mouseover(function(){
				that.isMouseOver = true;
			})
			
			$(that.container).mouseout(function(){
				that.isMouseOver = false;
			})
			
			$(that.container).css({
				"top": that.offsetTop+"px", 
				"width": that.width+"px", 
				"left": (this.position == 'left' ? "-"+that.width : $(window).width()) +"px"
			});

			$(this.toggler).on("click",function( event ){
                event.stopPropagation();
				event.preventDefault();
				that.isVisible ? that.hide() : that.show();
			});
		}
		
		//-- R --
		
		this.show = function(){
			if(this.isVisible) return;
			if(this.position == 'left'){
				$(that.container).css("left", "0px");
			} else{
				$(that.container).css({"left" : ($(window).width() - this.width)+"px"});
			}
			this.isVisible = true;
			return this;
		}
		
		//-- S --
		
		this.resize = function(){
			$(that.container).removeClass("animated-slidebar");
			var h = $(window).height();
			$(this.container).height(h - this.offsetTop);
			if(this.position == 'right'){
				var l = (this.isVisible ? $(window).width()-this.width : $(window).width() ) + "px";
				$(that.container).css( "left", l );
			};
			$(that.container).addClass("animated-slidebar");
		}
		
		this.setUrl = function( url, callback ){
			this.url = url;
			if(url == ''){ 
				that.updateHtml('');
				if( typeof callback == 'function' ){
					callback();
				}
			} else{
				$.ajax({
					url: that.url,
				}).done(function( data ) {
						that.updateHtml(data);
						if( typeof callback == 'function' ){
							callback();
						}
					}).error(function( xhr, status, error ){
					var err = eval("(" + xhr.responseText + ")");
					console.log("Error while loading slidebar. " + err.Message);
				});
			}
		}
		
		//-- U --
		
		this.updateHtml = function( html ){
			$(that.container).html(html);
		}
		
		//Inititlize the slidebar
		this.init();
        window._slidebar = this;
	}

    
    $(window).click(function(){
        if( !window._slidebar.isMouseOver ){
            window._slidebar.hide();
        };
    });
                                
}(jQuery)



