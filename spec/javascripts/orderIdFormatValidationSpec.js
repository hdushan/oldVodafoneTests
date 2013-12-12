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
      $('#tracking_id').val('VF1');
      $('#tracking_id').trigger('change');
      expect($('#input-validation-msg').is(':visible')).toBe(false);
    });

    it("should show validation error when order id does not have at least one numeric digit", function() {
      $('#tracking_id').val('VFnodigits');
      $('#tracking_id').trigger('change');
      expect($('#input-validation-msg').is(':visible')).toBe(true);
    });

    it("should accept not case sensitiv input", function() {
      $('#tracking_id').val('vF123');
      $('#tracking_id').trigger('change');
      expect($('#input-validation-msg').is(':visible')).toBe(false);
    });

    it("should show validation error when order id is to long", function() {
      $('#tracking_id').val('VF34567890123456');
      $('#tracking_id').trigger('change');
      expect($('#input-validation-msg').is(':visible')).toBe(true);
    });
  });

describe('with SR1- prefix', function() {

    beforeEach( function(){
      var $container = affix('div');
      $container.affix('form#track-form input#tracking_id');
      $container.affix('#input-validation-msg.hidden[style="display: block"]');

      validateTrackIdFormat();
    });

    it("should hide validation error when correct format is entered", function() {
      $('#tracking_id').val('SR1-1');
      $('#tracking_id').trigger('change');
      expect($('#input-validation-msg').is(':visible')).toBe(false);
    });

    it("should show validation error when order id does not have at least one numeric digit", function() {
      $('#tracking_id').val('SR1-nodigits');
      $('#tracking_id').trigger('change');
      expect($('#input-validation-msg').is(':visible')).toBe(true);
    });

    it("should accept not case sensitiv input", function() {
      $('#tracking_id').val('Sr1-123');
      $('#tracking_id').trigger('change');
      expect($('#input-validation-msg').is(':visible')).toBe(false);
    });

    it("should show validation error when order id is to long", function() {
      $('#tracking_id').val('SR1-567890123456');
      $('#tracking_id').trigger('change');
      expect($('#input-validation-msg').is(':visible')).toBe(true);
    });
  });

});
