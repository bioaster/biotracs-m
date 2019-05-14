/** 
 * @file 		biotracs.js
 * @link		http://www.bioaster.org
 * @license		BIOASTER Licence
 * @author		D. A. Ouattara
 * @date		14 Aug 2018
 * @brief	    Bioaster Technology Research Institute (http://www.bioaster.org)
 */
 
+function ($){
	
	if( typeof window.biotracs == "undefined" ){
		var biotracs = {};
		window.biotracs = biotracs;
	} else{
		var biotracs = window.biotracs;
	}
	
	

    $(document).ready(function(){ 
                
        //format code boxes (highlight syntaxes)
        $(".code-box-json").each(function(){
            str = $(this).html();
            data = JSON.parse(str);
            str = JSON.stringify(data, undefined, 3);
            str = str
                    .replace(/ /g, '&nbsp;')
                    .replace(/("[^"]*")(:\s*)([^,\r\n\{]*)?(,)?/g, '<span class="json-key">$1</span>$2<span class="json-value">$3</span>$4')
                    .replace(/(\r\n|\r|\n)/g, '<br>');

            $(this).html(str);
            //console.log(str);
        });

        //format markdown
        var converter = new showdown.Converter({
                'simplifiedAutoLink': true,
                'simpleLineBreaks': true,
                'openLinksInNewWindow': true,
                'parseImgDimensions': true,
                'tables': true,
                'tasklists': true,
        });
        
        $(".markdown").each(function(){
            var doc = $(this).text();
            html = converter.makeHtml(doc);
            $(this).html(html);
        })
        
        //format accordions
		$(".accordion-item-arrow")
			.children(".accordion-item-title")
			.prepend('<div class="accordion-item-marker">&rarr;</div>');
		
        $(".accordion-item-plus")
			.children(".accordion-item-title")
			.prepend('<div class="accordion-item-marker">+</div>');
		
		$(".accordion-item-none")
			.children(".accordion-item-title")
			.prepend('<div class="accordion-item-marker">&nbsp;</div>');
		
		$(".accordion-item-title").click(function(e){
			//e.preventDefault();
			var  child = $(this).children(".accordion-item-marker");
			if($(this).parent().hasClass("accordion-item-plus")){
				var html = (child.html() == "+") ? '-' : '+';
				child.html( html );
			} else if($(this).parent().hasClass("accordion-item-arrow")){
				var html =  (child.html() == "+") ? '-' : '&rarr;';
				child.html( html );
			};
		});
		
        //format links
		
		$(".link").click( function(e){
			e.preventDefault();
			href = $(this).data("href");
			if(typeof href == "undefined" || href == "") return;
			window.location.assign(href);
		});
        
    });
}(jQuery)



