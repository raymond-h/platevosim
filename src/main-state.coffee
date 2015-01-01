_ = require 'lodash'

Map = require './map'
Player = require './player'
Orders = require './orders'
pathFinding = require './path-finding'

{fixMaps} = require './map-fixer'

module.exports = class MainState extends Phaser.State
	preload: ->
		@game.load.image 'mario-tileset', 'res/mario-tileset.png'
		@game.load.image 'metatiles', 'res/metatiles.png'

		@game.load.spritesheet 'player', 'res/mario.png', 16, 16

		@game.load.tilemap 'mainmap', 'res/main.json', null, Phaser.Tilemap.TILED_JSON
		@game.load.tilemap 'secondmap', 'res/second.json', null,
			Phaser.Tilemap.TILED_JSON

	create: ->
		fixMaps @game.cache

		@game.antialias = no
		@game.stage.disableVisibilityChange = yes

		@game.physics.startSystem Phaser.Physics.ARCADE

		@maps = ['mainmap', 'secondmap']

		@changeMap @maps[0]

		@players = @game.add.group()

		@pauseKey = @game.input.keyboard.addKey Phaser.Keyboard.P

		@pauseKey.onDown.add =>
			@game.paused = not @game.paused

		@newIteration()

	createPlayer: (x, y) ->
		player = new Player @game, @, x, y

		@game.add.existing player

		player

	changeMap: (newMap) ->
		@map.destroy() if @map?

		@map = new Map @game, @, newMap
		@stage.backgroundColor = @map.backgroundColor

		@distMap = pathFinding.getDistanceMap @map, [@map.finish]

	newIteration: (baseOrders = []) ->
		console.log 'Base orders', baseOrders

		@closestDist = Infinity
		{x, y} = @map.entryPoints.main

		for i in [0...100]
			player = @createPlayer x, y

			player.orders = Orders.generateOrders baseOrders
			player.oldOrders = player.orders[..]

			@players.addChild player

	startNextRound: ->
		@players.removeAll yes

		@maps.push @maps.shift() # rotate the array of maps
		@changeMap @maps[0]
		@game.world.bringToTop @players

		@newIteration()

	update: ->
		if @players.children.length <= 0
			@newIteration @oldOrders

		@game.physics.arcade.collide @players, @map.layers.col

		win = no

		@players.forEachAlive (player) =>
			if Math.round(player.body.position.x / 16) is @map.finish.x and
					Math.round(player.body.position.y / 16) is @map.finish.y

				win = yes

		if win or @game.input.keyboard.downDuration Phaser.Keyboard.N, 10
			@startNextRound()

	playerDeath: (player) ->
		x = player.body.position.x // 16
		y = player.body.position.y // 16

		dist = @distMap[y][x]

		console.log "Death at #{x},#{y}; distance: #{dist}"
		if dist < @closestDist
			@closestDist = dist
			@oldOrders = player.oldOrders
			console.log 'Updated old order', @oldOrders

		player.destroy()