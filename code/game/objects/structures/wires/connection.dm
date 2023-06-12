/**
 * Wirenet connection datums - the primary point of abstraction between machines and wirenets
 *
 * Typecast things accordingly for sane usage API.
 *
 * Network is intentionally not declared on the base type for this purpose,
 * so you can declare network on subtypes with the necessary typecasting.
 *
 * todo: vv hooks
 *
 * ! WARNING : YOU MUST HAVE NETWORK DECLARED ON A SUBTYPE, OR THINGS HORRIBLY BREAK. !
 */
/datum/wirenet_connection
	/// our host, so we can track
	var/datum/host
	/// connected wire.
	var/obj/structure/wire/joint
	/// automatic handling of attach/detach/discovery. VERY EXPENSIVE, avoid using.
	var/automatic = FALSE

/datum/wirenet_connection/New(datum/host)
	src.host = host
	if(automatic)
		if(ismovable(host))
			host.AddElement(/datum/element/connect_loc, list(COMSIG_TURF_WIRENODE_DISCOVERY))
			RegisterSignals(
				host,
				list(
					COMSIG_TURF_WIRENODE_DISCOVERY,
					COMSIG_MOVABLE_MOVED,
				),
				PROC_REF(auto_move),
			)
		else
			CRASH("attempted automatic wirenet connection usage on non-movable host. are you really that lazy?")

/datum/wirenet_connection/Destroy()
	disconnect()
	if(automatic)
		if(ismovable(host))
			host.RemoveElement(/datum/element/connect_loc, list(COMSIG_TURF_WIRENODE_DISCOVERY))
			UnregisterSignal(
				host,
				list(
					COMSIG_TURF_WIRENODE_DISCOVERY,
					COMSIG_MOVABLE_MOVED,
				),
			)
	host = null
	return ..()

/datum/wirenet_connection/proc/disconnect()
	if(isnull(src.joint))
		return
	var/datum/wirenet/disconnecting_network = src.joint.network
	src.joint = null
	if(isnull(disconnecting_network))
		return
	disconnect_network(disconnecting_network)

/datum/wirenet_connection/proc/connect(obj/structure/wire/joint)
	#warn impl - store on subtypes
	#warn deferred connect if the joint doesn't have a network made.
	src.joint = joint
	var/datum/wirenet/connecting_network = joint.network
	connect_network(connecting_network)

/**
 * connect to the network
 */
/datum/wirenet_connection/proc/connect_network(datum/wirenet/network)
	host?.wirenet_connected(src, network)

/**
 * disconnect from the network; return network so we can pass it into wirenet_disconnected
 */
/datum/wirenet_connection/proc/disconnect_network(datum/wirenet/network)
	host?.wirenet_disconnected(src, network)

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

/**
 * called when we're connected to a wirenet datum
 * *not* the physical joint, but an actual wirenet network datum.
 * the physical joint can still be connected through a swap.
 */
/datum/proc/wirenet_connected(datum/wirenet_connection/connection, datum/wirenet/network)
	return

/**
 * called when we're disconnected from a wirenet datum
 * *not* the physical joint, but an actual wirenet network datum.
 * the physical joint can still be connected during this.
 */
/datum/proc/wirenet_disconnected(datum/wirenet_connection/connection, datum/wirenet/network)
	return

/**
 * called when we're being swapped from one wirenet to another
 */
/datum/proc/wirenet_switched(datum/wirenet_connection/connection, datum/wirenet/old_network, datum/wirenet/new_network)
	return

/**
 * On implementing movables, this should trigger wirenet updates. This is called on movables in a turf when a wire junction is made.
 */
/atom/movable/proc/wirenode_discovery()
	return

/turf/proc/wirenode_discovery()
	for(var/atom/movable/AM in src)
		if(AM.atom_flags & ATOM_ABSTRACT)
			continue
		AM.wirenode_discovery()
	SEND_SIGNAL(src, COMSIG_TURF_WIRENODE_DISCOVERY)
