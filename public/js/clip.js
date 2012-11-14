	$(document).ready(function(){
	$('a#copy-description').zclip({
        path:'http://dezquare.com/js/ZeroClipboard.swf',
        copy:$('p#description').text()
    });
    // The link with ID "copy-description" will copy
    // the text of the paragraph with ID "description"
    $('a#copy-dynamic').zclip({
        path:'http://dezquare.com/js/ZeroClipboard.swf',
        copy:function(){return "http://dezquare.com/d/"+$('input#dynamic').val();}
    });
    // The link with ID "copy-dynamic" will copy the current value
    // of a dynamically changing input with the ID "dynamic"

	
	$("a#copy-callbacks").zclip({
	        path:'http://dezquare.com/js/ZeroClipboard.swf',
	        copy:$('#callback-paragraph').text(),
	        beforeCopy:function(){
	            $('#callback-paragraph').css('background','yellow');
	            $(this).css('color','orange');
	        },
	        afterCopy:function(){
	            $('#callback-paragraph').css('background','green');
	            $(this).css('color','purple');
	            $(this).next('.check').show();
	        }
	    });
	});