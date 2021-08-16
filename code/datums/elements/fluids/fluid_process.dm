/**
 * Fluid processing element
 *
 * Things with this get fluid_act called on them every tick they're in a fluid.
 */
/datum/element/fluid_processing
	element_flags = ELEMENT_DETACH

/datum/element/fluid_processing/Attach(datum/target)
	. = ..()
	if(. & ELEMENT_INCOMPATIBLE)
		return
	if(!ismovable(target))
		return ELEMENT_INCOMPATIBLE
	var/atom/movable/AM = target
	if(isturf(AM.loc))
		var/turf/T = AM.loc
		if(T.fluid_active)
			AM.fluid_act(T.reagents, FALSE)
			SSfluids.StartActProcessing(AM, TRUE)
	RegisterSignal(AM, COMSIG_MOVABLE_MOVED, .proc/on_move)

/datum/element/fluid_processing/proc/on_move(datum/source)
	var/atom/movable/AM = source
	if(!isturf(AM.loc))
		return
	var/turf/T = AM.loc
	if(!T.fluid_active)
		return
	if(SSfluids.act_processing[AM])
		return
	AM.fluid_act(T.reagents, TRUE)
	SSfluids.StartActProcessing(AM, TRUE)

/datum/element/fluid_processing/Detach(datum/source, force)
	. = ..()
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)
	var/atom/movable/AM = source
	SSfluids.act_processing -= AM
	SSfluids.act_deferred -= AM
