_ = require 'lodash'

module.exports = class Player extends Phaser.Sprite
	constructor: (game, @state, x, y) ->
		super game, x, y, 'player'

		@game.physics.arcade.enable @

	update: ->
		super