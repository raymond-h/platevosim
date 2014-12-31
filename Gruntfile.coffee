module.exports = (grunt) ->

	require('load-grunt-tasks')(grunt)

	grunt.initConfig
		pkg: grunt.file.readJSON 'package.json'

		browserify:
			build:
				options:
					transform: ['coffeeify']

					browserifyOptions:
						extensions: ['.coffee', '.js', '.json']

				files:
					'public/lib/main.js': ['src/index.coffee']

		coffeelint:
			build:
				files: src: ['src/**/*.coffee']
			options:
				no_tabs: level: 'ignore' # this is tab land, boy
				indentation: value: 1 # single tabs

		copy:
			phaser:
				files:
					'public/lib/phaser.js': require.resolve 'phaser'

		connect:
			dev:
				options:
					port: 3000
					base: 'public'
					livereload: yes

		watch:
			dev:
				files: ['src/**/*.{js,coffee}']
				tasks: ['lint', 'build']

				options:
					livereload: yes

	grunt.registerTask 'default', ['lint', 'build']

	grunt.registerTask 'build', [
		'copy:phaser'
		'browserify:build'
	]

	grunt.registerTask 'lint', [
		'coffeelint:build'
	]

	grunt.registerTask 'dev', [
		'connect:dev'
		'watch:dev'
	]