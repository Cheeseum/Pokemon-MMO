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

# statically declared Base64 utility class
class @Base64
    @encode = (data) =>
        return btoa(data) if typeof btoa === "function"

        console.err("FIXME: Non-native Base64 encoding not implemented!")
            
    @decode = (data) =>
        return atob(data) if typeof atob === "function"

        console.err("FIXME: Non-native Base64 decoding not implemented!")

    # decode a Base64 string into an array with elements of size "bytes"
    @decodeAsArray = (data, bytes) =>
        d_data = @decode(data)
        out = []

        for i in [0..((d_data.length / bytes) - 1)]
            out[i] = 0

            for j in [(bytes - 1)..0]
                out[i] += d_data.charCodeAt((i * bytes) + j) << (j << 3)

        return out
