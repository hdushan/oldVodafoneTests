describe('validateAuthDataFormat', function () {

  describe('isValidEmail', function () {
    it('should accept format in anything@anything.com', function () {
      var validEmail = isValidEmail('anything@anthing.com');
      expect(validEmail).toBe(true);
    });

    it('should not accept email without "@"', function () {
      var validEmail = isValidEmail('anthing.com');
      expect(validEmail).toBe(false);
    });

    it('should not accept email without "." after "@"', function () {
      var validEmail = isValidEmail('any.thing@anything');
      expect(validEmail).toBe(false);
    });
  });

  describe('isValidDOB', function () {
    it('should accept both format of DD/MM/YYYY and YYYY-MM-DD', function () {
      var aussieFormat = isValidDOB('30/12/1988');
      var isoFormat = isValidDOB('1988-12-30');
      var bothValid = aussieFormat && isoFormat;
      expect(bothValid).toBe(true);
    });

    it('should accept date with single digit day or month', function () {
      var aussieFormat = isValidDOB('1/9/1988');
      var isoFormat = isValidDOB('1988-9-1');
      var bothValid = aussieFormat && isoFormat;
      expect(bothValid).toBe(true);
    });

    it('should not accept dates in wrong format', function () {
      var aussieFormat = isValidDOB('3d/12/1988');
      var isoFormat = isValidDOB('1988-12-3d');
      var eitherIsValid = aussieFormat || isoFormat;
      expect(eitherIsValid).toBe(false);
    });

    it('should not accept future dates', function () {
      var aussieFormat = isValidDOB('30/12/3988');
      var isoFormat = isValidDOB('3988-12-30');
      var eitherIsValid = aussieFormat || isoFormat;
      expect(eitherIsValid).toBe(false);
    });

    it('should not accept dates when day is bigger ten 31', function () {
      var aussieFormat = isValidDOB('32/12/1988');
      var isoFormat = isValidDOB('1988-12-32');
      var eitherIsValid = aussieFormat || isoFormat;
      expect(eitherIsValid).toBe(false);
    });

    it('should not accept dates when month is bigger ten 12', function () {
      var aussieFormat = isValidDOB('32/13/1988');
      var isoFormat = isValidDOB('1988-13-32');
      var eitherIsValid = aussieFormat || isoFormat;
      expect(eitherIsValid).toBe(false);
    });

  });

  describe('form submit with', function () {
    describe('email field', function () {
      beforeEach(function () {
        var $container = affix('div');
        $container.affix('form#auth-form input#email');
        $container.affix('#auth-format-validation.hidden[style="display: none"]');

        validateAuthDataFormat();
      });

      it('should not submit form for invalid email', function () {
        $('form#auth-form input#email').val('kitty');

        $('#auth-form').trigger('submit');
        expect($('#auth-format-validation').is(':visible')).toBe(true);
      });

      it('should accept email with leading and trailing whitespace', function () {
        $('form#auth-form input#email').val('    abc@example.com    ');
        spyOn(window, 'isValidEmail');

        $('#auth-form').trigger('submit');
        expect(window.isValidEmail).toHaveBeenCalledWith('abc@example.com');
      });

    });

    describe('date of birth field', function () {
      beforeEach(function () {
        var $container = affix('div');
        $container.affix('form#auth-form input#date-of-birth');
        $container.affix('#auth-format-validation.hidden[style="display: none"]');

        validateAuthDataFormat();
      });

      it('should not submit form with invalid date of birth', function () {
        $('form#auth-form input#date-of-birth').val('kitty');

        $('#auth-form').trigger('submit');
        expect($('#auth-format-validation').is(':visible')).toBe(true);
      });

    });

  });

});
