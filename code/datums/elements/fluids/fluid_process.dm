/**
 * Fluid processing element
 *
 * Things with this get fluid_act called on them every tick they're in a fluid.
 */
/datum/element/fluid_processing
	element_flags = ELEMENT_DETACH

#warn impl

/*
/datum/element/fluid_depth/Attach(datum/target, depth)
	. = ..()
	if(. & ELEMENT_INCOMPATIBLE)
		return
	if(!depth)
		return . | ELEMENT_INCOMPATIBLE
	if(!ismovable(target))
		return . | ELEMENT_INCOMPATIBLE
	src.depth = depth
	var/atom/movable/AM = target
	if(isturf(AM.loc))
		AddDepthToTurf(AM.loc)
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, .proc/on_move)

/datum/element/fluid_depth/Detach(datum/source, force)
	. = ..()
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)
	var/atom/mvoable/AM = source
	if(isturf(AM.loc))
		RemoveDepthToTurf(AM.loc)

/datum/element/fluid_depth/proc/AddDepthToTurf(turf/T)
	T.fluid_depth += depth
	T.ReconsiderFluids()

/datum/element/fluid_depth/proc/RemoveDepthFromTurf(turf/T)
	T.fluid_depth -= depth
	T.ReconsiderFluids()

/datum/element/fluid_depth/proc/on_move(datum/source, atom/oldLoc)
	var/atom/movable/AM = source
	if(isturf(oldLoc))
		RemoveDepthFromTurf(oldLoc)
	if(isturf(AM.loc))
		AddDepthToTurf(AM.loc)
*/
