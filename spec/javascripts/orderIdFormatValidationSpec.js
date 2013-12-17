describe('Validation order id input text', function() {

  describe('order id entered', function() {
    it('should trim leading and trailing whitespace', function() {
      affix('input#tracking_id[value="     kitty     "]');
      var order_id = order_id_entered();
      expect(order_id).toBe('kitty');
    });
  });

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

  describe('with correct prefix', function() {

    beforeEach( function(){
      var $container = affix('div');
      $container.affix('form#track-form input#tracking_id');
      $container.affix('#input-validation-msg.hidden[style="display: block"]');

      validateTrackIdFormat();
    });

    it("should hide validation error when correct 'VF' format is entered", function() {
      $('#tracking_id').val('VF1');
      $('#tracking_id').trigger('change');
      expect($('#input-validation-msg').is(':visible')).toBe(false);
    });

    it("should hide validation error when correct 'UP' format is entered", function() {
      $('#tracking_id').val('UP1');
      $('#tracking_id').trigger('change');
      expect($('#input-validation-msg').is(':visible')).toBe(false);
    });
    
    it("should hide validation error when correct 'SR1-' format is entered", function() {
      $('#tracking_id').val('SR1-1');
      $('#tracking_id').trigger('change');
      expect($('#input-validation-msg').is(':visible')).toBe(false);
    });
  
    it("should hide validation error when correct '1-' format is entered", function() {
      $('#tracking_id').val('1-1');
      $('#tracking_id').trigger('change');
      expect($('#input-validation-msg').is(':visible')).toBe(false);
    });

    it("should accept case insensitive input", function() {
      $('#tracking_id').val('vF123');
      $('#tracking_id').trigger('change');
      expect($('#input-validation-msg').is(':visible')).toBe(false);
    });
    
    it("should accept order id with only 1 alphanumerical character after prefix", function() {
      $('#tracking_id').val('1-z');
      $('#tracking_id').trigger('change');
      expect($('#input-validation-msg').is(':visible')).toBe(false);
    });

    it("should accept order id with maximum length of 15 characters (prefix included)", function() {
      $('#tracking_id').val('VF3456789012345');
      $('#tracking_id').trigger('change');
      expect($('#input-validation-msg').is(':visible')).toBe(false);
    });

  });

  describe('with prefix but wrong format', function() {
    
    beforeEach( function(){
      var $container = affix('div');
      $container.affix('form#track-form input#tracking_id');
      $container.affix('#input-validation-msg.hidden[style="display: block"]');

      validateTrackIdFormat();
    });

    it("should show validation error when order id contains special characters", function() {
      $('#tracking_id').val('VF123@$');
      $('#tracking_id').trigger('change');
      expect($('#input-validation-msg').is(':visible')).toBe(true);
    });

    it("should show validation error when order id is too long (more than 15 characters prefix included)", function() {
      $('#tracking_id').val('VF34567890123456');
      $('#tracking_id').trigger('change');
      expect($('#input-validation-msg').is(':visible')).toBe(true);
    });
  });

});
