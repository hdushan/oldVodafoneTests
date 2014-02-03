describe('Validation order id input text', function() {

  describe('#order_id_entered', function() {

    it('should trim leading and trailing whitespace', function() {
      affix('input#tracking_id[value="     kitty     "]');
      var order_id = order_id_entered();
      expect(order_id).toBe('kitty');
    });

  });

  describe('#isValidOrderId', function() {

    it('should accept id with "VF" prefix', function() {
      var validId = isValidOrderId('VF1');
      expect(validId).toBe(true);
    });

    it('should accept id with "UP" prefix', function() {
      var validId = isValidOrderId('UP1');
      expect(validId).toBe(true);
    });

    it('should accept id with "SR1-" prefix', function() {
      var validId = isValidOrderId('SR1-1');
      expect(validId).toBe(true);
    });

    it('should accept id with "1-" prefix', function() {
      var validId = isValidOrderId('1-1');
      expect(validId).toBe(true);
    });

    it('should accept case insensitive input', function() {
      var validId = isValidOrderId('vF123');
      expect(validId).toBe(true);
    });

    it('should accept order id with only 1 alphanumerical character after prefix', function() {
      var validId = isValidOrderId('1-z');
      expect(validId).toBe(true);
    });

    it('should accept order id with maximum length of 15 characters (prefix included)', function() {
      var validId = isValidOrderId('VF3456789012345');
      expect(validId).toBe(true);
    });

    it("should not accept order id contains special characters", function() {
      var validId = isValidOrderId('VF123@$');
      expect(validId).toBe(false);
    });

    it("should not accept order id that is too long (more than 15 characters prefix included)", function() {
      var validId = isValidOrderId('VF34567890123456');
      expect(validId).toBe(false);
    });

  });

});
