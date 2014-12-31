_ = require 'lodash'

module.exports = class Player extends Phaser.Sprite
	constructor: (game, @state, x, y) ->
		super game, x, y, 'player'

		@game.physics.arcade.enable @

		@body.gravity.y = 200
		@body.collideWorldBounds = yes

		@animations.add 'stand', [0], 0, no
		@animations.add 'walk', [1, 2, 3], 10, yes
		@animations.add 'jump', [5], 0, no

		@walkDir = 0

	update: ->
		super

		if not @body.blocked.down
			@animations.play 'jump'

		else if @walkDir isnt 0
			@scale.x = @walkDir
			@animations.play 'walk'

		else @animations.play 'stand'