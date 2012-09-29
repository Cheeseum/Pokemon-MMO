class @World
    constructor: () ->
        @entities = []
        @renderables = []

        @event_manager = new EventManager() # FIXME: this makes sense as some sort of global object

    addEntity: (entity) =>
        @entities.push(entity)

        if entity.hasComponent("renderer")
            @renderables.push(entity)

        @event_manager.dispatchEvent("add-entity", entity)

    update: (t, dt) =>
        for entity in @entities
            entity.update(t, dt)
