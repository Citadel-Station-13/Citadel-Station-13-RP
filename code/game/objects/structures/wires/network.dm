/datum/wirenet
	/// cables
	var/list/obj/structure/wire/segments
	/// connections
	var/list/datum/wirenet_connection/connections

/datum/wirenet/New(obj/structure/wire/joint, subdividing)
	if(isnull(joint))
		return
	segments = list()
	connection = list()
	if(subdividing)
		propagate(joint)
	else
		build(joint)

/datum/wirenet/Destroy()
	for(var/obj/structure/wire/segment as anything in segments)
		#warn rebuild
	for(var/datum/wirenet_connection/connection as anything in connections)
		connection.disconnect_network(src)
	segments = null
	connections = null
	return ..()

/**
 * merge one wirenet into another, deleting it in the process (it = ourselves)
 *
 * override on subtypes of /datum/wirenet with the correct typecasting for "into".
 */
/datum/wirenet/proc/merge(datum/wirenet/into)
	for(var/datum/wirenet_connection/connection as anything in connections)
		connection.network = into
		connection.host?.wirenet_switched(connection, src, into)
	for(var/obj/structure/wire/segment as anything in segments)
		segment.network = into
	segments = null
	connections = null
	qdel(src)

/**
 * returns wires
 */
/datum/wirenet/proc/get_wires()
	return segments.Copy()

/**
 * returns connections
 */
/datum/wirenet/proc/get_connections()
	return connections.Copy()

/**
 * returns connected hosts without nulls
 */
/datum/wirenet/proc/get_hosts()
	. = list()
	for(var/datum/wirenet_connection/connection as anything in connections)
		if(isnull(connection.host))
			continue
		. += connection.host

/**
 * construction propagation from a specific wire - use for initial network builds
 */
/datum/wirenet/proc/build(obj/structure/wire/joint)

/**
 * overwrite propagation from a specific wire - use for when you know a network needs to be severed in a specific way
 * and don't want to unnecessarily build the other side
 */
/datum/wirenet/proc/propagate(obj/structure/wire/joint)

#warn impl all

/**
 * add a wire into ourselves
 */
/datum/wirenet/proc/add_segment(obj/structure/wire/joint)
	joint.network = src
	for(var/datum/wirenet_connection/connection as anything in joint.connections)
		connection.connect_network(src)

/**
 * removes a wire from ourselves
 */
/datum/wirenet/proc/remove_segment(obj/structure/wire/joint)
	joint.network = null
	for(var/datum/wirenet_connection/connection as anything in joint.connections)
		connection.disconnect_network(src)

/**
 * removes all wires from ourselves
 *
 * cheaper than remove_segment when segments are removed en masse.
 */
/datum/wirenet/proc/remove_segments(list/obj/structure/wire/joints = segments)
	#warn impl
