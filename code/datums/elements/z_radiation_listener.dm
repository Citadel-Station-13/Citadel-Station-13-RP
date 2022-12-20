/datum/element/z_radiation_listener
	element_flags = ELEMENT_DETACH

/datum/element/z_radiation_listener/Attach(datum/target)
	if(!isatom(target) || ((. = ..()) & ELEMENT_INCOMPATIBLE))
		return ELEMENT_INCOMPATIBLE | .
	var/atom/A = target
	if(A.rad_flags & RAD_Z_LISTENING)
		CRASH("tried to attach to something already listening!")
	var/turf/T = get_turf(A)
	if(T)
		// gotta deal with nullspace :/
		SSradiation.z_listeners[T.z] += target
	A.rad_flags |= RAD_Z_LISTENING
	RegisterSignal(A, COMSIG_MOVABLE_Z_CHANGED, .proc/z_change)

/datum/element/z_radiation_listener/Detach(datum/source, force)
	. = ..()
	var/atom/A = source
	A.rad_flags &= ~RAD_Z_LISTENING
	UnregisterSignal(A, COMSIG_MOVABLE_Z_CHANGED)
	var/turf/T = get_turf(A)
	if(T)
		SSradiation.z_listeners[T.z] -= A

/datum/element/z_radiation_listener/proc/z_change(atom/source, old_z, new_z)
	if(old_z)
		SSradiation.z_listeners[old_z] -= source
	if(new_z)
		SSradiation.z_listeners[new_z] += source
