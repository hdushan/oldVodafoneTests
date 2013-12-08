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
