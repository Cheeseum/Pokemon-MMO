class @EventManager
    constructor: () ->
        @listeners = {}

     addHandler: (event, callback) =>
        @listeners[event] = [] if ! @listeners[event]
        @listeners[event].push(callback)

    dispatchEvent: (event, data...) =>
        l(data...) for l in @listeners[event]

class @GraphicsContext
    constructor: (@canvas) ->
        @context = @canvas.getContext("2d")
   
    # Clears the visible canvas area.
    clearScreen: () =>
        @context.save()
        @context.setTransform(1, 0, 0, 1, 0, 0)
        @context.clearRect(0, 0, @canvas.width, @canvas.height)
        @context.restore()
