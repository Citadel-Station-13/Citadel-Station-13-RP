GLOBAL_LIST_EMPTY(gps_transmitters)
/**
 * handles world size updates
 */
/proc/assert_gps_level_list()
	if(GLOB.gps_transmitters.len > world.maxz)
		CRASH("How? We just tried to shrink the GPS list!")
	GLOB.gps_transmitters.len = world.maxz
	for(var/i in 1 to GLOB.gps_transmitters.len)
		if(!islist(GLOB.gps_transmitters[i]))
			GLOB.gps_transmitters[i] = list()

/**
 * for when admins do an oopsy woopsy and fuck up royally.
 */
/proc/rebuild_gps_transmitters()
	GLOB.gps_transmitters = list()
	GLOB.gps_transmitters.len = world.maxz
	for(var/i in 1 to GLOB.gps_transmitters.len)
		GLOB.gps_transmitters[i] = list()
	// the forbidden `in world`
	for(var/datum/component/gps_signal/sig in world)
		sig.registered = FALSE
		sig.register_transmitter()

/**
 * gps signal components
 *
 * controlling it unfortunately will require GetComponents for now,
 * because it's sort of pointless to add signals for the sole purpose of
 * disabling GPS.
 *
 * sorry, not sorry.
 */
/datum/component/gps_signal
	dupe_mode = COMPONENT_DUPE_ALLOWED
	registered_type = /datum/component/gps_signal
	/// our gps tag
	var/gps_tag
	/// disabled
	var/disabled
	/// registered in list?
	var/registered = FALSE

/datum/component/gps_signal/Initialize(gps_tag = "COM0", disabled = FALSE)
	if(!isatom(parent) || ((. = ..()) & COMPONENT_INCOMPATIBLE))
		return COMPONENT_INCOMPATIBLE
	src.gps_tag = gps_tag
	src.disabled = disabled

/datum/component/gps_signal/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_MOVABLE_Z_CHANGED, PROC_REF(on_z_transit))
	register_transmitter()

/datum/component/gps_signal/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_MOVABLE_Z_CHANGED)
	unregister_transmitter()

/datum/component/gps_signal/proc/on_z_transit(datum/source, old_z, new_z)
	SIGNAL_HANDLER
	update_transmitter(old_z, new_z)

/datum/component/gps_signal/proc/register_transmitter()
	if(disabled)
		return
	var/atom/A = parent
	var/turf/T = get_turf(A)
	if(!T)
		return
	ASSERT(!registered)
	GLOB.gps_transmitters[T.z] += src
	registered = TRUE

/datum/component/gps_signal/proc/unregister_transmitter()
	if(disabled)
		return
	var/atom/A = parent
	var/turf/T = get_turf(A)
	if(!T)
		return
	ASSERT(registered)
	GLOB.gps_transmitters[T.z] -= src
	registered = FALSE

/datum/component/gps_signal/proc/update_transmitter(old_z, new_z)
	if(disabled)
		return
	if(old_z)
		GLOB.gps_transmitters[old_z] -= src
	if(new_z)
		GLOB.gps_transmitters[new_z] += src

/datum/component/gps_signal/proc/set_disabled(disabled)
	if(disabled == src.disabled)
		return
	if(disabled)
		unregister_transmitter()
		src.disabled = TRUE
	else
		src.disabled = FALSE
		register_transmitter()

/datum/component/gps_signal/proc/set_gps_tag(new_tag)
	gps_tag = new_tag
