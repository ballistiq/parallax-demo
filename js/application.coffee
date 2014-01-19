if document.location.hostname == "ballistiq.github.io"
  rootPath = "/parallax-demo"
else
  rootPath = ""

$ ->

  padContent = ->
    windowHeight = $(window).height()
    $('.slide-content').each ->
      contentHeight = $(this).height()
      targetHeight = (windowHeight-contentHeight)/2;
      $(this).css('padding-top', targetHeight)
  padContent()

  $(window).resize(padContent)

  # Parallax Offset Technique
  if $('.offset-technique').length > 0
    $(window).scroll ->
      distanceFromTop = $(window).scrollTop()
      $("div[data-parallax-offset]").each ->
        offset = Math.round( - distanceFromTop * 0.2 )
        $(this).css('background-position', "50% #{offset}px")

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
      render(sequence[currentFrame])

    # render an image from the sequence
    render = (img) ->
      console.log "Rendering frame: #{img.frame}, #{img.src}"

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
          console.log "Loaded frame #{this.frame}"
          loadedFrameCallback(this)
        sequence.push img
      return sequence

    loadedFrameCallback = (img) ->
      # Draw first frame
      if img.frame == 1
        render(img)

    # Load the sequence into an array
    sequence = loadImageSequence()

    $(window).resize(renderCurrentFrame)

    $(window).scroll ->
      offset = $(window).scrollTop()
      console.log "Offset: #{offset}"
      currentFrame = Math.round(offset / 30)
      renderCurrentFrame()


