//NavMenu = ->
//    nav_menu_button = $('.vca-layout-mobile .nav-trigger')
//mask = $('.vca-layout-mobile .mask')
//
//display_or_hide_the_nav_menu = ->
//    search_application_container.toggleClass 'search-application-mobile-nav-menu-displayed'
//
//    [nav_menu_button, mask].forEach (element) ->
//element.on('click', display_or_hide_the_nav_menu)

$(document).ready( function(){




  $('.vca-layout-mobile .nav-trigger').on('click', function () {
    $('.container').toggleClass('search-application-mobile-nav-menu-displayed');
  });

  $('.vca-layout-mobile .mask').on('click', function () {
    $('.container').toggleClass('search-application-mobile-nav-menu-displayed'); // TODO finish porting mobile menu
  });

});

