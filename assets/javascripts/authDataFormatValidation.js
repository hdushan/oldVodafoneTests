$(document).ready( function() {
  validateAuthDataFormat();
});

function validateAuthDataFormat(){

  $('#auth-form').on('submit', function(event) {
    event.preventDefault();

    if(validForm()) {
      $('#auth-format-validation').hide();
      this.submit();
    }
    else {
      $('#auth-format-validation').show();
      return false;
    }
  });
}

function validForm() {
  var emailId = 'form#auth-form input#email';
  var dobId = 'form#auth-form input#date-of-birth';

  if( $(emailId).val() === undefined) {
    return isValidDOB(dataEntered(dobId));
  }
  else {
    return isValidEmail(dataEntered(emailId));
  }
}

function isValidEmail(string) {
  var emailFormat = /^[-0-9a-zA-Z.+_]+@[-0-9a-zA-Z.+_]+\.[a-zA-Z]{2,4}$/;
  return emailFormat.test(string);
}

function dataEntered(idString) {
  return $.trim( $(idString).val() );
}

function parsedDateString(dateString) {
  return moment(dateString, ['DD/MM/YYYY', 'YYYY-MM-DD'], true);
}
function isFuture(dateString) {
  return parsedDateString(dateString).isAfter();
};

function isInDateFormat(dateString) {
  return parsedDateString(dateString).isValid();
};

function isValidDOB(dateString) {
  return isInDateFormat(dateString)
      && !isFuture(dateString);
};

