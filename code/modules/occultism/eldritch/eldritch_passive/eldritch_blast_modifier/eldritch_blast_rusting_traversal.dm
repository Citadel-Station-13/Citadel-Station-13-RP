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

/datum/projectile_effect/eldritch_blast_rusting_traversal/on_moved(obj/projectile/proj, atom/old_loc)
	. = ..()

#warn impl
