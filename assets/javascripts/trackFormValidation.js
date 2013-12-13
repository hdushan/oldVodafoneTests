$(document).ready( function() {
  validateTrackForm();
});

function validateTrackForm() {
  $('#track-form').on('submit', function(event) {
    $('#track-form .alert').hide();

    event.preventDefault();

    var order_id = order_id_entered();

    if(isValidOrderId(order_id)) {
      showLoadingImage();
      this.submit();
    }
    else {
      $( "#input-validation-msg" ).show();
      shakeForm();
      return false;
    }  
  });
}; 

function showLoadingImage() {
  $('#loading').show();
  $('#track-form').hide();

  //needed for gif to animate in ie8 and ie9
  $('#ie-loader').html($('#ie-loader').html());
};

// TODO make nice animation
function shakeForm() {
  var p = new Array(-15, 15, -15, 15, -15, 15, -15, 15);  

  for( var i = 0; i < 8; i++ )   
    $( "#input-validation-msg" ).animate( { 'margin-left': "+=" + p[i] + 'px' }, 50);  
};