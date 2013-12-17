function validateTrackIdFormat(){

  $('#tracking_id').on('keyup change', function() {
    $('#track-form .alert').hide();
    var order_id = order_id_entered();

    if( order_id == '' || isValidOrderId(order_id) ) {
      $('#input-validation-msg').hide();
    }
    else {
      $('#input-validation-msg').show();
    }
  });

}

function isValidOrderId(order_id) {
  var order_id_format = /^(VF|UP|1-|SR1-)[a-zA-Z0-9]+$/i;
  return order_id.length <= 15 && order_id.match(order_id_format);
}

function order_id_entered() {
  return $.trim( $("#tracking_id").val());
}

$(document).ready( function(){

  validateTrackIdFormat();

});