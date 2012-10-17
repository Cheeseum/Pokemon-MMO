class @MapTileset
    constructor: (@first_gid, @image_source, @alpha_color = null) ->

class @MapLayer
    constructor: () ->
        # FIXME: possibly initialize @tiles to a fixed size
        # tiles are stored as integers corresponding to its position in a tileset
        # see the TMX map format documentation for more details
        @tiles = []

    tileAt: (x, y) =>
        # FIXME: will explode if tiles[x] is undef
        return @tiles[x][y]

class @Map
    constructor: () ->
        @layers = []
        @tilesets = []

    getTilesetForTile: (tile_id) =>
        # FIXME: ensure @tilesets is in sorted order
        return t for t in @tilesets if t.first_gid <= tile_id
