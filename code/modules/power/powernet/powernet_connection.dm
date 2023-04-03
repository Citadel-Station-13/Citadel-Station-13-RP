/**
 * much like atomspherics connectors, wire knots act as
 * ports to connect arbitrary atoms with powernet_connections.
 */
/datum/powernet_connection

/datum/powernet_connection/New(atom/host, disabled)

#warn impl

/atom/proc/powernet_connected(datum/poewrnet_connection/connection, datum/powernet/network)
	return

/atom/proc/powernet_disconnected(datum/powernet_connection/connection, datum/powernet/network)
	return
