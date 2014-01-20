if document.location.hostname == "ballistiq.github.io"
  rootPath = "/parallax-demo"
else
  rootPath = ""

$ ->

  prettyPrint()

  padContent = ->
    windowHeight = $(window).height()
    $('.slide-content').each ->
      contentHeight = $(this).height()
      targetHeight = (windowHeight-contentHeight)/2;
      $(this).css('padding-top', targetHeight)
  padContent()

  $(window).resize(padContent)


  # Fixed background hack for iOS
  iOS = /(iPad|iPhone|iPod)/g.test( navigator.userAgent )
  if iOS
    $('.fixed-technique-slide').css('background-attachment', 'scroll')


  # Parallax Offset Technique
  if $('.offset-technique').length > 0
    offsetBackground = ->
      distanceFromTop = $(window).scrollTop()
      $("div[data-parallax-offset]").each ->
        offset = Math.round( - distanceFromTop * 0.2 )
        $(this).css('background-position', "50% #{offset}px")

    $(window).scroll ->
      offsetBackground()
    $(window).on 'touchmove', offsetBackground

  # Canvas Image Sequence Technique
  if $('#parallax-canvas').length > 0
    resizeCanvas = ->
      windowWidth = $(window).width()
      windowHeight = $(window).height()
      $('#parallax-canvas').attr('width', windowWidth).attr('height', windowHeight)
    resizeCanvas()
    $(window).resize(resizeCanvas)

    canvas = document.getElementById('parallax-canvas')
    context = canvas.getContext('2d')

    # Global current frame
    currentFrame = 1
    totalFrames = 112
    sequence = []

    # Render current frame
    renderCurrentFrame = ->
      offset = $(window).scrollTop()
      currentFrame = Math.round(offset / 40)
      if currentFrame >= totalFrames
        currentFrame = totalFrames - 1
      render(sequence[currentFrame])

    # render an image from the sequence
    render = (img) ->
      # Set image drawing
      windowWidth = $(window).width()
      windowHeight = $(window).height()
      windowAspectRatio = windowWidth / windowHeight
      videoWidth = 1920
      videoHeight = 1080
      videoAspectRatio = videoWidth / videoHeight

      if windowAspectRatio > videoAspectRatio
        w = windowWidth
        h = windowWidth / videoAspectRatio
      else
        w = videoAspectRatio * windowHeight
        h = windowHeight

      # Center the image
      x = -(w - windowWidth)/2
      context.drawImage(img, x, 0, w, h)

    # Load the image sequence into an array
    loadImageSequence = ->
      sequence = []
      for i in [1..totalFrames]
        img = new Image()
        num = ("0000" + i).slice(-4);
        file = "#{rootPath}/sequence/bbb_#{num}.jpg"
        img.src = file
        img.frame = i
        img.onload = ->
          loadedFrameCallback(this)
        sequence.push img
      return sequence

    loadedFrameCallback = (img) ->
      # Draw first frame
      if img.frame == 1
        render(img)

    # Load the sequence into an array
    sequence = loadImageSequence()

    # Bind rendering
    $(window).resize(renderCurrentFrame)
    $(window).scroll ->
      renderCurrentFrame()
    $(window).on 'touchmove', renderCurrentFrame

