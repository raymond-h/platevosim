window.onload = ->
	game = new Phaser.Game 640, 480, Phaser.AUTO

	game.state.add 'main', new (require './main-state'), yes