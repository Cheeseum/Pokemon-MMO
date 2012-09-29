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

        # The position of the object in grid coordinates (whole integer)
        # Always updated BEFORE the real position
        @gridpos = new Vector()

        # A normalized (equal to +/-1) velocity vector in x and y
        @velocity = new Vector()

    update: (t, dt) =>
        @object.pos = @object.pos.add(@velocity.multiply(dt))

        # Moving left,right,up,down and overshot the grid square
        if (@velocity.x < 0 and @object.pos.x <= @gridpos.x) or
           (@velocity.x > 0 and @object.pos.x >= @gridpos.x) or
           (@velocity.y > 0 and @object.pos.y >= @gridpos.y) or
           (@velocity.y < 0 and @object.pos.y <= @gridpos.y)

            @moving = false
            @velocity.zero()
            @object.pos = @gridpos

    move: (direction) =>
        return if @moving

        @moving = true
        @velocity.zero()

        switch(direction)
            when DIR.UP    then @velocity.y = -1
            when DIR.DOWN  then @velocity.y = 1
            when DIR.RIGHT then @velocity.x = 1
            when DIR.LEFT  then @velocity.x = -1

        @gridpos = @gridpos.add(@velocity)

class @InputComponent extends @Component
     constructor: (@input) ->

class @PlayerInputComponent extends @InputComponent
    # FIXME: This can be done WAY better, will rework this later
    update: (t, dt) =>
        dir = 0

        # FIXME: this is stupid
        if @input.isKeyDown(KEY.UP)
            dir = DIR.UP
        else if @input.isKeyDown(KEY.DOWN)
            dir = DIR.DOWN
        else if @input.isKeyDown(KEY.LEFT)
            dir = DIR.LEFT
        else if @input.isKeyDown(KEY.RIGHT)
            dir = DIR.RIGHT

        if (dir)
            physics.move(dir) for physics in @object.getComponents("physics")
