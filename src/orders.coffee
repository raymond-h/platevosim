_ = require 'lodash'

exports.generateOrders = (lastOrders) ->
	return [] if not lastOrders?

	orders = lastOrders[..]

	offset = (_.sample orders)?.when ? 0

	if Math.random() < 0.5
		orders.push
			type: 'jump'
			when: offset + (Math.random() * 3) * 60

	if Math.random() < 0.7
		orders.push
			type: 'move'
			direction: Math.round Math.random() * 2 - 1
			when: offset + (Math.random() * 3) * 60

	orders.sort (e1, e2) -> e1.when - e2.when