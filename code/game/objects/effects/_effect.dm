/**
 * Effects are mostly temporary visual effects like sparks, smoke, as well as decals, etc...
 *
 * these, however, have full object damgae/interaction support, so it's not limited to those
 *
 * however, at a certain point, do consider using /structure or /machinery instead.
 */
/obj/effect
	icon = 'icons/effects/effects.dmi'
	integrity_flags = INTEGRITY_ACIDPROOF | INTEGRITY_FIREPROOF | INTEGRITY_LAVAPROOF | INTEGRITY_INDESTRUCTIBLE
	move_resist = INFINITY
	obj_flags = NONE
	blocks_emissive = EMISSIVE_BLOCK_GENERIC
	integrity_enabled = FALSE

	anchored = TRUE
	vis_flags = VIS_INHERIT_PLANE

/obj/effect/fire_act()
	return

/obj/effect/acid_act()
	return FALSE

/obj/effect/blob_act(obj/structure/blob/B)
	return

/obj/effect/legacy_ex_act(severity, target)
	return FALSE

/obj/effect/singularity_act()
	qdel(src)

/// The abstract effect ignores even more effects and is often typechecked for atoms that should truly not be fucked with.
/obj/effect/abstract

/obj/effect/abstract/singularity_pull(atom/singularity, current_size)
	return

/obj/effect/abstract/singularity_act()
	return

/obj/effect/abstract/has_gravity(turf/gravity_turf)
	return FALSE

/obj/effect/dummy/singularity_pull(atom/singularity, current_size)
	return

/obj/effect/dummy/singularity_act()
	return
