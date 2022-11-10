/**
 * effect supertype
 *
 * currently does nothing
 *
 * "weakly interactive visual objects" should usually go under this, especially if they're temporary/short lasting
 *
 * these, however, have full object damgae/interaction support, so it's not limited to those
 *
 * however, at a certain point, do consider using /structure or /machinery instead.
 */
/obj/effect
	unacidable = TRUE
	density = FALSE
	opacity = FALSE

	icon = 'icons/effects/effects.dmi'
	move_resist = INFINITY
	obj_flags = NONE
	vis_flags = VIS_INHERIT_PLANE
	// blocks_emissive = EMISSIVE_BLOCK_GENERIC

/obj/effect/take_damage(damage)
	return

/obj/effect/fire_act()
	return

/obj/effect/acid_act()
	return FALSE

/obj/effect/blob_act(obj/structure/blob/B)
	return

/obj/effect/ex_act(severity, target)
	return FALSE

/obj/effect/singularity_act()
	qdel(src)

/// The abstract effect ignores even more effects and is often typechecked for atoms that should truly not be fucked with.
/obj/effect/abstract

/obj/effect/abstract/singularity_pull()
	return

/obj/effect/abstract/singularity_act()
	return

/obj/effect/abstract/has_gravity(turf/T)
	return FALSE

/obj/effect/dummy/singularity_pull()
	return

/obj/effect/dummy/singularity_act()
	return
