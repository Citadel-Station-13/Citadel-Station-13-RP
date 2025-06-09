//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * gradually builds a dermal shield on you
 */
/datum/prototype/eldritch_passive/dermal_rust_layer
	id = "dermal_rust_layer"
	requires_ticking = TRUE
	/// requires you to be around rust tiles
	var/requires_rust_tile_proximity = TRUE
	/// rust tiles needed for max strength
	var/requires_rust_tile_proximity_ratio = 0.5

#warn impl

/datum/prototype/eldritch_passive/dermal_rust_layer/on_mob_tick(mob/cultist, datum/eldritch_holder/holder, datum/eldritch_passive_context/context, dt)
	. = ..()

