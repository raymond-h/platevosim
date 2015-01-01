exports.getDistanceMap = (map, goals) ->
	layer = map.layers.col

	tileFn = (x, y) ->
		not map.tilemap.getTile(x, y, layer, yes).collides

	goals = goals.map ({x, y}) -> "#{x};#{y}"

	distMap =
		for y in [0...layer.height/16]
			for x in [0...layer.width/16]
				if "#{x};#{y}" in goals then 0 else Infinity

	smallestNeighbour = (ox, oy) ->
		smallest = Infinity

		for i in [-1..1]
			for j in [-1..1]
				smallest = Math.min smallest, (distMap[i + oy]?[j + ox]) ? Infinity

		smallest

	iteration = ->
		changedOccured = no

		for y in [0...layer.height/16]
			for x in [0...layer.width/16]
				if not tileFn x, y
					continue

				smallest = smallestNeighbour x, y

				# console.log x, y, smallest

				if distMap[y][x] > smallest+2
					distMap[y][x] = smallest+1

					changedOccured = yes

		changedOccured

	while iteration() then

	distMap