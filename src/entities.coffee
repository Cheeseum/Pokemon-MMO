class @Entity
    constructor: () ->
        @components = {}

        @pos = new Vector()

    addComponent: (type, component) =>
        @components[type] or= []

        component.object = this
        @components[type].push(component)

    getComponents: (type) =>
        return @components[type] or []
    
    hasComponent: (type) =>
        return (type of @components) # "of" = "loop through keys"

    update: (t, dt) =>
        for type of @components
            component.update(t, dt) for component in @components[type]
