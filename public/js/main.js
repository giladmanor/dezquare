var stages, stage1, stage2, stage3;
var slider, finalSlide;
var slide1, slide2, slide3, slide4, slide5, slide6;
var dslide1, dslide2;
var rslide1, rslide2, rslide3, rslide4;
var pslide1, pslide2;
var loginForm, photoGallery, flyerDescription, yourEmail, yourName, tagsPopup;
var slideWidth = 900;
var slideAnimationDuration = 500;
var changeFlyerFlag = false, scrollClicked = false, loginFormSlide = false;
var flyerSelection = true;

var links = [
	"http://www.youtube.com/watch?v=g4tpuu-Up90",
	"http://www.youtube.com/watch?v=RVmG_d3HKBA",
	"http://www.youtube.com/watch?v=clwLKJ294u4"
];

$(document).ready(function(){
	slider = $("#slider");
	
	slide1 = slider.children("#slide1");
	slide2 = slider.children("#slide2");
	slide3 = slider.children("#slide3");
	slide4 = slider.children("#slide4");
	slide5 = slider.children("#slide5");
	slide6 = slider.children("#slide6");
	
	dslide1 = slider.children("#dslide1");
	var dslide2Link = GetYoutubeLink();
	slider.children("div.final-slide").find("div.link").empty().append($("<a/>", { "href": dslide2Link, "text": dslide2Link, "target": "_blank" }));
	
	rslide1 = slider.children("#rslide1");
	rslide2 = slider.children("#rslide2");
	rslide3 = slider.children("#rslide3");
	rslide4 = slider.children("#rslide4");
	
	pslide1 = slider.children("#pslide1");
	pslide2 = slider.children("#pslide2");
	
	loginForm = $("#login-form");
	photoGallery = slide2.find("#photo-gallery");
	flyerDescription = slide4.find("#flyer-description");
	yourEmail = slide5.find("#your-email");
	yourName = slide5.find("#your-name");
	flyerDescription.val("");
	yourEmail.val("");
	yourName.val("");
	dslide1.find("input[type=text]").val("");
	rslide2.find("input[type=text]").val("");
	rslide3.find("input[type=text]").val("");
	
	tagsPopup = $("#tags-popup");
	
	stages = $("div#stages");
	stage1 = stages.children("div#stage1");
	stage2 = stages.children("div#stage2");
	stage3 = stages.children("div#stage3");
	
	var loader = new Preloader.Instance();
	Preloader.Instance.AddImageInQueue("/img/bkg-command-button.png");
	Preloader.Instance.AddImageInQueue("/img/bkg-slide5.jpg");
	Preloader.Instance.AddImageInQueue("/img/bkg-input.png");
	//Gallery Images
	Preloader.Instance.AddImageInQueue("/img/temp/michal-rahat.jpg");
	Preloader.Instance.AddImageInQueue("/img/temp/princess-owl-sm.jpg");
	Preloader.Instance.AddImageInQueue("/img/temp/29.jpg");
	Preloader.Instance.AddImageInQueue("/img/temp/1.jpg");
	Preloader.Instance.AddImageInQueue("/img/temp/4.jpg");
	Preloader.Instance.AddImageInQueue("/img/temp/18.jpg");
	Preloader.Instance.AddImageInQueue("/img/temp/25.jpg");
	Preloader.Instance.AddImageInQueue("/img/temp/28.jpg");
	Preloader.Instance.AddImageInQueue("/img/temp/31.jpg");
	Preloader.Instance.AddImageInQueue("/img/temp/36.jpg");
	//End Gallery Images
	Preloader.Instance.LoadImages();
	
	BindEvents();
	
	if (rslide2.length > 0)
	{
		rslide2.find("input#flyer-1-file").uploadify({
			swf           : 'swf/uploadify.swf',
			uploader      : 'upload.php',
			auto: false,
			width: 152,
			height: 65,
			buttonText: "Browse",
			onDialogOpen: function()
			{
				rslide2.find("div.error").remove();
			},
			onSelect	: function(a)
			{
				rslide2.find("input#flyer-1").val(a.name);
			}
		});
	}
	if (rslide3.length > 0)
	{
		rslide3.find("input#flyer-2-file").uploadify({
			swf           : 'swf/uploadify.swf',
			uploader      : 'upload.php',
			auto: false,
			width: 152,
			height: 65,
			buttonText: "Browse",
			onDialogOpen: function()
			{
				rslide3.find("div.error").remove();
			},
			onSelect	: function(a)
			{
				rslide3.find("input#flyer-2").val(a.name);
			}
		});
	}
	
	if (pslide1.length > 0)
	{
		pslide1.find("input#flyer-1-file").uploadify({
			swf           : 'swf/uploadify.swf',
			uploader      : 'upload.php',
			auto: false,
			width: 300,
			height: 39,
			buttonText: "Replace Flyer"
		});
	}
	if (pslide2.length > 0)
	{
		pslide2.find("input#flyer-2-file").uploadify({
			swf           : 'swf/uploadify.swf',
			uploader      : 'upload.php',
			auto: false,
			width: 300,
			height: 39,
			buttonText: "Replace Flyer"
		});
	}
});

function ShowTagsPopup()
{
	tagsPopup.find("span.checkbox").removeClass("checked");
	tagsPopup.find("input[type=checkbox]").attr("checked", false);
	tagsPopup.fadeIn(300, function(){
		tagsPopup.find("div.select-tag-list-inside").jScrollPane();
	});
}

function BindEvents()
{
	/* Buyer Page */
	slide2.find("#btn-like").click(function(){
		if (flyerSelection)
		{
			flyerSelection = false;
			$("#image1").val(photoGallery.find("li:visible img").attr("src"));
			ChangeFlyer();
		}
		else
		{
			$("#image2").val(photoGallery.find("li:visible img").attr("src"));
			$("#image2").parent().submit();
		}
		
		return false;
	});
	slide2.find("#btn-pass").click(ChangeFlyer);
	slide4.find("#btn-next").click(function(){
		flyerDescription.parent().find("div.error").remove();
		if ($.trim(flyerDescription.val()) == "")
		{
			flyerDescription.parent().append($("<div/>", { "class": "error", "text": "Please tell us about your flyer" }));
		}
		else
		{
			flyerDescription.parent().parent().submit();
		}
		
		return false;
	});
	
	slide5.find("#btn-rock-on").click(function(){
		var parent = yourEmail.parent().parent().parent();
		parent.find("div.error").remove();
		if (!IsValidEmail(yourEmail.val()) && $.trim(yourName.val()) == "")
		{
			parent.append($("<div/>", { "class": "error", "text": "Please insert a valid name and email address" }));
		}
		else if (!IsValidEmail(yourEmail.val()))
		{
			parent.append($("<div/>", { "class": "error", "text": "Please insert a valid email address" }));
		}
		else if ($.trim(yourName.val()) == "")
		{
			parent.append($("<div/>", { "class": "error", "text": "Please insert a valid name" }));
		}
		else
		{
			slide5.find("form").submit();
		}
		
		return false;
	});
		
	pslide1.find("#go-edit-flyer2").click(function(){
		var errorHolder = pslide1.find(".error-holder");
		errorHolder.empty();
		var tags = pslide1.find(".select-tag-list span.checkbox.checked");
		if (tags.length > 0)
		{
			pslide1.find("form").submit();
		}
		else
		{
			errorHolder.text("Please select at least one tag");
		}
		
		return false;
	});
	pslide2.find("#done-edit-flyer2").click(function(){
		var errorHolder = pslide2.find(".error-holder");
		errorHolder.empty();
		var tags = pslide2.find(".select-tag-list span.checkbox.checked");
		if (tags.length > 0)
		{
			pslide2.find("form").submit();
		}
		else
		{
			errorHolder.text("Please select at least one tag");
		}
		
		return false;
	});
	
	$("ul.tags").delegate("a.btn-delete", "click", function(){
		$(this).parent().remove();
		
		return false;
	});
	
	$("div.flyer-tag-list a.view-more").click(function(){
		if (!scrollClicked)
		{
			scrollClicked = true;
			var ul = $(this).parents("div.view-more-holder").siblings("ul.tags");
			var count = ul.children("li").length;
			ul.append('<li><a class="btn-delete"></a>Tag ' + (count+1) + '</li>');
			ul.append('<li><a class="btn-delete"></a>Tag ' + (count+2) + '</li>');
			ul.append('<li><a class="btn-delete"></a>Tag ' + (count+3) + '</li>');
			
			ul.animate({
				scrollTop: (count+3)*45
			}, 500, function(){
				scrollClicked = false;
			});
		}
		
		return false;
	});
	/* Buyer Page */
	
	/* Designer Page */
	/* Login Form */
	$("#key-holder").hover(function(){
		if (!loginFormSlide)
		{
			loginFormSlide = true;
			loginForm.slideDown(200, function(){
				loginFormSlide = false;
			});
		}
	}, function(){
		loginForm.slideUp(200);
	});
	/* End Login Form */
	dslide1.find("form").submit(function(){
		var form = $(this);
		form.find("div.error").remove();
		var link = form.find("input[name=portfolio_link]");
		var firstName = form.find("input[name=name]");
		var lastName = form.find("input[name=l_name]");
		var email = form.find("input[name=email]");
		if (!IsValidEmail(email.val()) || $.trim(firstName.val()) == "" || $.trim(lastName.val()) == "" || $.trim(link.val()) == "")
		{
			form.append($("<div/>", { "class": "error", "text": "Please insert a valid link, name and email address" }));
		}
		else
		{
			return true;
		}
		
		return false;
	});
	dslide1.find("#go-to-dslide2").click(function(e){
		e.preventDefault();
		dslide1.find("form").submit();
	});
	/* End Designer Page */
	
	/* Register Page */
	//rslide1.find("input[type=hidden]").val("");
	//rslide1.find("input[type=checkbox]").attr("checked", false);
	rslide1.find("input[type=text]").each(function(){
		if ($(this).val() != "")
		{
			$(this).siblings("label").hide();
		}
	});
	
	rslide1.find("form").submit(function(){
		var form = $(this);
		form.find("div.error").remove();
		var firstName = form.find("input[name=name]");
		var lastName = form.find("input[name=l_name]");
		var month = form.find("input[name=month]");
		var year = form.find("input[name=year]");
		var location = form.find("input[name=location]");
		if ($.trim(firstName.val()) == "" || $.trim(lastName.val()) == "" || $.trim(month.val()) == "" || $.trim(year.val()) == "" ||  $.trim(location.val()) == "")
		{
			form.append($("<div/>", { "class": "error", "text": "Please insert a valid name, age, location and language"+firstName.val()+"-"+lastName.val()+"-"+ month.val()+"-"+year.val()+"-"+location.val()}));
		}
		else
		{
			return true;
		}
		
		return false;
	});
	rslide1.find("#go-to-rslide2").click(function(e){
		e.preventDefault();
		rslide1.find("form").submit();
	});
	rslide2.find("#flyer-1-upload").click(function(e){
		e.preventDefault();		
		form = rslide2.find("form");
		form.find("div.error").remove();
		if ($.trim(rslide2.find("input#flyer-1").val()) == "")
		{
			form.append($("<div/>", { "class": "error", "text": "Please upload your flyer" }));
		}
		else
		{
			ShowTagsPopup();
		}
	});
	rslide3.find("#flyer-2-upload").click(function(e){
		e.preventDefault();
		
		form = rslide3.find("form");
		form.find("div.error").remove();
		if ($.trim(rslide3.find("input#flyer-2").val()) == "")
		{
			form.append($("<div/>", { "class": "error", "text": "Please upload your flyer" }));
		}
		else
		{
			ShowTagsPopup();
		}
	});

	tagsPopup.find("form").submit(function(){
		var errorHolder = $(this).children("div.error-holder");
		errorHolder.empty();
		var tags = tagsPopup.find("span.checked");
		if (tags.length == 0)
		{
			errorHolder.text("Please select at least one tag");
		}
		else
		{
			return true;
		}		
		
		return false;
	})
	tagsPopup.find("#tags-popup-done").click(function(e){
		e.preventDefault();
		tagsPopup.find("form").submit();
	});
	/* End Register Page */
	
	/* Edit Info Page */
	rslide1.find("#save-userinfo").click(function(e){
		var form = rslide1.find("form");
		form.find("div.error").remove();
		var link = form.find("input[name=name]");
		var name = form.find("input[name=age]");
		var location = form.find("#location-selector .value");
		var language = form.find("#language-selector .value");
		if ($.trim(link.val()) == "" || $.trim(name.val()) == "" || location.text() == "Select Location")
		{
			form.append($("<div/>", { "class": "error", "text": "Please insert a valid name, age, location and language" }));
			
			return false;
		}
	});
	/* End Edit Info Page */
	
	/* Logged In Page */
	$(".user-flyers a").click(function(e){
		e.preventDefault();
		var img = $(this).children("img");
		var frame = tagsPopup.find("div.frame");
		tagsPopup.show();
		frame.empty().append($("<img/>", { "src": img.attr("src") } ));
	});
	$("#show-read-more").click(function(e){
		e.preventDefault();
		$("#read-more-popup").show();
	});
	$("#nav-buttons a").click(function(e){
		e.preventDefault();
		if (!$(this).hasClass("active") && !$(this).hasClass("disabled"))
		{
			$(this).parent().children("a").removeClass("active");
			$(this).addClass("active");
			
			var cPage = $("#profile-pages div.profile-page:visible");
			var cNo = parseInt(cPage.attr("id").replace("page",""));
			var no = parseInt($(this).attr("href").replace("#page",""));
			
			var left = cNo < no ? slideWidth : ((-1) * slideWidth);
			$($(this).attr("href")).css({
				"left": left + "px",
				"display": "block"
			});
		
			var newLeft = cNo < no ? "-=900px" : "+=900px";
			$("#" + cPage.attr("id") + ", " + $(this).attr("href")).animate({
				"left": newLeft
			}, slideAnimationDuration, function(){
				cPage.hide();
			});	
		}
	});
	/* End Logged In Page */
	
	var textarea = $(".textarea");	
	textarea.children("textarea").focus(function(){
		textarea.children("label").hide();
	});
	textarea.children("textarea").blur(function(){
		if ($.trim($(this).val()) == "")
		{
			textarea.children("label").show();
		}
	});
	textarea.children("label").click(function(){
		textarea.children("textarea").focus();	
	});
	
	var inputs = $("div.input");
	inputs.each(function(){
		$(this).children("input.text").focus(function(){
			$(this).siblings("label").hide();
		});
		$(this).children("input.text").blur(function(){
			if ($.trim($(this).val()).length == 0)
			{
				$(this).siblings("label").show();
			}
		});
		$(this).children("label").click(function(){
			$(this).siblings("input.text").focus();
		});
	});
	
	var selectorSlide = false;
	var selectors = $("div.selector");
	if (selectors.length > 0)
	{
		selectors.find("div.scroll").show();
		selectors.find("div.list").jScrollPane();
		selectors.find("div.scroll").hide();
	}
	selectors.find("div.value").click(function(e){
		e.stopPropagation();
		if (selectorSlide == false || true)
		{
			selectorSlide = true;
			var list = $(this).parents("div.selector").find("div.scroll");
			
			if (list.is(":visible"))
			{
				list.slideUp(200, function(){
					list.parent().removeClass("active");
					selectorSlide = false;
				});
			}
			else
			{
				selectors.find("div.scroll").slideUp(200);
				list.parent().addClass("active");
				list.slideDown(200, function(){
					selectorSlide = false;
				});
			}
		}
	});
	
	$("div.popup span.close-popup").click(function(){
		$(this).parents("div.popup").fadeOut(300);
	});
	
	if ($("body").hasClass("portfolio-page"))
	{
		$(".edit-tags div.select-tag-list-inside").jScrollPane();
	}
	
	$("div.popup div.select-tag-list li").click(function(){
		var checkbox = $(this).find("span.checkbox");
		var input = checkbox.siblings("input[type=checkbox]");
		if (checkbox.hasClass("checked"))
		{
			checkbox.removeClass("checked");
			input.attr("checked", false);
		}
		else
		{
			checkbox.addClass("checked");
			input.attr("checked", true);
		}
	});
	$("#location-selector li").each(function(){
		if ($(this).text().length > 18)
		{	
			$(this).text($.trim($(this).text().substring(0,18))+"...");
		}
	});
	selectors.find("li").click(function(e){
		var selectorId = $(this).parents("div.selector").attr("id");
		if (selectorId == "language-selector")
		{
			e.stopPropagation();
			var checkbox = $(this).find("span.checkbox");
			var input = checkbox.siblings("input[type=checkbox]");
			if (checkbox.hasClass("checked"))
			{
				checkbox = checkbox.removeClass("checked");
				input.attr("checked", false);
			}
			else
			{
				checkbox = checkbox.addClass("checked");
				input.attr("checked", true);
			}
		}
		else
		{
			var val = $(this).text();
			var sel = $(this).parents("div.selector");
			if (selectorId == "month-selector")
			{
				sel.children("div.value").text(val.length > 5 ? val.substring(0,5) : val);
			}
			else
			{
				sel.children("div.value").text(val);
			}
			sel.children("input[type=hidden]").val(val);
			selectors.find("div.scroll").slideUp(200);
		}
	});
	selectors.click(function(e){
		e.stopPropagation();
	});
	$(document).click(function(){
		selectors.find("div.scroll").slideUp(200);
	});
	
	AdjustSubtitleSize();
	$(window).resize(AdjustSubtitleSize);
}

function ChangeFlyer()
{
	if (!changeFlyerFlag)
	{
		changeFlyerFlag = true;
		var current = photoGallery.find("li:visible");
		var next = photoGallery.find("li").eq(current.index()+1);
		if (current.index() > photoGallery.find("li").length-2)
		{
			next = photoGallery.find("li").eq(0);
		}
		
		current.fadeOut(100);
		next.fadeIn(100, function(){
			changeFlyerFlag = false;
		});
	}
	
	return false;
}

function AdjustSubtitleSize()
{
	if (navigator.userAgent.toLowerCase().indexOf("iphone") != -1)
	{
		slide5.find("div.subtitle").addClass("smaller");
	}
	else
	{
		slide5.find("div.subtitle").removeClass("smaller");
	}
}

;(function(window)
{
	window.Preloader = Preloader = new Object();	
	Preloader.Instance = function()
	{
		var self;
		var loaded = 0;
		var queue = new Array();
		var images = [];
		
		var AddImageInQueue = Preloader.Instance.AddImageInQueue = function(imageSrc)
		{
			images.push(imageSrc);
		};
		
		var LoadImages = Preloader.Instance.LoadImages = function()
		{
			for (var i in images)
			{
				var image = new Image(1,1);
				image.src = images[i];
				queue.push(image);
			}
		};
		
		(this.Init = function()
		{
			self = this;
		})();
	}
})(window);

function IsValidEmail(email) {
	var regex = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
	
	return regex.test(email);
}

function GetYoutubeLink()
{
	return links[Math.floor(Math.random()*10)%links.length];
}