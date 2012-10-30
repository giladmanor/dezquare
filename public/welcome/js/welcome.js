$(document).ready(function(){

	var e = event
	var pass = 'Y3dQ7K'
  
$(window).keydown(function(e){
    if(e.keyCode == 13) {
      e.preventDefault();
      return false;
    }
  });

$('span#pop_error').hide();
$('.button-welcome').click (function(e){
	$('span#pop_error').hide();
	
	if ($('input').val() != (pass))
	{
		$('span#pop_error').show();
	}
	if ($('input').val() === (pass)) {
		window.location = "/site/index?k=kjsnidu";
	}
	return false;
  });
});