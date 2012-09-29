class @EventManager
    constructor: () ->
        @listeners = {}

    addHandler: (event, callback) =>
        @listeners[event] or= []
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

class @InputManager
    # focus: a DOM object to pull input from
    constructor: (@focus) ->
        @keyStates = {}

        $(@focus).keyup(@onKeyUp)
        $(@focus).keydown(@onKeyDown)

    onKeyUp: (event) =>
        @keyStates[event.which] = false
        #TODO: propagate event here

    onKeyDown: (event) =>
        @keyStates[event.which] = true
        #TODO: propagate event here

    isKeyUp: (keyCode) =>
        # check key against false so undef doesn't throw false positives
        return (@keyStates[keyCode] == false) or false

    isKeyDown: (keyCode) =>
        return @keyStates[keyCode] or false

#OPTIMIZE: is instancing all of these new Vector objects slow?
class @Vector
    constructor: (@x = 0, @y = 0) ->

    zero: () =>
        @x = 0
        @y = 0

    #FIXME: use some form of method overloading instead (if it even exists)
    add: (arg) =>
        if arg instanceof Vector
            return new Vector(@x + arg.x, @y + arg.y)
        else
            return new Vector(@x + arg, @y + arg)

    multiply: (arg) =>
        if arg instanceof Vector
            return new Vector(@x * arg.x, @y * arg.y)
        else
            return new Vector(@x * arg, @y * arg)
