describe('Validate email address entered', function() {

  describe('isValidEmail', function() {
    it('should accept format in anything@anything.com', function() {
      var validEmail = isValidEmail('anything@anthing.com');
      expect(validEmail).toBe(true);
    });

    it('should not accept email without "@"', function() {
      var validEmail = isValidEmail('anthing.com');
      expect(validEmail).toBe(false);
    });

    it('should not accept email without "." after "@"', function() {
      var validEmail = isValidEmail('any.thing@anything');
      expect(validEmail).toBe(false);
    });
  });


  describe('validateEmailFormat', function() {
    beforeEach( function(){
      var $container = affix('div');
      $container.affix('form#auth-form input#email');
      $container.affix('#email-format-validation.hidden[style="display: block"]');

      validateEmailFormat();
    });

    it('should not submit form for invalid email', function() {
      $('form#auth-form input#email').val('kitty');

      $('#auth-form').trigger('submit'); 
      expect($('#email-format-validation').is(':visible')).toBe(true);
    });

    it('should accept email with leading and trailing whitespace', function() {
      $('form#auth-form input#email').val('    abc@example.com    ');
      spyOn(window, 'isValidEmail')

      $('#auth-form').trigger('submit'); 
      expect(window.isValidEmail).toHaveBeenCalledWith('abc@example.com');
    });

  });
});
