$ ->

  padContent = ->
    windowHeight = $(window).height();
    $('.slide-content').each ->
      contentHeight = $(this).height();
      targetHeight = (windowHeight-contentHeight)/2;
      $(this).css('padding-top', targetHeight)
  padContent()

  $(window).resize(padContent)