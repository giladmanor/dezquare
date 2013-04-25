$(document).ready(function(){
	$("#design-selector").each(function(){
		var ds = $(this);
		var a = $(this).find(".action");
		var hearts = $("#design-selector-description .hearts"); 
		
		a.children(".love").on("click", function(){
			var black = hearts.children("span").not(".red");
			
			if (black.length > 0)
			{
				black.eq(0).addClass("red");
				if (black.length == 1)
				{
					window.location.href = 'persona3.html';
				}
			}
		});
	});
	
	$("#designer-selector").each(function(){
		var ds = $(this);
		var overlay = $("#overlay");
		var fullBrief = $("#full-brief");
		var a = ds.find(".action");
		if (navigator.userAgent.indexOf("mobile") == -1 && navigator.userAgent.toLowerCase().indexOf("ipad") == -1)
		{
			a.addClass("has-hover");
		}
		else
		{
			a.find(".x").remove();
		}
		
		a.click(function(e){
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
		
		ds.find(".view-full").click(function(e){
			e.preventDefault();
			
			overlay.show();
			fullBrief.show();
		});
		
		fullBrief.find(".close").click(function(e){
			e.preventDefault();
			fullBrief.hide();
			overlay.hide();
		});
	});
	
	$("#matches-found .matches .image").click(function(){
		var fb = $("#full-brief");
		fb.show();
		fb.siblings("#overlay").show();
	});
	
	$("#full-brief .close").click(function(){
		var p = $(this).parent();
		p.hide();
		p.siblings("#overlay").hide();
	});
	
	$("#interview-banner").each(function(){
		var ib = $(this);
		$(this).children(".close").click(function(){
			ib.children(".content").removeClass("short");
			$(this).remove();
			ib.find(".price-value").text("0");
			ib.find(".info, .images").remove();
			ib.find(".alt").show();
		});
	});
});
