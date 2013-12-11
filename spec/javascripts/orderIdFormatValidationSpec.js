describe('Validation order id input text', function() {

  describe('show validation message', function() {

    beforeEach( function(){
      var $container = affix('div');
      $container.affix('form#track-form input#tracking_id');
      $container.affix('#input-validation-msg.hidden[style="display: none"]');

      var validationMessageBefore = $('#input-validation-msg').is(':visible');
      expect(validationMessageBefore).toBe(false);

      validateTrackIdFormat();
    });

    it("when wrong format is entered", function() {
      $('#tracking_id').val('random');
      $('#tracking_id').trigger('keyup');

      var validationMessageAfter = $('#input-validation-msg').is(':visible');
      expect(validationMessageAfter).toBe(true);
    });

    it("when wrong format is pasted or pre-filled", function() {
      $('#tracking_id').val('random');
      $('#tracking_id').trigger('change');

      var validationMessageAfter = $('#input-validation-msg').is(':visible');
      expect(validationMessageAfter).toBe(true);
    });
  });

  describe('hide validation message', function() {

    beforeEach( function(){
      var $container = affix('div');
      $container.affix('form#track-form input#tracking_id');
      $container.affix('#input-validation-msg.hidden[style="display: block"][value="kitty"]');

      validateTrackIdFormat();
    });

    it('when input back spaced to empty', function() {
      $('#tracking_id').val('');
      $('#tracking_id').trigger('change');

      expect($('#input-validation-msg').is(':visible')).toBe(false);
    });

  });

  describe('with VF prefix', function() {

    beforeEach( function(){
      var $container = affix('div');
      $container.affix('form#track-form input#tracking_id');
      $container.affix('#input-validation-msg.hidden[style="display: block"]');

      validateTrackIdFormat();
    });

    it("should hide validation error when correct format is entered", function() {
      $('#tracking_id').val('VF');
      $('#tracking_id').trigger('change');
      expect($('#input-validation-msg').is(':visible')).toBe(false);
    });

  });

});
