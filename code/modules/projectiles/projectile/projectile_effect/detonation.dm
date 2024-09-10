//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * projectile effects that detonate
 *
 * * has default handling for piercing
 */
/datum/projectile_effect/detonation
	hook_impact = TRUE

	/// detonate on end
	var/detonate_on_lifetime = FALSE
	/// trigger even while piercing
	///
	/// * extremely dangerous to set, hence why detonate_delete_self needs to be changed too for it to work.
	var/detonate_on_pierce = FALSE
	/// if we would otherwise pierce, just detonate and delete anyways
	///
	/// * otherwise, detonation just won't trigger if we pierce
	var/detonate_prevent_pierce = TRUE

/datum/projectile_effect/detonation/proc/detonation(turf/where)
	return
