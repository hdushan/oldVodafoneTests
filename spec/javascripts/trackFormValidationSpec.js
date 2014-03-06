describe('#showLoadingImage', function() {

  beforeEach( function(){
    var $container = affix('div');
    $container.affix('form#track-form button#trace');
    $container.affix('#loading.hidden[style="display: none"]');
  });

  it("should show loading image", function() {
    var loadingImageIsVisibleBefore = $('#loading').is(':visible');
    expect(loadingImageIsVisibleBefore).toBe(false);

    showLoadingImage();
    var loadingImageIsVisibleAfter = $('#loading').is(':visible');
    expect(loadingImageIsVisibleAfter).toBe(true);

  });

  it("should hide the form", function() {
    showLoadingImage();
    var formIsVisibleAfter = $('form#track-form').is(':visible');
    expect(formIsVisibleAfter).toBe(false);

  });

});

describe('server error message', function() {

    beforeEach( function() {
        var $container = affix('div');
        $container.affix('form#track-form input#tracking_id');
        $container.affix('#server-error-msg[style="display: block"]');

        var validationMessageBefore = $('#server-error-msg').is(':visible');
        expect(validationMessageBefore).toBe(true);

        hideServerErrorMsg();
    });

    it('should be hidden when user start typing in the track id', function() {
        $('#tracking_id').trigger('keyup');

        var validationMessageAfter = $('#server-error-msg').is(':visible');
        expect(validationMessageAfter).toBe(false);
    });
});

describe("form validation on submit", function() {

  beforeEach( function() {
    var $container = affix('div');
    $container.affix('form#track-form[action="/track"] input#tracking_id');
    $container.affix('#input-validation-msg.hidden[style="display: none"]');
    $container.affix('#server-error-msg[style="display: block"]');
    validateTrackForm();
  });

  describe('with empty track id', function() {

    it ('should display the error message', function() {
      $('#track-form').trigger('submit');

      var validationMessageAfter = $('#input-validation-msg').is(':visible');
      expect(validationMessageAfter).toBe(true);
    });

  });

  describe('with invalid track id', function() {

    it ('should display the error message', function() {
      $('#tracking_id').val('invalid_id');
      $('#track-form').trigger('submit');

      var validationMessageAfter = $('#input-validation-msg').is(':visible');
      expect(validationMessageAfter).toBe(true);
    });

  });

  it('should hide the server error', function() {
    $('#track-form').trigger('submit');

    var validationMessageAfter = $('#server-error-msg').is(':visible');
    expect(validationMessageAfter).toBe(false);
  });
});
