# FIXME: add a parent Component class maybe?
# FIXME: make these more "data driven" and less inheritance based
# FIXME: maybe rename "object" to container

class @Component
    constructor: () ->
        @object = null

    update: (t, dt) =>
        return

class @RenderComponent extends @Component
    render: (g) =>
        return

# A physics component should have a move(direction) functions
class @TilePhysicsComponent extends @Component
    constructor: () ->
        @moving = false

        @realpos = new Vector()
        @velocity = new Vector()

    update: (t, dt) =>
        #TODO; tile smoothing

    move: (direction) =>
        
        @velocity.zero()

        switch(direction)
            when @DIR.UP    then @velocity.y = 1
            when @DIR.DOWN  then @velocity.y = -1
            when @DIR.RIGHT then @velocity.x = 1
            when @DIR.LEFT  then @velocity.x = -1

class @InputComponent extends @Component
     constructor: (@input) ->

class @PlayerInputComponent extends @InputComponent
    # FIXME: This can be done WAY better, will rework this later
    update: (t, dt) =>
        dir = 0

        # FIXME: this is stupid
        # FIXME: also it doesn't work since `this` for some reason
        # since ends up pointing to `PlayerInputComponent`
        if @input.isKeyDown(@KEY.UP)
            dir = @DIR.UP
        else if @input.isKeyDown(@KEY.DOWN)
            dir = @DIR.DOWN
        else if @input.isKeyDown(@KEY.LEFT)
            dir = @DIR.LEFT
        else if @input.isKeyDown(@KEY.RIGHT)
            dir = @DIR.RIGHT

        if (dir)
            physics.move(dir) for physics in @object.getComponents("physics")
