function showLoadingImage(){
  
  $('#loading_img').show();
  $('#track-form').hide();

}


$(document).ready( function(){
  
  $('#track-form').submit(showLoadingImage);

});