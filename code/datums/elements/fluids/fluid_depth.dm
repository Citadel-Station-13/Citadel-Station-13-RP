/**
 * Fluid depth element
 */
/datum/element/fluid_depth
	element_flags = ELEMENT_DETACH | ELEMENT_BESPOKE
	id_arg_index = 1
	var/depth

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
	AM.fluid_depth = depth
	if(isturf(AM.loc))
		AddDepthToTurf(AM.loc)
	RegisterSignal(target, COMSIG_MOVABLE_MOVED, .proc/on_move)

/datum/element/fluid_depth/Detach(datum/source, force)
	. = ..()
	UnregisterSignal(source, COMSIG_MOVABLE_MOVED)
	var/atom/movable/AM = source
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

/atom/movable
	/// Stores our current fluid depth. Used so /turf/procResetFluidDepth works. Never, ever use this directly, use the element.
	var/fluid_depth

/**
 * This you can use and are encouraged to!
 */
/atom/movable/proc/SetFluidDepth(newdepth)
	if(fluid_depth)
		RemoveElement(src, fluid_depth)
	if(newdepth)
		AddElement(newdepth)
