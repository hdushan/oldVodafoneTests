$(document).ready(function () {
    setupValidateTrackFormFunction();
    setupHideErrorMessagesFunction();
});

function setupHideErrorMessagesFunction() {
    $('#tracking_id').on('keypress', function (key) {
            if (key.which !== 13) {
                $('#server-error-msg').hide();
                $('#input-validation-msg').hide();
            }
        }
    );
}

function setupValidateTrackFormFunction() {
    $('#track-form').on('submit', function (event) {
        $('#input-validation-msg').hide();
        $('#server-error-msg').hide();
        $('#track-form .alert').hide();

        event.preventDefault();

        var order_id = orderIdEntered();

        if (isValidOrderId(order_id)) {
            showLoadingImage();
            this.submit();
        } else {
            $("#input-validation-msg").fadeIn();
            return false;
        }
    });
}

function showLoadingImage() {
    $('#loading').show();
    $('#track-form').hide();

    //needed for gif to animate in ie8 and ie9
    $('#ie-loader').html($('#ie-loader').html());
}

