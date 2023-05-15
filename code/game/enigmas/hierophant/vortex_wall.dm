/obj/efect/vortex/wall
	name = "vortex barrier"
	desc = "A pulsating barrier made out of unknown energies."
	opacity = FALSE
	density = TRUE

	#warn icon, state

/obj/efect/vortex/wall/Initialize(mapload, datum/vortex_magic/parent, duration)
	. = ..()
	if(!isnull(duration))
		QDEL_IN(src, duration)
	parent?.walls += src

/obj/efect/vortex/wall/Destroy()
	parent?.walls -= src
	return ..()

/obj/efect/vortex/wall/CanAllowThrough(atom/movable/mover, turf/target)
	. = parent?.check_wall_pass(mover, target)
	if(isnull(.))
		return ..()
