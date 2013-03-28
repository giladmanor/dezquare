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
		var fullBrief = $("#full-brief")
		
		ds.find(".action").click(function(e){
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
