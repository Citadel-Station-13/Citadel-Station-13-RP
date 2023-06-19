// Overmap stuff. Main file is under code/modules/maps/overmap/_lythios43c.dm
// Todo, find a way to populate this list automatically without having to do this
/obj/effect/overmap/visitable/sector/lythios43c
	extra_z_levels = list(
		/datum/map_level/rift/plains,
		/datum/map_level/rift/caves,
		/datum/map_level/rift/deep,
		/datum/map_level/rift/base,
	)

/// This is the effect that slams people into the ground upon dropping out of the sky //

/obj/effect/step_trigger/teleporter/planetary_fall/lythios43c
	planet_path = /datum/planet/lythios43c

/// Temporary place for this
// Spawner for lythios animals
/obj/tether_away_spawner/lythios_animals
	name = "Lythios Animal Spawner"
	faction = "lythios"
	atmos_comp = TRUE
	prob_spawn = 100
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/icegoat = 2,
		/mob/living/simple_mob/animal/passive/woolie = 3,
		/mob/living/simple_mob/animal/passive/furnacegrub,
		/mob/living/simple_mob/animal/horing = 2
	)
