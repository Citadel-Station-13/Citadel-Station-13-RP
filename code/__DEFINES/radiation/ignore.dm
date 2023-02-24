//! superglobals for speed

GLOBAL_REAL_MANAGED(radiation_full_ignore, /list) = __radiation_full_ignore()

/proc/__radiation_full_ignore()
	return typecacheof(list(
		/mob/new_player,
		/mob/observer,
		/atom/movable/lighting_overlay,
		/obj/item/projectile,
		/obj/effect,
		/obj/mob_spawner,
	))

GLOBAL_REAL_MANAGED(radiation_infect_ignore, /list) = __radiation_infect_ignore()

/proc/__radiation_infect_ignore()
	return typecacheof(list(
		/turf,
		/obj/structure/cable,
		/obj/machinery/atmospherics,
		/obj/item/ammo_casing,
		/obj/singularity,
	))
