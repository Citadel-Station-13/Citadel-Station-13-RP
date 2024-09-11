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

/datum/projectile_effect/detonation/on_impact(obj/projectile/proj, atom/target, impact_flags, def_zone)
	// if we're not hitting don't do anything
	if(impact_flags & PROJECTILE_IMPACT_FLAGS_SHOULD_NOT_HIT)
		return
	// don't do anything if we're not hitting a turf
	// moving_to just makes sure we still go off if target is deleted
	var/turf/target_turf = get_turf(target) || proj.trajectory_moving_to
	if(!isturf(target_turf))
		return
	// prevent_pierce forces detonation + deletion on impact always
	if(detonate_prevent_pierce)
		detonation(target_turf)
		return impact_flags | PROJECTILE_IMPACT_DELETE
	// if we're piercing, we will return
	// pierce means going through, even if it's not piercing.
	if((impact_flags & PROJECTILE_IMPACT_FLAGS_SHOULD_GO_THROUGH) && !detonate_on_pierce)
		return
	detonation(target_turf)

/datum/projectile_effect/detonation/on_lifetime(obj/projectile/proj, impact_ground_on_expiry)
	if(!detonate_on_lifetime || impact_ground_on_expiry) // if impacting ground that'll handle it
		return
	if(!isturf(proj.loc))
		return
	detonation(proj.loc)

/datum/projectile_effect/detonation/proc/detonation(turf/where)
	return
