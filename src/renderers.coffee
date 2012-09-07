class @WorldRenderer
    constructor: (@world) ->
        @renderers = []

        @world.event_manager.addHandler('add-entity', @addRendererFromEntity)

    addRendererFromEntity: (e) =>
        @renderers.push(r) for r in e.getComponents("renderer")

    draw: (g) =>
        for r in @renderers
            r.render(g)
        
