$(document).ready( function() {
  validateEmailFormat();
});

function validateEmailFormat(){

  $('#auth-form').on('submit', function(event) {
    event.preventDefault();

    if(isValidEmail(emailEntered())) {
      this.submit();
    }
    else {
      $('#email-format-validation').show();
      return false;
    }
  });
}

function isValidEmail(string) {
  var emailFormat = /^\S+@\S+\.\S+$/i;
  return emailFormat.test(string);
}

function emailEntered() {
  return $.trim( $('form#auth-form input#email').val() );
}
