function showLoadingImage(){

  $('#loading').show();
  $('#track-form').hide();

  //needed for gif to animate in ie8 and ie9
  $('#ie-loader').html($('#ie-loader').html());

}


$(document).ready( function(){
  
  $('#track-form').submit(showLoadingImage);

});