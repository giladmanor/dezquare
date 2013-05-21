var images;
$(document).ready(function(){
	var imageWidth = 0;
	var imageHeight = 0;
	images = $("#landing > img");
	
	/*
	var image = document.getElementById("animated-image");
	if (image.complete)
	{
		ShowGif(image);		
	}
	image.onload = function()
	{
		ShowGif(image);
	}
	*/
		
	ResetImageSize();
});

$(window).resize(function(){
	ResetImageSize();
});

function ShowGif(image)
{
	$(image).animate({ "opacity": 1 }, 500);
}

function ResetImageSize()
{
	var windowWidth = $(document).width();
	var windowHeight = $(document).height();
	var windowRatio = windowWidth / windowHeight;
	var image = images.eq(0);
	var imageWidth = 1440;
	var imageHeight = 900;
	var imageRatio = imageWidth / imageHeight;
	
	if (imageRatio > windowRatio)
	{
		var width = windowHeight * imageRatio;
		images.css({
			'width': width,
			'height': windowHeight,
			'margin-top': 0,
			'margin-left': (windowWidth - width) / 2
		});
	}
	else
	{
		var height = windowWidth / imageRatio;
		images.css({				
			'width': windowWidth,
			'height': height,
			"bottom": "0",
			"top": "auto",
			/*'margin-top': (windowHeight - height) / 2 - 100,*/
			'margin-left': 0
		});
	}
} 