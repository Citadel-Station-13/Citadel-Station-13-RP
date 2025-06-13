//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * eldritch blast spreads rust as it travels at random
 */
/datum/prototype/eldritch_passive/eldritch_blast_modifier/eldritch_blast_rusting_traversal
	id = "eldritch_blast_rusting_traversal"
	projectile_hooks = list(
		new /datum/projectile_effect/eldritch_blast_rusting_traversal,
	)

/datum/projectile_effect/eldritch_blast_rusting_traversal
	hook_moved = TRUE

	var/spread_radius = 2
	var/spread_ticks = 3
	var/spread_probability = 33

/datum/projectile_effect/eldritch_blast_rusting_traversal/on_moved(obj/projectile/proj, atom/old_loc)
	if(!proj.loc)
		return

	// imperfect but fast way to approximately trigger every 32 pixels, not on every tile
	var/last_travelled = proj.data[src]
	if(proj.distance_travelled - last_travelled < 32)
		return
	proj.data[src] = proj.distance_travelled

	var/multiplier = proj.projectile_effect_multiplier
	var/effective_spread_ticks = spread_ticks + ceil((multiplier - 1) * 3)
	var/effective_spread_probability = spread_probability
	var/effective_spread_radius = spread_radius

	var/our_x = proj.loc.x
	var/our_y = proj.loc.y
	var/our_z = proj.loc.z

	for(var/i in 1 to effective_spread_ticks)
		var/turf/maybe = locate(our_x + rand(-spread_radius, spread_radius), our_y + rand(-spread_radius, spread_radius), our_z)
		maybe?.eldritch_rust_spread(effective_spread_probability)
