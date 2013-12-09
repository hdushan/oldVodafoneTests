function showLoadingImage(){
  
  $('#loading').show();
  $('#track-form').hide();

}


$(document).ready( function(){
  
  $('#track-form').submit(showLoadingImage);

});