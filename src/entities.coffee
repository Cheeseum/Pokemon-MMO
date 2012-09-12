class @Entity
    constructor: () ->
        @components = {}

        @x = 0
        @y = 0

    addComponent: (type, component) =>
        @components[type] or= []

        component.object = this
        @components[type].push(component)

    getComponents: (type) =>
        return @components[type] or []
    
    hasComponent: (type) =>
        return (type of @components) # "of" = "loop through keys"

    update: (t, dt) =>
        for component in @components
            component.update(t, dt)
