_ = require 'lodash'

module.exports = class Player extends Phaser.Sprite
	startDeathCount: 2 * 60

	constructor: (game, @state, x, y) ->
		super game, x, y, 'player'

		@game.physics.arcade.enable @

		@body.gravity.y = 200
		@body.collideWorldBounds = yes
		@anchor.setTo 0.5, 0.5

		@animations.add 'stand', [0], 0, no
		@animations.add 'walk', [1, 2, 3], 10, yes
		@animations.add 'jump', [5], 0, no

		@walkDir = 0

		@deathCounter = @startDeathCount
		@frameCount = 0

		@lastPos = new Phaser.Point 0, 0

		@orders = []

	update: ->
		super

		while @orders.length > 0 and @frameCount >= @orders[0].when
			@executeOrder @orders.shift()

		@updateAnimation()

		@checkDeath()

		@frameCount++

	executeOrder: (order) ->
		# console.log order

		switch order.type
			when 'jump'
				if @body.blocked.down
					@body.velocity.y = -100

			when 'move'
				@walkDir = order.direction

				@body.velocity.x = 50 * @walkDir

	updateAnimation: ->
		if not @body.blocked.down
			@animations.play 'jump'

		else if @walkDir isnt 0
			@scale.x = @walkDir
			@animations.play 'walk'

		else @animations.play 'stand'

	checkDeath: ->
		if ((Math.abs @body.position.x - @lastPos.x) < 1/30 and
				(Math.abs @body.position.y - @lastPos.y) < 1/30)

			if @deathCounter-- <= 0
				@state.playerDeath @

		else
			@deathCounter = @startDeathCount

		@body.position.copyTo @lastPos if @deathCounter > 0