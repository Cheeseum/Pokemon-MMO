class @MapLayer
    constructor: () ->
        # FIXME: possibly initialize @tiles to a fixed size
        @tiles = []

    tileAt: (x, y) =>
        # FIXME: will explode of tiles[x] is undef
        return @tiles[x][y]

class @MapChunk
    constructor: () ->
        @layers = []
        @tileset = 0

    load_from_file: (file) =>
        #TODO: parse json from file and load

    load_from_json: (json) =>
        #TODO: parse json into mapchunk objects
