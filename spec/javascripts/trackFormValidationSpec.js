describe("Show loading on form submit", function() {

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



describe("form validation", function() {

  beforeEach( function() {      
    var $container = affix('div');
    $container.affix('form#track-form[action="/track"] input#tracking_id');
    $container.affix('#input-validation-msg.hidden[style="display: none"]');
    validateTrackForm();
  });

  describe("When the order id is empty and I click on submit", function() {

    it ("should display the error message", function() {
      $('#track-form').trigger('submit');    

      var validationMessageAfter = $('#input-validation-msg').is(':visible');
      expect(validationMessageAfter).toBe(true);
    });

  });

  describe("When the order id is invalid and I click on submit", function() {

    

    it ("should display the error message", function() {
      $('#tracking_id').val('invalid_id');
      $('#track-form').trigger('submit');    

      var validationMessageAfter = $('#input-validation-msg').is(':visible');
      expect(validationMessageAfter).toBe(true);
    });

  });

  describe("When the order id is valid and I click on submit", function() {


    xit ("should submit the form", function() {
      $('#tracking_id').val('VF123');
      $('#track-form').trigger('submit');    
      var validationMessageAfter = $('#input-validation-msg').is(':visible');
      expect(validationMessageAfter).toBe(false);
    });

  });
});



