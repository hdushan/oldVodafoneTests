function reloadWhenBackButtonPressOnSafari() {
  var isSafari = navigator.userAgent.indexOf('Safari') != -1 && navigator.userAgent.indexOf('Chrome') == -1;

  if(isSafari) {
    window.onpageshow = function(event) {
      if (event.persisted) {
        window.location.reload() 
      }
    };
  }
}

reloadWhenBackButtonPressOnSafari();
