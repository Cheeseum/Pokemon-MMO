class @Game
    init: () =>
        @world = new World()
        @world_renderer = new WorldRenderer(@world)

        # FIXME: decouple this canvas object dependency
        @graphics = new GraphicsContext($("#main-canvas").get(0))
        @input = new InputManager(window)

        @old_time = @new_time = 0
        @t = @accumulator = 0.0
        @dt = 0.01

    run: () =>
        # usage example
        e = new Entity()
        for c of OBJECTS["player"]
            e.addComponent(c, new window.OBJECTS["player"][c])

        i.input = @input for i in e.getComponents("input")

        @world.addEntity(e)

        @update()
        @draw()

    update: () =>
        # ye olde framerate independent gameloop
        @new_time = Date.now() / 1000
        @accumulator += Math.min(0.25, @new_time - @old_time)
        @old_time = @new_time

        while @accumulator >= @dt
            @accumulator -= @dt

            @world.update(@t, @dt)
            
            @t += @dt

        # run loop again asap
        window.setTimeout(@update, 0)

    draw: () =>
        # request another draw call asap
        window.requestAnimFrame(@draw)

        # clear the visible screen
        @graphics.clearScreen()

        # TODO: draw menus here
        # TODO: implement camera
    
        # draw the game
        @world_renderer.draw(@graphics)

        # TODO: fps counter
