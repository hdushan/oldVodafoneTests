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

function extractDate(dateString) {
  var parts = dateString.split('-');
  var year = parseInt(parts[0]);
  var month = parseInt(parts[1]);
  var day = parseInt(parts[2]);
  return {year: year, month: month, day: day};
};

function parsedDate(dateHash) {
  return new Date(dateHash.year, dateHash.month - 1, dateHash.day);
}

function isFuture(date) {
  var now = new Date();
  return parsedDate(date) > now;
};

function isInDateFormat(dateString) {
  var dobFormat = /^\d{4}-\d{1,2}-\d{1,2}$/;
  return dobFormat.test(dateString)
};

function isInCorrectRange(date) {
  return date.day <= 31 && date.month <= 12 && date.year >= 1800;
};

function isValidDOB(dateString) {
  var date = extractDate(dateString);
  return isInDateFormat(dateString)
      && !isFuture(date)
      && isInCorrectRange(date);
};

