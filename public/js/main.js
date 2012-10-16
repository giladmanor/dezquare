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
		
		function BuildSliders()
		{
			var priceSlider = $( ".price-slider" );
			priceSlider.each(function(){
				var slider = $(this);
				var priceSliderTooltip = $("<span/>", { "class": "price-slider-tooltip" });
				var priceSliderTooltipInput = $("<input/>", { "name": slider.attr("id"), "type": "text", "readonly": "readonly" });
				priceSliderTooltip.append(priceSliderTooltipInput);
				
				var defultValue = typeof slider.attr("data-value") != "undefined" ? parseInt(slider.attr("data-value")) : 105;
				var defaultMin = typeof slider.attr("data-min") != "undefined" ? parseInt(slider.attr("data-min")) : 0;
				var defaultMax = typeof slider.attr("data-max") != "undefined" ? parseInt(slider.attr("data-max")) : 140;
				
				slider.slider({
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
			});
		};
		
		function BindLanguageEvents(field)
		{
			field.find(".list .option").click(function(){
				if (!field.find(".remove").is(":visible"))
				{
					var clone = field.clone();
					field.after(clone);
					clone.find("input").val("");
					clone.find(".value").text("Add language");
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
				field.parent().append(clone);
				clone.find("input").val("");
				clone.find(".value").text("Add language");
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
			
			$("#match-projects").each(function(){
				var self = $(this);
				self.delegate("a.mark-complete", "click", function(e){
					e.preventDefault();
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
				e.preventDefault();
				markCompletePopup.hide();
				$("#mark-complete-success-popup").show();
			});
			rejectProjectPopup.find("a.decline-anyway").click(function(e){
				e.preventDefault();
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
			
			gameCategories.children("a").hover(function(){
				var idx = $(this).index() + 1;
				gameIcons.find("a.c" + idx).css("opacity", "0.2");
			}, function(){ 
				var idx = $(this).index() + 1;
				gameIcons.find("a").css("opacity", "1");
			});
			
			gameIcons.find("a").click(function(e){
				e.preventDefault();
				gameIcons.find("a").removeClass("active");
				$(this).addClass("active");
				$("#game-step-2").show();
				window.scrollTo(0, $(document).height());
			});
			
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
					if ($.trim($(this).val()) != "")
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
				e.preventDefault();
				var button = $(this);
				overlay.show();
				markCompletePopup.show();
				markCompletePopup.find("a.black-button").unbind().click(function(e){
					e.preventDefault();
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
			
			$("#submit-photo").click(function(e){
				var form = $(this).parents("form");
				var errors = false;
				var title = form.find("input[name=title]");
				var description = form.find("textarea[name=product-type]");
				
				form.find(".form-error").hide();
				
				if ($.trim(title.val()) == "")
				{
					title.siblings(".form-error").show();
					errors = true;
				}
				
				if (form.find("span.checkbox.checked").length == 0)
				{
					form.find(".other-tags .form-error").show();
					errors = true;
				}
				
				if ($.trim(description.val()) == "")
				{
					description.siblings(".form-error").show();
					errors = true;
				}
				
				return !errors;
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

			$("#upload-file").each(function(){
				$(this).uploadify({
					swf           : 'swf/uploadify.swf',
					uploader      : '/controller/action',
					auto: false,
					width: 213,
					height: 32,
					buttonText: "Browse"
				});
			})
			
			$("#upload-cover-image").each(function(){
				$(this).uploadify({
					swf           : 'swf/uploadify.swf',
					uploader      : '/controller/action',
					auto: false,
					width: 35,
					height: 35,
					buttonText: "&nbsp;"
				});
			});			
			$("#sidebar-upload-cover-photo").each(function(){
				$(this).uploadify({
					swf           : 'swf/uploadify.swf',
					uploader      : '/controller/action',
					auto: false,
					width: 180,
					height: 20,
					buttonText: "Upload cover photo"
				});
			});			
			
			$("#upload-profile-image").each(function(){
				$(this).uploadify({
					swf           : 'swf/uploadify.swf',
					uploader      : '/controller/action',
					auto: false,
					width: 35,
					height: 35,
					buttonText: "&nbsp;"
				});
			});	
			$("#sidebar-upload-profile-photo").each(function(){
				$(this).uploadify({
					swf           : 'swf/uploadify.swf',
					uploader      : '/controller/action',
					auto: false,
					width: 180,
					height: 20,
					buttonText: "Upload profile photo"
				});
			});
			
			$("#ccs").each(function(){
				$(this).find(".list-scroll").show();
				$(this).find(".list").jScrollPane();
				console.log(this);
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
		};
		/* End Base Functions */
		
		(this.Init = function()
		{
			self = this;
			InitializeObjects();
			BindEvents();
			BuildSliders();
			SetWelcomeSlidesHeight();
		})();
	}
})(window);
