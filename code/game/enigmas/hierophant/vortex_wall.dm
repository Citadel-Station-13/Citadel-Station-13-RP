/obj/efect/vortex/wall
	name = "vortex barrier"
	desc = "A pulsating barrier made out of unknown energies."
	opacity = FALSE
	density = TRUE

	/// magic holder
	var/datum/vortex_magic/parent

	#warn icon, state

/obj/efect/vortex/wall/Initialize(mapload, duration, datum/vortex_magic/parent)
	if(!isnull(duration))
		QDEL_IN(src, duration)
	src.parent = parent
	parent?.walls += src
	return ..()

/obj/efect/vortex/wall/Destroy()
	parent?.walls -= src
	parent = null
	return ..()

/obj/efect/vortex/wall/CanAllowThrough(atom/movable/mover, turf/target)
	. = parent?.check_wall_pass(mover, target)
	if(isnull(.))
		return ..()
