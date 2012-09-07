# Initialization Code

# bind to the global jQuery object
$ =>
    game = new @Game()
    
    game.init()
    game.run()
