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

/datum/wirenet_connection/power/is_connected()
	return !isnull(network)

/datum/wirenet_connection/power/proc/flat_draw(kw)
	return network.flat_draw(kw)

/datum/wirenet_connection/power/proc/dynamic_draw(kw, tier)
	return network.dynamic_draw(kw, tier)

/datum/wirenet_connection/power/proc/supply(kw)
	return network.supply(kw)

/datum/wirenet_connection/power/proc/last_excess()
	return network.last_excess

/datum/wirenet_connection/power/proc/last_supply()
	return network.last_supply

/datum/wirenet_connection/power/proc/last_load()
	return network.last_load

/datum/wirenet_connection/power/proc/last_flat_load()
	return network.last_flat_load

/datum/wirenet_connection/power/proc/last_dynamic_load()
	return network.load - network.last_flat_load

/datum/wirenet_connection/power/proc/last_powernet_status()
	return network.last_powernet_status

/datum/wirenet_connection/power/lazy
	automatic = TRUE
