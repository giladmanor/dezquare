var main, sidebar, sidebarScreens;
var fullScreenImages;
var userIsScrolling = 
$(document).ready(function(){
	main = $("#main");
	sidebar = $("#sidebar");
	sidebarScreens = sidebar.find(".sidebar-alt-screen");
	fullScreenImages = $("img.full-screen");
	
	$(".formfield").each(function(){
		var f= $(this);
		var l = f.find("label.abs");
		var i = f.find("input.text");
		var v = f.find(".vchecked");
		
		if ($.trim(i.val()) != "")
		{
			l.hide();
		}
		l.on("click", function(){
			i.trigger("focus");
		});
		i.on("focus", function(){
			l.hide();
		}).on("blur", function(){
			if ($.trim(i.val()) == "")
			{
				l.show();
			}
			
			v.hide();
			if (i.hasClass("validation-normal") && $.trim(i.val()) != "")
			{
				v.show();
			}
			else if (i.hasClass("validation-password") && i.val().length > 5)
			{
				v.show();
			}
			else if (i.hasClass("validation-email") && IsValidEmail(i.val()))
			{
				v.show();
			}
		});
	});
	
	$("span.checkbox").click(function(){
		if ($(this).hasClass("checked"))
		{
			$(this).removeClass("checked");
			$(this).children("input").attr("checked", false);
			
			return;
		}
	
		$(this).addClass("checked");
		$(this).children("input").attr("checked", true);
	});
	
	$(".combobox").each(function(){
		var c = $(this);
		var v = c.find(".value");
		var l = c.find(".options"); 
		var i = c.children("input");
		
		v.click(function(e){
			l.slideDown(300);
			e.stopPropagation();
		});
		
		$(document).click(function(){
			l.slideUp(300);
		});
		
		c.mouseleave(function(){
			l.slideUp(300);
		});
		
		l.children("li").click(function(){
			var key = $(this).attr("value_str");
			var value = $(this).text();
			
			i.val(key);
			v.text(value);
		});
		
		l.show();
		l.mCustomScrollbar();
		l.hide();
	});
	
	$("#stats-map canvas").each(function(){
		var c = $(this);
		var p = c.parent(); 
		p.show();
		var w = c.width();
		var h = c.height();
		var canvas = $(this)[0];
		var context = canvas.getContext('2d');
		context.strokeStyle = '#fff';
		context.moveTo(0,h);
		context.lineTo(w,0);
		context.stroke();
		p.removeAttr("style");
	});
});

$(window).load(function(){
	SetFullScreenImages();
	$("#loading-confirmation-orange").animate({ "width": "100%" }, 3000);
}).resize(function(){
	SetFullScreenImages();
});

function SetFullScreenImages()
{
	var w = $(window).width();
	var h = $(window).height();
	fullScreenImages.each(function(){
		var ow = $(this).width();
		var oh = $(this).height();
		var or = ow / oh;
		var nw = ow < w ? w : ow;
		var nh = oh < h ? h : oh;
		var nr = nw / nh;
		
		if (or > nr)
		{
			nw = nh * ow / oh;
		}
		else
		{
			nh = oh * nw / ow;
		}
		
		$(this).width(nw).height(nh);
	});
}

function IsValidEmail(email) 
{
	var regex = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
	
	return regex.test(email);
}