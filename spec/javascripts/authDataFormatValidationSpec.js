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
    it('should not accept dates in wrong format', function () {
      var validDOB = isValidDOB('2021-08-1d');
      expect(validDOB).toBe(false);
    });

    it('should not accept future dates', function () {
      var validDOB = isValidDOB('3001-08-11');
      expect(validDOB).toBe(false);
    });


    it('should not accept dates when day is bigger ten 31', function () {
      var validDOB = isValidDOB('1990-08-32');
      expect(validDOB).toBe(false);
    });

    it('should not accept dates when month is bigger ten 12', function () {
      var validDOB = isValidDOB('1990-13-31');
      expect(validDOB).toBe(false);
    });

    it('should not accept years below 1800', function () {
      var validDOB = isValidDOB('1799-08-31');
      expect(validDOB).toBe(false);
    });

    it('should accept correct date', function () {
      var validDOB = isValidDOB('1990-08-31');
      expect(validDOB).toBe(true);
    });

    it('should accept date with single digit day or month', function () {
      var validDOB = isValidDOB('1990-1-1');
      expect(validDOB).toBe(true);
    });

    it('should parse date correctly', function () {
      var date = parsedDate({year: 1990, month: 11, day: 20});
      var expectedDate = new Date('1990/11/20');
      expect(date).toEqual(expectedDate);
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
