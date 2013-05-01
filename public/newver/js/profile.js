var profileContent, profilePhotoBar, profileConfig, restoreArrow, userChatFeed;
var isScrolling = false;
var $page, profileWidgets;

$(document).ready(function(){
	$page = $("#page");
	$page.scrollLeft(0);
	profileWidgets = $page.find("#profile-widgets");
	profileContent = $("#profile-content");
	profilePhotoBar = profileContent.find("#profile-photo-bar");
	profileConfig = profileContent.find("#profile-config");
	restoreArrow = $("#restore-arrow");
	var ml = 79;
	var mpml = 95;
	var scrollBarWidth = GetScrollBarWidth();
	
	if (typeof ImageMasonry != "undefined")
	{
		var imageGrid = ImageMasonry.Instance();
	}
	
	var userAgent = navigator.userAgent.toLowerCase();
	
	if (userAgent.indexOf("ipad") != -1 || userAgent.indexOf("iphone") != -1)
	{
		$page.removeClass("profile-scroll");
		
		$page
				.on('swipeleft', function(e) { ScrollProfile(-80, true); })
				.on('swiperight', function(e) { ScrollProfile(80, true); })
				.on('swipedown', function(e) { ScrollProfile(-80, true); })
				.on('swipeup', function(e) { ScrollProfile(80, true); });
	}
	else
	{
		$("#page.profile-scroll").scroll(function(){
			profileWidgets.css({ "left": $page.scrollLeft() });
			
			restoreArrow.css("display", profileContent.position().left < 0 ? 'block' : 'none');
			
			if (profileContent.position().left - profilePhotoBar.width() < 0)
			{
				profilePhotoBar.height(profilePhotoBar.height());
				profileContent.addClass("hide-masonry");
				profileConfig.css("bottom", 20 + scrollBarWidth);
			}
			else
			{
				profilePhotoBar.removeAttr("style");
				profileContent.removeClass("hide-masonry");
				profileConfig.removeAttr("style");
			}
			
			if (typeof ImageMasonry != "undefined")
			{
				window.ImageMasonryLoadNewItems(Math.floor($(this).scrollLeft() / 1800));
			}
		});
		
		var myimage = document.getElementById("page");
		userChatFeed = document.getElementById("user-chat-feed");
		var selectProjectCombo = document.getElementById("select-project-combo");
		if (myimage.addEventListener) 
		{
			if (userChatFeed != null)
			{
				userChatFeed.addEventListener("mousewheel", DenyMouseWheelHandler, false);
				userChatFeed.addEventListener("wheel", DenyMouseWheelHandler, false);
				
				var $userChatFeed = $(userChatFeed);
				$(userChatFeed).scrollTop($userChatFeed.children("#user-chat-feed-inside").height() - $userChatFeed.height());
			}
			
			if (selectProjectCombo != null)
			{
				selectProjectCombo.addEventListener("mousewheel", DenyMouseWheelHandler, false);
				selectProjectCombo.addEventListener("wheel", DenyMouseWheelHandler, false);
			}
			
			// IE9, Chrome, Safari, Opera
			myimage.addEventListener("mousewheel", MouseWheelHandler, false);
			/*
			// Firefox
			myimage.addEventListener("DOMMouseScroll", MouseWheelHandler, false);
			*/
			myimage.addEventListener("wheel", MouseWheelHandlerFF, false);
		}
		// IE 6/7/8
		else myimage.attachEvent("onmousewheel", MouseWheelHandler);
		
		/*
		$("#page.profile-scroll").mousewheel('mousewheel', function(event, delta) {
			ScrollProfile(delta);
	    });
		$("#page.profile-scroll").bind('mousewheel', function(event, delta) {
			ScrollProfile(delta);
	    });
	    */
	}
	
    var ScrollProfile = window.ScrollProfilePage = function(delta, animate)
    {
    	var profileContentPosition = profileContent.position();
    	var full = profileContent.parent().width(); 
    	var currentLeft = profileContentPosition.left;
    	
    	var maxLeft = full / 100 * ml;
    	if (profileContent.hasClass("my-profile"))
    	{
    		maxLeft = full / 100 * mpml;
    	}
    	var distance = full / 100;
    	var newLeft = currentLeft + delta * distance;
    	newLeft = newLeft > maxLeft ? maxLeft : newLeft;
    	if (newLeft < 0)
    	{
    		profileContent.addClass("hide-masonry");
    		if (profileContent.hasClass("public-profile"))
    		{
    			window.ImageMasonryLoadNewItems(Math.floor(newLeft / 700));
    		}
    		else
    		{
		    	newLeft = 0;
    		}
    		restoreArrow.show();
    	}
    	else
    	{
    		profileContent.removeClass("hide-masonry");
    		restoreArrow.hide();
    	}
    	
    	if (animate === true)
    	{
    		var currentPosition = profileContent.position(); 
    		profileContent.css("left", currentPosition.left);
    		profileContent.animate( { "left": newLeft }, 400);
    	}
    	else
    	{
	    	profileContent.css("left", newLeft);
    	}
    }
   
    restoreArrow.click(function(){
    	if (userAgent.indexOf("ipad") != -1 || userAgent.indexOf("iphone") != -1)
    	{
    		var full = profileContent.parent().width(); 
    		profileContent.animate( { "left": full * mpml / 100 }, 500);
    	}
    	else
    	{
	    	$page.animate({ "scrollLeft": 0 }, 500);
    	}
    	
    	restoreArrow.hide();
    });
    
    $("#page").delegate(".image-item", "click", function(e){
    	e.preventDefault();
    });
    $("#page").delegate(".image-item .heart", "click", function(e){
    	e.preventDefault();
    	if ($(this).hasClass("active"))
    	{
    		$(this).removeClass("active");
    	}
    	else
    	{
    		$(this).addClass("active");
    	}
    });
    
    $("#designer-list .show-full-brief").click(function(){
		var fb = $("#full-brief");
		fb.show();
		fb.siblings("#overlay").show();
	});
	
	$("#full-brief .close").click(function(){
		var p = $(this).parent();
		p.hide();
		p.siblings("#overlay").hide();
	});
});

$(window).load(function(){
	if (userChatFeed != null)
	{
		var $userChatFeed = $(userChatFeed);
		$(userChatFeed).scrollTop($userChatFeed.children("#user-chat-feed-inside").height() - $userChatFeed.height());
	}
});

function MouseWheelHandlerFF(e) 
{
	if (e.deltaY != 0 && e.deltaX == 0)
	{
		var coef = e.deltaY;
		if (coef < 50 && coef > -50)
		{
			coef = 40*e.deltaY;
		}
		$page.scrollLeft($page.scrollLeft() + coef);
	}

	return false;
}
function MouseWheelHandler(e) 
{
	if (e.wheelDeltaY != 0 && e.wheelDeltaX == 0)
	{
		$page.scrollLeft($page.scrollLeft() + (-1*e.wheelDeltaY));
	}

	return false;
}
function DenyMouseWheelHandler(e)
{
	e.stopPropagation();
}