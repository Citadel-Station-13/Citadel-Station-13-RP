//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * eldritch blast spreads rust on impact
 */
/datum/prototype/eldritch_passive/eldritch_blast_modifier/eldritch_blast_rusting_impact
	id = "eldritch_blast_rusting_impact"
	projectile_hooks = list(
		new /datum/projectile_effect/eldritch_blast_rusting_impact,
	)

/datum/projectile_effect/eldritch_blast_rusting_impact
	hook_impact = TRUE

	var/turf_radius = 5
	var/turf_probability = 70
	var/worn_probability = 70

/datum/projectile_effect/eldritch_blast_rusting_impact/on_impact(obj/projectile/proj, atom/target, impact_flags, def_zone)
	var/turf/target_turf = get_turf(target)

	var/multiplier = proj.projectile_effect_multiplier
	var/effective_turf_probability = effective_turf_probability
	var/effective_turf_radius = turf_radius

	if(multiplier < 0)
		// do nothing for now
	else if(multiplier < 1)
		effective_turf_probability *= multiplier
		effective_turf_radius = ceil(effective_turf_radius * multiplier)
	else
		effective_turf_probability = 100 - (100 - effective_turf_probability) * (1 / multiplier)
		effective_turf_radius = min(11, effective_turf_radius + sqrt((multiplier - 1) * 7.5))

	target_turf.eldritch_rust_spread(effective_turf_probability, effective_turf_radius)

	#warn uhh more shit ig?? spreading to objs, etc
	if(ismob(target))
		#warn inventory
		var/list/obj/item/exposed
		for(var/obj/item/item as anything in exposed)
			if(prob(worn_probability))
				item.eldritch_rust_inflict(effective_item_rust_amount)
	else if(isobj(target))

