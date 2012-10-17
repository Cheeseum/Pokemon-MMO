TMX_TAG_MAP                 = "map"
TMX_TAG_NAME                = "name"
TMX_TAG_VALUE               = "value"
TMX_TAG_VERSION             = "version"
TMX_TAG_ORIENTATION	        = "orientation"
TMX_TAG_WIDTH               = "width"
TMX_TAG_HEIGHT              = "height"
TMX_TAG_OPACITY             = "opacity"
TMX_TAG_TRANS               = "trans"
TMX_TAG_TILEWIDTH           = "tilewidth"
TMX_TAG_TILEHEIGHT          = "tileheight"
TMX_TAG_TILEOFFSET          = "tileoffset"
TMX_TAG_FIRSTGID            = "firstgid"
TMX_TAG_GID                 = "gid"
TMX_TAG_TILE                = "tile"
TMX_TAG_ID                  = "id"
TMX_TAG_DATA                = "data"
TMX_TAG_COMPRESSION         = "compression"
TMX_TAG_ENCODING            = "encoding"
TMX_TAG_ATTR_BASE64         = "base64"
TMX_TAG_CSV                 = "csv"
TMX_TAG_SPACING             = "spacing"
TMX_TAG_MARGIN              = "margin"
TMX_TAG_PROPERTIES          = "properties"
TMX_TAG_PROPERTY            = "property"
TMX_TAG_IMAGE               = "image"
TMX_TAG_SOURCE              = "source"
TMX_TAG_VISIBLE             = "visible"
TMX_TAG_TILESET             = "tileset"
TMX_TAG_LAYER               = "layer"
TMX_TAG_IMAGE_LAYER         = "imagelayer"
TMX_TAG_OBJECTGROUP         = "objectgroup"
TMX_TAG_OBJECT              = "object"
TMX_TAG_X                   = "x"
TMX_TAG_Y                   = "y"
TMX_TAG_WIDTH               = "width"
TMX_TAG_HEIGHT              = "height"
TMX_TAG_POLYGON             = "polygon"
TMX_TAG_POLYLINE            = "polyline"
TMX_TAG_POINTS              = "points"
TMX_BACKGROUND_COLOR        = "backgroundcolor"

class @TMXMapLoader
    constructor: () ->
        @map = null
        
    loadFromFile: (file) =>
        @map = new Map()

        $.post(file, (data) =>
            # callback
            xmld = $(data)
            map_data = xmld.find(TMX_TAG_MAP)
    
            @map.width = map_data.attr(TMX_TAG_WIDTH)
            @map.height = map_data.attr(TMX_TAG_HEIGHT)

            # TODO: split the map into multiple chunks
            
            for tileset in map_data.find(TMX_TAG_TILESET)
                tileset = $(tileset)

                @map.tilesets.push(@parseTileset(tileset))


            for layer in map_data.find(TMX_TAG_LAYER)
                layer = $(layer) # layer is a DOM element
                
                @map.layers.push(@parseLayer(layer))
        
        , "xml")

    # tileset_data: A jquery object of a TMX <tileset> element
    # returns a MapTileset object
    parseTileset: (tileset_data) =>
        first_gid = tileset_data.attr(TMX_TAG_FIRSTGID)
        image_data = $(tileset_data.find(TMX_TAG_IMAGE))
        image = image_data.attr(TMX_TAG_SOURCE)
        alpha_color = image_data.attr(TMX_TAG_TRANS)

        return new MapTileset(first_gid, image, alpha_color)
        

    # layer_data: A jquery object of a TMX <layer> element
    # returns a MapLayer object
    parseLayer: (layer_data) =>
        layer = new MapLayer()

        for data in layer_data.find(TMX_TAG_DATA)
            data = $(data)
            
            # filter missing tags to ""
            encoding = data.attr(TMX_TAG_ENCODING) or ""
            compression = data.attr(TMX_TAG_COMPRESSION) or ""

            # we can only handle uncompressed base64 (for now)
            if encoding == "base64"
                if compression == ""
                    raw_data = $.trim(data.text()) # grab and clean the encoded data
                    raw_tiles = Base64.decodeAsArray(raw_data, 4)

                    tile_idx = 0
                    for x in [0..@map.width]
                        for y in [0..@map.height]
                            layer.tiles[x] or= []
                            layer.tiles[x][y] = raw_tiles[tile_idx]
                            tile_idx++

                else
                    console.err("compression " + compression + " not supported!")
            else
                console.err("encoding " + encoding + " not supported!")

            return layer
