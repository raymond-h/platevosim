exports.fixMaps = (cache) ->
	# For all maps in cache...
	for key, map of cache._cacheMap[Phaser.Cache.TILEMAP]

		# Remove 'tiles' property (causes problems)
		for tileset in map.data.tilesets
			delete tileset.tiles

		# Add rotation property of objects as custom property $angle
		# (to make it available for the game)
		for layer in map.data.layers when layer.type is 'objectgroup'
			for obj in layer.objects
				obj.properties.$angle = obj.rotation

exports.fixTilesetRender = (tilemap) ->
	for tileset in tilemap.tilesets
		superDraw = tileset.draw

		tileset.draw = (context, x, y, index) ->
			y += -@tileHeight + tilemap.tileHeight

			superDraw.call @, context, x, y, index