$(document).ready( function(){

  $('.vca-layout-mobile .nav-trigger').on('click', function () {
    $('.container').toggleClass('mobile-nav-menu-displayed');
  });

  $('.vca-layout-mobile .mask').on('click', function () {
    $('.container').toggleClass('mobile-nav-menu-displayed');
  });

  $('.vca-layout-mobile .nav-search').on('click', function () {
    var search_bar_element = $('.vca-layout-mobile .search-bar');
    debugger;
    var computed_style = window.getComputedStyle(search_bar_element[0], null);
    var display_value = computed_style.getPropertyValue('display');
    search_bar_element[0].style.display = (display_value == 'none' ? 'block' : 'none');
  });
});

