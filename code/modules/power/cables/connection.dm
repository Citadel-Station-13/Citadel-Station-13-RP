/**
 * a machine's connection to the powernet
 */
/datum/wirenet_connection/power
	/// our network
	var/datum/wirenet/power/network

/datum/wirenet_connection/power/connect_network(datum/wirenet/power/network)
	src.network = network
	return ..()

/datum/wirenet_connection/power/disconnect_network()
	..()
	. = src.network
	src.network = null

/datum/wirenet_connection/power/proc/flat_draw(kw)
	return network.flat_draw(kw)

/datum/wirenet_connection/power/proc/dynamic_draw(kw, tier)
	return network.dynamic_draw(kw, tier)

/datum/wirenet_connection/power/proc/supply(kw)
	return network.supply(kw)

/datum/wirenet_connection/power/lazy
	automatic = TRUE
