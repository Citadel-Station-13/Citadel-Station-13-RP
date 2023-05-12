/datum/wirenet
	/// cables
	var/list/obj/structure/wire/segments
	/// connections
	var/list/datum/wirenet_connection/connections

/datum/wirenet/New(obj/structure/wire/joint)
	if(isnull(joint))
		return
	segments = list()
	connection = list()
	propagate(joint)

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
 * propagate from a specific wire
 */
/datum/wirenet/proc/propagate(obj/structure/wire/joint)

/**
 * add a wire into ourselves
 */
/datum/wirenet/proc/expand(obj/structure/wire/joint)
	joint.network = src
	for(var/datum/wirenet_connection/connection as anything in joint.connections)
		connection.connect_network(src)
