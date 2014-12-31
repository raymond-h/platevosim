_ = require 'lodash'

Map = require './map'
Player = require './player'

{fixMaps} = require './map-fixer'

module.exports = class MainState extends Phaser.State
	preload: ->
		@game.load.spritesheet 'player', 'res/player.png', 16, 16

		@game.load.tilemap 'mainmap', 'res/main.json', null, Phaser.Tilemap.TILED_JSON

	create: ->
		fixMaps @game.cache

		@game.antialias = no

		@game.physics.startSystem Phaser.Physics.ARCADE

		@changeMap 'mainmap'

		{x, y} = @map.entryPoints.main
		@player = @createPlayer x, y

		@game.camera.follow @player

	createPlayer: (x, y) ->
		player = new Player @game, @, x, y

		@game.add.existing player

		player

	changeMap: (newMap) ->
		@map.destroy() if @map?

		@map = new Map @game, @, newMap
		@stage.backgroundColor = @map.backgroundColor