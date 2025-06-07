//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * eldritch blast spreads rust as it travels at random
 */
/datum/prototype/eldritch_passive/patron/rust/eldritch_blast_rusting_traversal
	id = "eldritch_blast_rusting_traversal"

// TODO: impl

/datum/projectile_effect/eldritch_blast_rusting_traversal
	hook_moved = TRUE

/datum/projectile_effect/eldritch_blast_rusting_traversal/on_moved(obj/projectile/proj, atom/old_loc)
	. = ..()

