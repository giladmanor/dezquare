$(document).ready(function(){
	var global = new Dezquare.Global();
});

;(function(window) 
{
	window.Dezquare = Dezquare = new Object();	
	Dezquare.Global = function() 
	{
        var self;
		var isAjax = false;
		
		var overlay, popups, loginPopup, forgotPasswordPopup, profileBar, profileStatus, profileStatusCurrent, profileStatusEdit;
		var cancelDesignPopup, cancelDesignExplainPopup, sendDesignerPopup, photoGallery, portfolioGallery;
		var game1, game3, submitGame3, nothingSelectedPopup, submitSelectedPopup, markCompletePopup, newClientPopup, rejectProjectPopup, completeDesignPopup;
		var gameCategories, gameIcons;
		var changeFlyerFlag = false;
		var currentPopupActionButton = null;
		
		function IsValidEmail(email) 
		{
			var regex = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
			
			return regex.test(email);
		}
		
		var BuildSliders = window.BuildSliders = function()
		{
			var priceSlider = $( ".price-slider" );
			priceSlider.each(function(){
				var slider = $(this);
				var priceSliderTooltip = $("<span/>", { "class": "price-slider-tooltip" });
				var priceSliderTooltipInput = $("<input/>", { "name": slider.attr("id"), "type": "text" }).css("outline", "none");
				priceSliderTooltip.append(priceSliderTooltipInput);
				
				var defultValue = typeof slider.attr("data-value") != "undefined" ? parseInt(slider.attr("data-value")) : 105;
				var defaultMin = typeof slider.attr("data-min") != "undefined" ? parseInt(slider.attr("data-min")) : 0;
				var defaultMax = typeof slider.attr("data-max") != "undefined" ? parseInt(slider.attr("data-max")) : 140;
				
				slider.slider("destroy").slider({
					range: "min",
					value: defultValue,
					min: defaultMin,
					max: defaultMax,
					slide: function( event, ui ) {
						priceSliderTooltipInput.val( "$" + ui.value );
					},
					create: function(event, ui) {
						slider.find(".ui-slider-handle").append(priceSliderTooltip);
						if (slider.attr("id") == "game-price")
						{
							slider.find(".ui-slider-handle").append($("<span/>", { "class": "price-slider-info", "text": "X designers will work for this price" }));
						}
					}
				});
				priceSliderTooltipInput.val( "$" + slider.slider( "value" ) );
				priceSliderTooltipInput.blur(function() {
					var val = $(this).val().replace("$", "");
					slider.slider("value", val);
					$(this).val("$" + val);
				});
				priceSliderTooltipInput.keypress(function(evt) {
					var theEvent = evt || window.event;
					var key = theEvent.keyCode || theEvent.which;
					key = String.fromCharCode( key );
					var regex = /[0-9]|\./;
					
					if( !(regex.test(key) || evt.keyCode == 8 || evt.keyCode == 46) ) 
					{
						theEvent.returnValue = false;
						if (theEvent.preventDefault) theEvent.preventDefault();
					}
				});
				priceSliderTooltipInput.keyup(function() {
					var val = $(this).val().replace("$", "");
					slider.slider("value", val);
				});
			});
		};
		
		/* this is the new price elements and buttons */
		var price_button = $('.white-button');
		price_button.click(function(e) {  
		e.preventDefault();	
		var textNone = $('.loading_text');
		var imageShow = $('.loading_image');
		var leftText = setTimeout( "$('.loading_text').css('left','10px');",3000 );
		var timeImage = setTimeout( "$('.loading_image').css('display','none');",3000 );
		var timeText = setTimeout( "$('.loading_text').css('display','inline');",3000 );
		price_button.removeClass('active');
		if ($(this).hasClass('active')) {
			$(this).removeClass('active');
		}
		else {
			$(this).addClass('active');
		}
		
		if ($('#249').hasClass('active')) {
			textNone.css('display','none');
			imageShow.css('display','inline');
			imageShow.css('left' , '63px');
			timeImage;
			leftText;
			timeText;
			
		}
		if ($('#499').hasClass('active')) {
			textNone.css('display','none');
			imageShow.css('display','inline');
			imageShow.css('left' , '197px');
			timeImage;
			setTimeout( "$('.loading_text').css('left','148px');",3000 );
			timeText;
		}
			if ($('#749').hasClass('active')) {
			textNone.css('display','none');
			imageShow.css('display','inline');
			imageShow.css('left' , '351px');
			timeImage;
			setTimeout( "$('.loading_text').css('left','300px');",3000 );
			timeText;
		}
		if ($('#999').hasClass('active')) {
			textNone.css('display','none');
			imageShow.css('display','inline');
			imageShow.css('left' , '503px');
			timeImage;
			setTimeout( "$('.loading_text').css('left','453px');",3000 );
			timeText;
		}
		if ($('#1000').hasClass('active')) {
			textNone.css('display','none');
			imageShow.css('display','inline');
			imageShow.css('left' , '641px');
			timeImage;
			setTimeout( "$('.loading_text').css('left','591px');",3000 );
			timeText;
		}
		});
		
		function BindLanguageEvents(field)
		{
			field.find(".list .option").click(function(){
				if (!field.find(".remove").is(":visible"))
				{
					var clone = field.clone();
					field.after(clone);
					clone.find("input").val("");
					clone.find(".value").text("Add language");
					clone.find(".list").jScrollPane();
					BindLanguageEvents(clone);
					BindComboboxEvents(clone.find(".combobox"));
					field.find(".button").hide();
					field.find(".remove").show();
					field.parent().find(".list-scroll").hide();
				}					
			});
			field.find(".remove").click(function(e){
				e.preventDefault();
				field.remove();
			});
			field.find(".add").click(function(e){
				e.preventDefault();
				var clone = field.clone();
				field.after(clone);
				clone.find("input").val("");
				clone.find(".value").text("Add language");
				var cloneListScroll = clone.find(".list-scroll");
				cloneListScroll.show();
				cloneListScroll.find(".list").jScrollPane();
				cloneListScroll.hide();
				BindLanguageEvents(clone);
				BindComboboxEvents(clone.find(".combobox"));
				field.find(".button").hide();
				field.find(".remove").show();
			});
		};
		
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
		};
		
		function BindComboboxEvents(combobox)
		{
			var list = combobox.find(".list-scroll");
			var value = combobox.children("div.value");
			var input = combobox.children("input");
			list.find("div.option").click(function(){
				var val = $(this).text();
				input.val(val);
				value.text(val);
				list.hide();
			});
			
			combobox.hover(function(){
				list.show();
				combobox.addClass("active");
			}, function() {
				list.hide();
				combobox.removeClass("active");
			});
		};
		
		function SetWelcomeSlidesHeight()
		{
			$("#welcome-slider").each(function(){
				var slider = $(this);
				var height = $(window).height() - 60;
				height = height < 700 ? 700: height;
				slider.children(".welcome-slide").height(height);
				
				var slide1 = slider.children("#welcome-slide1");
				var slide2 = slider.children("#welcome-slide2");
				var slide3 = slider.children("#welcome-slide3");
				var slide4 = slider.children("#welcome-slide4");
				var slide5 = slider.children("#welcome-slide5");
				var slide6 = slider.children("#welcome-slide6");
				
				var slideDuration = 800;
				
				slide1.find("a.black-button").click(function(e){
					e.preventDefault();
					var pos = slide2.position();

					$('html,body').animate({ scrollTop: pos.top - 60 }, slideDuration);
				});
				slide2.find("a.button").click(function(e){
					e.preventDefault();
					var pos = slide3.position();

					$('html,body').animate({ scrollTop: pos.top - 60 }, slideDuration);
				});
				slide3.find("a.button").click(function(e){
					e.preventDefault();
					var pos = slide4.position();

					$('html,body').animate({ scrollTop: pos.top - 59 }, slideDuration);
				});
				slide4.find("a.button").click(function(e){
					e.preventDefault();
					var pos = slide5.position();

					$('html,body').animate({ scrollTop: pos.top - 59 }, slideDuration);
				});
				slide5.find("a.button").click(function(e){
					e.preventDefault();
					var pos = slide6.position();

					$('html,body').animate({ scrollTop: pos.top - 59 }, slideDuration);
				});
			});
		}
		
		/* Base Functions */
		var InitializeObjects = function()
		{
			overlay = $("#window-overlay");
			popups = $(".popup");
			loginPopup = $("#login-popup");
			forgotPasswordPopup = loginPopup.siblings("#forgot-popup");
			profileBar = $("#profile-bar");
			profileStatus = profileBar.children("#profile-status");
			profileStatusCurrent = profileStatus.children(".current");
			profileStatusEdit = profileStatus.children(".edit");
			
			cancelDesignPopup = $("#cancel-design-popup");
			cancelDesignExplainPopup = $("#cancel-design-explain-popup");
			sendDesignerPopup = $("#send-designer-popup");
			
			photoGallery = $("#image-select");
			game1 = $("#game-step-1");
			gameCategories = game1.find("#game-categories");
			gameIcons = game1.find("#game-icons");
			game3 = $("#game-step-3");
			submitGame3 = game3.find("#submit");
			nothingSelectedPopup = $("#nothing-selected-popup");
			submitSelectedPopup = $("#submit-selected-popup");
			markCompletePopup = $("#mark-complete-popup");
			portfolioGallery = $("#portfolio-gallery");
			newClientPopup = $("#new-client-popup")
			rejectProjectPopup = $("#reject-project-popup");
			completeDesignPopup = $("#complete-design-popup");
		};
		
		var BindEvents = function()
		{
			$("#login").click(function(e){
				e.preventDefault();
				popups.each(function(){
					if (!$(this).hasClass("fixed"))
					{
						$(this).hide();
					}
				});
				loginPopup.find("#login-alert").hide();
				loginPopup.find("#forgot-password").hide();
				overlay.show();
				loginPopup.show();
			});
		
			popups.find("span.close").click(function(){
				overlay.hide();
				$(this).parent().hide();
			});
		
			$("div.formfield").each(function(){
				var formfield = $(this);
				var input = formfield.children("input.text, textarea");
				var label = formfield.children("label.abs"); 
				
				if (input.length > 0 && input.val() != "")
				{
					label.hide();
				}
				input.focus(function(){
					label.hide();
				});
				label.click(function(){
					input.focus();
				});
				input.blur(function(){
					if ($(this).val().length == 0)
					{
						label.show();
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
			
			loginPopup.find("#forgot-password").click(function(e){
				e.preventDefault();
				loginPopup.hide();
				forgotPasswordPopup.show();
			});
			loginPopup.find("a.register").click(function(e){
				e.preventDefault();
				loginPopup.hide();
				$("#signup-1-popup").show();
			});
			loginPopup.find("span.close").click(function(){
				$("#register-designer-popup").show();
			});
			loginPopup.find("input[type=submit]").click(function(e){
				var error = loginPopup.find("#login-alert");
				error.hide();
				
				var email = loginPopup.find("input[name=email]").val();
				var password = loginPopup.find("input[name=password]").val();
				if (!IsValidEmail(email) || password.length < 6)
				{
					error.show();
					loginPopup.find("#forgot-password").show();
				
					return false;
				}
			});
			forgotPasswordPopup.find("#submit-fp").click(function(){
				var email = forgotPasswordPopup.find("input[name=email]").val();
				var error = forgotPasswordPopup.find(".form-error");
				error.hide();
				if (!IsValidEmail(email))
				{
					error.show();
				
					return false;
				}
			});

			if (profileStatus.children(".edit").length > 0)
			{
				profileStatus.hover(function(){
					profileStatusCurrent.hide();
					profileStatusEdit.show();
				}, function() {
					profileStatusEdit.hide();
					profileStatusCurrent.show();
				});
				profileStatusEdit.children("span").click(function(){
					var selfClone = $(this).clone();
					profileStatusCurrent.empty().append(selfClone);
					profileStatusEdit.hide();
					profileStatusCurrent.show();
					profileStatusEdit.siblings("input[name=user-status]").val(selfClone.text());
				});
			}
			else 
			{
				profileStatus.find("span").css("cursor", "inherit");
			}
			
			$("#match-projects").each(function(){
				var self = $(this);
				self.delegate("a.mark-complete", "click", function(e){
					//e.preventDefault();
					overlay.show();
					markCompletePopup.show();
				});
				self.delegate("a.accept-design", "click", function(e){
					e.preventDefault();
					overlay.show();
					$("#accept-project-popup").show();
				});
				self.delegate("a.decline", "click", function(e){
					e.preventDefault();
					overlay.show();
					rejectProjectPopup.show();
				});
			});			
			markCompletePopup.find("a.black-button").click(function(e){
				//e.preventDefault();
				markCompletePopup.hide();
				$("#mark-complete-success-popup").show();
			});
			rejectProjectPopup.find("a.decline-anyway").click(function(e){
				//e.preventDefault();
				rejectProjectPopup.hide();
				overlay.hide();
			});
			
			$("a.cancel-design").click(function(e){
				e.preventDefault();
				overlay.show();
				cancelDesignPopup.show();
				currentPopupActionButton = $(this);
			});
			$("a.customer-mark-complete").click(function(e){
				e.preventDefault();
				overlay.show();
				completeDesignPopup.show();
				currentPopupActionButton = $(this);
			});
			cancelDesignPopup.find("a.back").click(function(e){
				e.preventDefault();
				cancelDesignPopup.hide();
				overlay.hide();
			});
			cancelDesignPopup.find("a.black-button").click(function(e){
				e.preventDefault();
				cancelDesignPopup.hide();
				cancelDesignExplainPopup.show();
			});
			cancelDesignExplainPopup.find("a.black-button").click(function(e){
				e.preventDefault();
				overlay.hide();
				cancelDesignExplainPopup.hide();
				
				var basic = currentPopupActionButton.parents(".basic");
				basic.find(".action").remove();
				basic.append($("<div/>", { "class": "action wider" }).append($("<span/>", { "text": "Cancelled", "class": "cancelled" })));
			});
			completeDesignPopup.find("a#just-mark").click(function(e){
				e.preventDefault();
				overlay.hide();
				completeDesignPopup.hide();
				
				var basic = currentPopupActionButton.parents(".basic");
				basic.find(".action").remove();
				basic.append($("<div/>", { "class": "action wider" }).append($("<span/>", { "text": "Completed", "class": "completed" })));
			});
			
			$("a.send-tod").click(function(e){
				e.preventDefault();
				overlay.show();
				sendDesignerPopup.show();
				
			});
			sendDesignerPopup.find("a.orange-button").click(function(e){
				e.preventDefault();
				sendDesignerPopup.hide();
				overlay.hide();
			});
			
			gameCategories.children("a").click(function(e){
				e.preventDefault();
				
				if ($(this).hasClass("active"))
				{
					$(this).removeClass("active");
				}
				else
				{
					$(this).addClass("active");
				}
				
				$(this).siblings("a").removeClass("active");
				
				var selectors = "";
				var categories = gameCategories.children("a").each(function(){
					if ($(this).hasClass("active"))
					{
						var idx = $(this).index() + 1;
						
						selectors = selectors + "," + "a.c" + idx;
					}
				});
				
				gameIcons.find("a").css("opacity", "1");
				if (selectors.length > 0)
				{
					selectors = selectors.substring(1);
					gameIcons.find(selectors).css("opacity", "0.2");
				}
			});
			
			/*gameIcons.find("a").click(function(e){
				e.preventDefault();
				gameIcons.find("a").removeClass("active");
				$(this).addClass("active");
				$("#game-step-2").show();
				window.scrollTo(0, $(document).height());
			});*/
			
			gameIcons.find(".nosoon").click(function(e){
				e.preventDefault();
				gameIcons.find(".nosoon").removeClass("active");
				$(this).addClass("active");
				$("#game-step-2").show();
				window.scrollTo(0, $(document).height());
			});
			
			$('.soon').removeAttr('href');
			$('.soon').removeAttr('onclick');
			$('.soon').unbind('click');
			
			$("#game-step-2 #submit").click(function(){
				$(this).parents("form").submit();
			});
			
			game3.find("#btn-pass").click(function(e){
				e.preventDefault();
				ChangeFlyer();
			});
			game3.find("#btn-like").click(function(e){
				e.preventDefault();
				var src = photoGallery.find("li:visible img").attr("src");
				$("#selected-image").val(src);
				$(this).parents("form").submit();
			});
			
			$('#submit-game4').click(function(e){
				e.preventDefault();
				if (!$(this).hasClass("personas"))
				{
					$(this).parents("form").submit();
				}
			});
			
			submitGame3.click(function(e){
				e.preventDefault();
				if (!$(this).hasClass("disabled"))
				{
					$(this).parents("form").submit();
				}
			});
			
			game3.find("#submit-game4").click(function(e){
				e.preventDefault();
				var checkboxes = game3.find("span.checkbox.checked");
				if (checkboxes.length == 0)
				{
					overlay.show();
					nothingSelectedPopup.show();;
					return false;
				}
				
				$(this).parents("form").submit();
			});
			
			game3.find("#submit-step-5").click(function(e){
				e.preventDefault();
				
				var form = $(this).parents("form");
				form.find("label.form-error").hide();
				var errors = false;
				
				var titleField = form.find("input[name=title]");
				var descriptionField = form.find("textarea[name=description]");
				
				if ($.trim(titleField.val()) == "")
				{
					titleField.siblings("label.form-error").show();;
					errors = true;
				}
				
				if ($.trim(descriptionField.val()) == "")
				{
					descriptionField.siblings("label.form-error").show();;
					errors = true;
				}
				
				if ((descriptionField.val().length) <= 250)
				{
					descriptionField.siblings("label.form-error").show();;
					errors = true;
				}
				//Andrew, can you please add a validation section for file type selectors, field name is: filetype[]
				
				
				if (!errors)
				{
					form.submit();
				}
			});
			
			game3.find("#submit-step-6").click(function(e){
				e.preventDefault();
				
				var form = $(this).parents("form");
				form.find("label.form-error").hide();
				var errors = false;
				
				var firstNameField = form.find("input[name=name]");
				var lastNameField = form.find("input[name=l_name]");
				var emailField = form.find("input[name=email]");
				var passwordField = form.find("input[name=password]");
				var repeatPasswordField = form.find("input[name=re_password]");
				
				if ($.trim(firstNameField.val()) == "")
				{
					firstNameField.siblings("label.form-error").show();;
					errors = true;
				}
				if ($.trim(lastNameField.val()) == "")
				{
					lastNameField.siblings("label.form-error").show();;
					errors = true;
				}
				if (!IsValidEmail(emailField.val()))
				{
					emailField.siblings("label.form-error").show();;
					errors = true;
				}
				if ($.trim(passwordField.val()).length < 6)
				{
					passwordField.siblings("label.form-error").show();;
					errors = true;
				}
				else if (passwordField.val() != repeatPasswordField.val())
				{
					repeatPasswordField.siblings("label.form-error").show();;
					errors = true;
				}
				
				if (!errors)
				{
					form.submit();
				}
			});
			
			$("#submit-short-game-2").click(function(e){
				e.preventDefault();
				
				var form = $(this).parents("form");
				form.find("label.form-error").hide();
				var errors = false;
				
				
				var passwordField = form.find("input[name=password]");
				var rePasswordField = form.find("input[name=re-password]");
				
				if (passwordField.val().length < 6)
				{
					passwordField.siblings(".form-error").show();
					errors = true;
				}
				else if (passwordField.val() != rePasswordField.val())
				{
					rePasswordField.siblings(".form-error").show();
					errors = true;
				}
				
				if (!errors)
				{
					form.submit();
				}
			});
			
			$("#found-matches span.checkbox").click(function(){
				if (!$(this).hasClass("checked"))
				{
					var button = $(this);
					button.addClass("checked").find("input").attr("checked", true);
					overlay.show();
					submitSelectedPopup.show();
					
					submitSelectedPopup.find("a.orange-button").unbind().click(function(e){
						e.preventDefault();
						button.removeClass("checked").find("input").attr("checked", false);
						submitSelectedPopup.hide();
						overlay.hide();
					});
					
					submitSelectedPopup.find("a.replay").unbind().click(function(e){
						e.preventDefault();
						submitSelectedPopup.hide();
						overlay.hide();
					});
				}
			});
			
			nothingSelectedPopup.find("a.orange-button").click(function(e){
				e.preventDefault();
				nothingSelectedPopup.hide();
				overlay.hide();
			});
			
			$("#bottom-login").click(function(e){
				e.preventDefault();
				$("#login").click();
			});
			
			$(".vchecked").each(function(){
				var box = $(this);
				box.siblings("input.text").blur(function(){
					if ($(this).hasClass("password") && $(this).val().length >= 6)
					{
						box.css("display", "block");
					}
					else if (!$(this).hasClass("password") && $.trim($(this).val()) != "")
					{
						box.css("display", "block");
					}
					else
					{
						box.hide();
					}
				});
			});
			
			$(".edit-field").each(function(){
				var box = $(this);
				box.parent().hover(function(){
					box.css("display", "block");
				}, function() {
					box.hide();
				});
			});
			
			$("#dashboard-load-more").click(function(e){
				e.preventDefault();
				if (!$(this).hasClass("disabled") && !isAjax)
				{
					isAjax = true;
					var button = $(this);
					$.ajax({
						"url": "ajax/dashboard-load-more.html",
						"type": "POST",
						"success": function(html) {
							var parent = button.parent();
							parent.append(html).append(button);							
							button.addClass("disabled");
							isAjax = false;
						}
					});
				}
			});
			
			$(".sidebar-mark-complete").click(function(e){
				//e.preventDefault();
				var button = $(this);
				overlay.show();
				markCompletePopup.show();
				markCompletePopup.find("a.black-button").unbind().click(function(e){
					//e.preventDefault();
					markCompletePopup.hide();
					overlay.hide();
					button.hide();
					button.siblings(".completed").removeClass("hidden");
				});
			});
			
			$("#portfolio-prev").click(function(e){
				e.preventDefault();
				
				var width = portfolioGallery.width();
				var slides = portfolioGallery.children("li");
				var currentSlide = portfolioGallery.children("li.active");
				var currentIdx = currentSlide.index();
				
				var newIndex = currentIdx - 1 < 0 ? slides.length -1 : currentIdx - 1;
				
				var newSlide = slides.eq(newIndex);
				newSlide.css({
					"left": (-1) * width + "px"
				});
				
				currentSlide.animate({ "left": width + "px" }, 300, function() {
					currentSlide.removeClass("active");
				});
				newSlide.animate({ "left": "0px" }, 300, function() {
					newSlide.addClass("active");
				});
			});
			$("#portfolio-next").click(function(e){
				e.preventDefault();
				
				var width = portfolioGallery.width();
				var slides = portfolioGallery.children("li");
				var currentSlide = portfolioGallery.children("li.active");
				var currentIdx = currentSlide.index();
				var newIndex = currentIdx + 1 > slides.length - 1 ? 0 : currentIdx + 1;
				
				var newSlide = slides.eq(newIndex);
				newSlide.css({
					
					"left": width + "px"
				});
				
				currentSlide.animate({ "left": (-1) * width + "px" }, 300, function() {
					currentSlide.removeClass("active");
				});
				newSlide.animate({ "left": "0px" }, 300, function() {
					newSlide.addClass("active");
				});
			});
			
			$("#info_form").find("div.tag span.text").css("cursor", "pointer").click(function(){
				var checkbox = $(this).siblings("span.checkbox");
				checkbox.click();
			});
			$("#info_form").submit(function(e){
				var form = $(this);
				var errors = false;
				var title = form.find("input[name=name]");
				var description = form.find("textarea[name=description]");
				
				form.find(".form-error").hide();
				
				if ($.trim(title.val()) == "")
				{
					title.siblings(".form-error").show();
					errors = true;
				}
				
				var checkboxes = form.find("span.checkbox.checked");
				
				if (checkboxes.length < 4 || checkboxes.length > 8)
				{
					form.find(".other-tags .form-error").show();
					errors = true;
				}
				
				return !errors;
			});
			
			$("#info_form").click(function(e){
				var form = $(this);
				var errors = false;
				var title = form.find("input[name=name]");
				var description = form.find("textarea[name=description]");

				form.find(".form-error").hide();

				var checkboxes = form.find("span.checkbox.checked");

				if (checkboxes.length > 8)
				{
					form.find(".other-tags .form-error").show();
					errors = true;
				}
			});

			$("#settings-languages div.formfield").each(function(){
				var field = $(this);
				BindLanguageEvents(field);
			});
			
			$("#got-new-client").click(function(e){
				e.preventDefault();
				overlay.show();
				newClientPopup.show();
			});
			newClientPopup.find("a.cancel").click(function(e){
				e.preventDefault();
				overlay.hide();
				newClientPopup.hide();
			});
			newClientPopup.find("input#nc-submit").click(function(e){
				e.preventDefault();
				newClientPopup.hide();
				$("#new-client-success-popup").show();
			});
			
			$("div#pricing-levels-top").each(function(){
				var row = $(this);
				row.find(".show").click(function(e){
					e.preventDefault();
					row.siblings("#pricing-levels-sliders").show();
					$(this).siblings(".hide").show();
					$(this).hide();
				});
				row.find(".hide").click(function(e){
					e.preventDefault();	
					row.siblings("#pricing-levels-sliders").hide();
					$(this).siblings(".show").show();
					$(this).hide();
				});
			});
			
			$("#get-a-taste").click(function(e){
				e.preventDefault();
				$("#got-new-client").click();
			});

			$("#ccs").each(function(){
				$(this).find(".list-scroll").show();
				$(this).find(".list").jScrollPane();
			});
			
			$(".combobox").each(function(){
				var combo = $(this)
				if (combo.hasClass("language"))
				{
					if (combo.find(".value").text() == "Add language")
					{
						combo.find("input").val("");
					}
				}
				
				var list = combo.find(".list");
				var listScroll = $("<div/>", { "class": "list-scroll" });
				var listInside = $("<div/>", { "class": "list-inside" });
				var options = list.children(".option");
				listInside.append(options);
				list.append(listInside).before(listScroll);
				listScroll.append(list).show();	
				list.jScrollPane();
				listScroll.hide();
				
				BindComboboxEvents(combo);
			});
			
			$("#register-customer-form").submit(function(ev) {
				var f = $(this);
				var fn = f.find("input[name=name]");
				var ln = f.find("input[name=l_name]");
				var e = f.find("input[name=email]");
				var p = f.find("input[name=password]");
				var cp = f.find("input[name=re_password]");
				var tos = f.find("span.checkbox");
				
				f.find(".form-error").hide();
				var errors = false;
				
				if ($.trim(fn.val()) == "")
				{
					fn.siblings(".form-error").show();
					errors = true;
				}
				if ($.trim(ln.val()) == "")
				{
					ln.siblings(".form-error").show();
					errors = true;
				}
				if (!IsValidEmail(e.val()))
				{
					e.siblings(".form-error").show();
					errors = true;
				}
				if (p.val().length < 6)
				{
					p.siblings(".form-error").show();
					errors = true;
				}
				else if (p.val() != cp.val())
				{
					cp.siblings(".form-error").show();
					errors = true;
				}				
				if (!tos.hasClass("checked"))
				{
					tos.siblings(".form-error").show();
					errors = true;
				}
			
				return !errors;
			});
			
			$("#register-designer-form").submit(function(ev) {
				var f = $(this);
				var fn = f.find("input[name=name]");
				var ln = f.find("input[name=l_name]");
				var e = f.find("input[name=email]");
				var l = f.find("input[name=portfolio_link]");
				var tos = f.find("span.checkbox");
				var dl = f.find("input[name=direct_link]");
				
				f.find(".form-error").hide();
				var errors = false;
				
				if ($.trim(fn.val()) == "")
				{
					fn.siblings(".form-error").show();
					errors = true;
				}
				if ($.trim(ln.val()) == "")
				{
					ln.siblings(".form-error").show();
					errors = true;
				}
				if (!IsValidEmail(e.val()))
				{
					e.siblings(".form-error").show();
					errors = true;
				}
				if ($.trim(l.val()) == "")
				{
					l.siblings(".form-error").show();
					errors = true;
				}
				if (!tos.hasClass("checked"))
				{
					tos.siblings(".form-error").show();
					errors = true;
				}
				// if ($.trim(dl.val()) == "")
				// {
					// dl.siblings(".form-error").show();
					// errors = true;
				// }
				return !errors;
			});
			
			$("#game-tastes a").click(function(e) {
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
			
			$("#designer-matches").each(function(){
				var dm = $(this);
				var matches = dm.find("div.match");
				var edp = $("#expanded-designer-popup");
				var eip = $("#expanded-image-popup"); 
				matches.find("a").click(function(e) {
					e.preventDefault();
					overlay.show();
					edp.show();
				});
				
				edp.find("div.gallery a").click(function(e) {
					e.preventDefault();
					edp.hide();
					eip.show();
				});
				eip.find("a.black-button").click(function(e) {
					e.preventDefault();
					eip.hide();
					edp.show();
				});
				
				matches.find("span.checkbox").click(function() {
					if (!$(this).hasClass("checked"))
					{
						var button = $(this);
						button.addClass("checked").find("input").attr("checked", true);
						overlay.show();
						submitSelectedPopup.show();
						
						submitSelectedPopup.find("a.orange-button").unbind().click(function(e){
							e.preventDefault();
							button.removeClass("checked").find("input").attr("checked", false);
							submitSelectedPopup.hide();
							overlay.hide();
						});
						
						submitSelectedPopup.find("a.replay").unbind().click(function(e){
							e.preventDefault();
							submitSelectedPopup.hide();
							overlay.hide();
						});
					}
				})
			}); 
			
			$("#quiz-big-image").each(function() {
				var p = $(this);
				var r = $(this).find("#ruex-popup");
				var i = $(this).find("#intimate-popup");
				p.find("a.excited").click(function(e) {
					e.preventDefault();
					r.show();
				});
				p.find("a.signup").click(function(e) {
					e.preventDefault();
					overlay.show();
					$("#signup-1-popup").show();
				});
				p.find("a.intimate").click(function(e) {
					e.preventDefault();
					r.hide();
					i.show();
				});
				i.find("a.back").click(function(e) {
					e.preventDefault();
					i.hide();
					r.show();
				});
			});
			
			$("#signup-1-popup").each(function() {
				var p = $(this);
				p.find("a.login").click(function(e) {
					e.preventDefault();
					p.hide();
					loginPopup.show();
				});
				p.find("div.social-sign a").click(function(e) {
					e.preventDefault();
					p.hide();
					$("#signup-2-popup").show();					
				});
				p.find("a.old-school").click(function(e) {
					e.preventDefault();
					p.hide();
					$("#signup-3-popup").show();
				});
			});
			
			$("#signup-2-popup").each(function() {
				var p = $(this);
				p.find("a.submit-pf").click(function(e) {
					e.preventDefault();
					p.find("form").submit();;
				});
			});
			
			$("#signup-3-popup").each(function() {
				var p = $(this);
				p.find("a.login").click(function(e) {
					e.preventDefault();
					p.hide();
					loginPopup.show();
				});
				p.find("a.submit-pf").click(function(e) {
					e.preventDefault();
					p.find("form").submit();;
				});
			});
			
			$(".register-step1-popup div.buttons.dynamic").each(function(){
				var buttons = $(this).children("a");
				var input = $(this).children("input");
				buttons.click(function(e){
					e.preventDefault();
					buttons.removeClass("active");
					$(this).addClass("active");
					input.val($(this).index() == 0 ? "designer" : "customer");
				});
			});
			
			$("#sel-prod").each(function() {
				var sl = $(this);
				var icons = sl.find("ul#game-icons a");
				var pr = sl.find("#price-ranges");
				icons.click(function(e) {
					e.preventDefault();
					icons.removeClass("active");
					$(this).addClass("active");
					pr.show();
					window.scroll(0, $(document).height());
				});
				sl.find("div.price-slider-holder a").click(function(e) {
					e.preventDefault();
					$(this).addClass("active");
					$(this).siblings("a").removeClass("active");
					var cols = sl.find("div.price-slider-info div.col");
					cols.removeClass("load"); 
					cols.eq($(this).index()).addClass("load");
				});
				sl.find("div.buttons a.cancel").click(function(e){
					e.preventDefault();
					history.back(1);
				});
				sl.find("div.buttons a.black-button").click(function(e){
					e.preventDefault();
					sl.submit();
				});
			});
			
			$("#game-connect").each(function() {
				var p = $(this);
				p.find("a.login").click(function(e) {
					e.preventDefault();
					overlay.show();
					loginPopup.show();
				});
				p.find("div.social-sign a").click(function(e) {
					e.preventDefault();
					overlay.show();
					$("#signup-2-popup").show();					
				});
				p.find("a.old-school").click(function(e) {
					e.preventDefault();
					overlay.show();
					$("#signup-3-popup").show();
				});
			});
		};
		
		function hideMail()	//this function hides the mail icon
				{
		   $('div.match.disabled').find('.icon').hide();
				}
						hideMail();
		
		/* End Base Functions */
		
		/* DRAG */
		var designerSamples = $("#designer-samples.with-drag");
		designerSamples.find("> a.last").css("margin-right", "20px");
		designerSamples.width(designerSamples.width() + 25);
		if (designerSamples.length)
		{
			designerSamples.parents("#main").css({ "position": "relative" });
			designerSamples.sortable({
				 items: "> a:not(.upload-image)",
				 "start": function() {
					designerSamples.parents("#main").css({ "z-index": 30 });
					$("#window-overlay").show();
				 },
				 "stop": function(a,b,c) {
					$("#window-overlay").hide();
						
					var ids = [];
						
					b.item.parent().children(".sample").each(function() {
						if (!$(this).hasClass("upload-image"))
						{
							var id = $(this).attr("id");
							if (typeof id != "undefined")
							{
								ids.push(id.replace("image_id_", ""));
							}
						}
					});
					
					var queryString = "";
					for (var i in ids)
					{
						queryString = queryString + ids[i] + ",";
					}
					if (queryString.length > 0)
					{
						queryString = queryString.substring(0, queryString.length -1 );
					}
					
					$.ajax({
						"url": "/designer/set_image_order",
						"type": "POST",
						"data": { "ids": queryString }
					});
				 }
			});
		}
		/* END DRAG */
		
		(this.Init = function()
		{
			self = this;
			InitializeObjects();
			BindEvents();
			BuildSliders();
			SetWelcomeSlidesHeight();
			
			var cropPopup = $("#crop-popup");
			if (cropPopup.length > 0)
			{
				if (cropPopup.hasClass("for-cover"))
				{
					CreateJCrop(cropPopup, 985, 241, $("#cover-preview"));
				}
				else if (cropPopup.hasClass("for-profile"))
				{
					CreateJCrop(cropPopup, 117, 117, $("#preview"));
				}
				else
				{
					CreateJCrop(cropPopup, 213, 252, $("#preview"));
				}
			}
		})();
	}
})(window);

function CreateJCrop(holder, width, height, preview)
{
	var jcrop_api, boundx, boundy;
	
	var image = holder.find('img.cropped-image');
	image.css("opacity", 0);
	
	image.each(function() {
		if (this.complete)
		{
			startCrop(holder, width, height, preview);
		}
		else
		{
			$(this).load(function() {
				startCrop(holder, width, height, preview);
			});
		}
	});
	
	function startCrop(holder, width, height, preview) 
	{
		image.attr("style", "opacity: 0;")
		var originalWidth = image.width();
		var originalHeight = image.height();
		
		image.css({
			"max-width": "566px",
			"max-height": "400px",
			"opacity": 1
		});
		image.Jcrop({
			onChange: updatePreview,
			onSelect: updatePreview,
			aspectRatio: width / height,
			//minSize: [width, height],
			setSelect: [0,0,width,height]
		},function(){
			// Use the API to get the real image size
			var bounds = this.getBounds();
			boundx = bounds[0];
			boundy = bounds[1];
			
			var image = holder.find('img.cropped-image');
			holder.find('.sr').val(image.width());
			
			var ratio = image.width() / originalWidth;
			var iRatio = originalWidth / image.width();
			
			preview.css({
				width: image.width() * iRatio,
				height: image.height(),
				marginLeft: '0px',
				marginTop: '0px'
			});
			
			// Store the API in the jcrop_api variable
			jcrop_api = this;
		});		
		
			
		function updatePreview(c)
		{
			if (parseInt(c.w) > 0)
			{
				var rx = width / c.w;
				var ry = height / c.h;

				preview.css({
					width: Math.round(rx * boundx) + 'px',
					height: Math.round(ry * boundy) + 'px',
					marginLeft: '-' + Math.round(rx * c.x) + 'px',
					marginTop: '-' + Math.round(ry * c.y) + 'px'
				});
	  
				holder.find('.x1').val(c.x);
				holder.find('.y1').val(c.y);
				holder.find('.x2').val(c.x2);
				holder.find('.y2').val(c.y2);
				holder.find('.w').val(c.w);
				holder.find('.h').val(c.h);
			}
		};
	}
	
	holder.find("a.black-button").click(function(e) {
		e.preventDefault();
		holder.find("form").submit();
	});
}
				
