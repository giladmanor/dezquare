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
		var game3, submitGame3, nothingSelectedPopup, submitSelectedPopup, markCompletePopup, newClientPopup, rejectProjectPopup;
		var changeFlyerFlag = false;
		
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
				
				slider.slider({
					range: "min",
					value: 105,
					min: 0,
					max: 140,
					slide: function( event, ui ) {
						priceSliderTooltipInput.val( "$" + ui.value );
					},
					create: function(event, ui) {
						slider.find(".ui-slider-handle").append(priceSliderTooltip);
					}
				});
				priceSliderTooltipInput.val( "$" + priceSlider.slider( "value" ) );
			});
		};
		
		function BindLanguageEvents(field)
		{
			field.find(".list .option").click(function(){
				if (!field.find(".remove").is(":visible"))
				{
					var clone = field.clone();
					field.after(clone);
					BindLanguageEvents(clone);
					BindComboboxEvents(clone.find(".combobox"));
					field.find(".button").hide();
					field.find(".remove").show();
					field.parent().find(".list").hide();
				}					
			});
			field.find(".remove").click(function(){
				field.remove();
			});
			field.find(".add").click(function(){
				var clone = field.clone();
				field.parent().append(clone);
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
			var list = combobox.children("div.list");
			var value = combobox.children("div.value");
			var input = combobox.children("input");
			list.children("div.option").click(function(){
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
			game3 = $("#game-step-3");
			submitGame3 = game3.find("#submit");
			nothingSelectedPopup = $("#nothing-selected-popup");
			submitSelectedPopup = $("#submit-selected-popup");
			markCompletePopup = $("#mark-complete-popup");
			portfolioGallery = $("#portfolio-gallery");
			newClientPopup = $("#new-client-popup")
			rejectProjectPopup = $("#reject-project-popup");
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
			
			$("div.combobox").each(function(){
				BindComboboxEvents($(this));
			});
			
			$("a.cancel-design").click(function(e){
				e.preventDefault();
				overlay.show();
				cancelDesignPopup.show();
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
			
			$("#game-step-1 ul.icons a").click(function(e){
				e.preventDefault();
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
				submitGame3.removeClass("disabled");
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
				}
				else
				{
					overlay.show();
					submitSelectedPopup.show();
				}
			});
			
			nothingSelectedPopup.find("a.orange-button").click(function(e){
				e.preventDefault();
				nothingSelectedPopup.hide();
				overlay.hide();
			});
			
			submitSelectedPopup.find("a.replay").click(function(e){
				e.preventDefault();
				submitSelectedPopup.hide();
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
				BindLanguageEvents(field)
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
		};
		/* End Base Functions */
		
		(this.Init = function()
		{
			self = this;
			InitializeObjects();
			BindEvents();
			BuildSliders();
		})();
	}
})(window);
