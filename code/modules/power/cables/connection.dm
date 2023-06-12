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

/datum/wirenet_connection/power/lazy
	automatic = TRUE
