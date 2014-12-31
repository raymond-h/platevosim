_ = require 'lodash'
color = require 'onecolor'

{fixTilesetRender} = require './map-fixer'

module.exports = class Map
	@createLayers: (tilemap, layerNames) ->
		layers = {}

		for layer in layerNames
			l = tilemap.createLayer layer
			layers[layer] = l if l?

		layers

	constructor: (@game, @state, @tilemap) ->
		if _.isString @tilemap
			@tilemap = @game.add.tilemap @tilemap

		fixTilesetRender @tilemap

		@backgroundColor =
			color(@tilemap.properties.backgroundColor ? '#6B8AFF').hex()

		@entryPoints = {}

		@layers = Map.createLayers @tilemap, ['background', 'main']

		@layers.main.resizeWorld()

	loadCollisionBodies: ->

	loadObjects: ->
		@loadObject obj for obj in @tilemap.objects['obj_meta']

	loadObject: (obj) ->
		x = obj.x + obj.width / 2
		y = obj.y + obj.height / 2

		switch obj.name
			when 'entry'
				{entryName} = obj.properties

				@entryPoints[entryName] = {x, y}

	destroy: ->
		@tilemap.destroy() if @tilemap?
		@tilemap = null

		if @layers?
			for name, layer of @layers
				layer.destroy()

			@layers = null