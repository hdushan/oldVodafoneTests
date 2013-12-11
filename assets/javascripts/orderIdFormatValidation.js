function validateTrackIdFormat(){

  $('#tracking_id').on('keyup change', function(){
    var track_id = $('#tracking_id').val();

    if( track_id == '' ) {
      $('#input-validation-msg').hide();
    }
    else
    {
      if( track_id.match(/^VF/) ) {
        $('#input-validation-msg').hide();
      }
      else
      {
        $('#input-validation-msg').show();
      }
    }
  });

}

$(document).ready( function(){

  validateTrackIdFormat();

});
