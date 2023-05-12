/**
 * Wirenet connection datums - the primary point of abstraction between machines and wirenets
 *
 * Typecast things accordingly for sane usage API.
 *
 * Network is intentionally not declared on the base type for this purpose,
 * so you can declare network on subtypes with the necessary typecasting.
 */
/datum/wirenet_connection
	/// our host, so we can track
	var/datum/host

/datum/wirenet_connection/New(datum/host)
	src.host = host

/datum/wirenet_connection/Destroy()
	disconnect()
	host = null
	return ..()

/datum/wirenet_connection/proc/disconnect()
	#warn impl - store on subtypes

/datum/wirenet_connection/proc/connect(obj/structure/wire/joint)
	#warn impl - store on subtypes

/datum/wirenet_connection/proc/auto_to_turf(turf/T, require_junction = TRUE)
	disconnect()
	var/obj/structure/wire/found
	if(require_junction)
		for(found in T)
			if(!found.is_junction)
				continue
			break
	else
		found = locate() in T
	connect(found)

/datum/wirenet_connection/proc/auto_move(atom/movable/host)
	return auto_to_turf(get_turf(host))

/datum/proc/wirenet_connected(datum/wirenet_connection/connection)

/datum/proc/wirenet_disconnected(datum/wirenet_connection/connection)

/**
 * On implementing movables, this should trigger wirenet updates. This is called on movables in a turf when a wire junction is made.
 */
/atom/movable/proc/wirenet_discovery()
	return

/turf/proc/wirenet_discovery()
	for(var/atom/movable/AM in src)
		if(AM.atom_flags & ATOM_ABSTRACT)
			continue
		AM.wirenet_discovery()
	SEND_SIGNAL(src, COMSIG_TURF_WIRENET_DISCOVERY)

/**
 * lazy version - automatically update to location
 *
 * these are *expensive*. Use sparingly.
 */
/datum/wirenet_connection/automatic

#warn impl; lmao
