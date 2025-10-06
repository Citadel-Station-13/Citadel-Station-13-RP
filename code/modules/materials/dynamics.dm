//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//? Page has all balancing parameters + algorithms for dynamic attribute computations for things like armor ?//
//? Prefix subsystem procs with 'dynamic_', please!                                                         ?//

// TODO: redo pretty much this entire file, all the calculations are horrible
//       lohikar was right i should've used a straight line man

//* Armor *//

/**
 * creates an armor datum based off of our stats
 *
 * @params
 * * significance - relative amount of this material used should be a multiplier of MATERIAL_SIGNIFICANCE_BASELINE
 * * mob_armor - is this going to be used as mob armor? mob armor generally won't have vulnerability.
 *
 * @return /datum/armor instance
 */
/datum/prototype/material/proc/create_armor(significance = MATERIAL_SIGNIFICANCE_BASELINE, mob_armor)
	RETURN_TYPE(/datum/armor)
	var/cache_key = "[significance]_[!!mob_armor]"
	if(!isnull(armor_cache[cache_key]))
		return armor_cache[cache_key]

	//? Not even Desmos will save you now. ?//
	//? WIP calculator: https://www.desmos.com/calculator/qqef72mlhf ?//
	// significance difference from baseline as a number
	var/significance_as_multiplier = ((MATERIAL_SIGNIFICANCE_BASELINE + (significance - MATERIAL_SIGNIFICANCE_BASELINE)) * 0.1)
	// absorbing kinetic energy
	var/kinetic_damping = toughness * ((density ** 0.5) * (1 / 3))
	// stopping kinetic penetrators
	var/kinetic_hardness = hardness * ((density ** 0.5) * (1 / 8) + 0.7)
	// absorbing energy blasts
	var/ablation_damping = (absorption + refraction * 0.2)
	// stopping energy blasts from penetrating
	var/ablation_diffusion = (absorption * 0.2 + refraction)
	// exotic 'energy' armor
	// todo: this is a weird formula
	var/exotic_absorption = (nullification + 0.2 * refraction + 0.1 * absorption)
	exotic_absorption = exotic_absorption >= 0? clamp(((exotic_absorption * significance_as_multiplier) ** 0.73) * 0.007, 0, 1) : \
		clamp(-(((-exotic_absorption * significance_as_multiplier) ** 0.73) * 0.007), -1, 0)
	// bomb values : from kinetic damping and hardness
	var/direct_bomb = (0.01 * (1 / -(((kinetic_damping + kinetic_hardness) / 1.27 * significance_as_multiplier + 400) * 0.000025)) + 1)
	// direct values
	// todo: integrate significance
	// todo: integrate some kind of 'coverage' parameter?
	var/direct_bio = relative_permeability > 1? -relative_permeability : relative_permeability
	// todo: integrate significance
	// todo: integrate some kind of 'coverage' parameter?
	var/direct_acid = relative_reactivity > 1? -relative_reactivity : (1 - relative_reactivity)
	// todo: integrate significance
	// todo: integrate some kind of 'coverage' parameter?
	var/direct_fire = relative_reactivity > 1? -relative_reactivity : (1 - relative_reactivity)
	var/direct_rad = clamp((((density + nullification * 0.025 + refraction * 0.01 + absorption * 0.0075) * significance_as_multiplier * (1 / 55)) ** 2) * 4, 0, 1)
	// tier; hardness is important
	// we grab this first because we need to module the actual armor by this
	// it's a bit dumb but until we have proper material science like dwarf fortress
	// and bludgeon/slash/pierce a la bg3, we're stuck with this
	var/kinetic_tier = (((kinetic_hardness + kinetic_damping * 0.2) * significance_as_multiplier) ** 0.5) * 0.125
	// sike i can't math for shit we'll use kinetic absorption as just the inverse lol
	var/kinetic_absorb = 1.6 * (1 / (1 + NUM_E ** -(0.004 * (kinetic_hardness * 0.2 + kinetic_damping)))) - 0.5 * 1.6
	// ditto
	var/laser_tier = 1.6 * 6 * (1 / (1 + NUM_E ** -(0.0042 * (ablation_diffusion * significance_as_multiplier)))) - 0.5 * 1.6 * 6
	var/laser_absorb = ((1 / (-(ablation_damping * significance_as_multiplier + 400) * 0.000025)) + 100) * 0.013
	// we don't allow deflection for now
	return (armor_cache[cache_key] = fetch_armor_struct(list(
		ARMOR_MELEE = round(kinetic_absorb, ARMOR_PRECISION),
		ARMOR_MELEE_TIER = round(kinetic_tier, ARMOR_TIER_PRECISION),
		ARMOR_MELEE_SOAK = round(kinetic_damping * 0.005 + kinetic_hardness * 0.0025, DAMAGE_PRECISION),
		ARMOR_BULLET = round(kinetic_absorb, ARMOR_PRECISION),
		ARMOR_BULLET_TIER = round(kinetic_tier, ARMOR_TIER_PRECISION),
		ARMOR_BULLET_SOAK = round(kinetic_damping * 0.0025 + kinetic_hardness * 0.005, DAMAGE_PRECISION),
		ARMOR_LASER = round(laser_absorb, ARMOR_PRECISION),
		ARMOR_LASER_TIER = round(laser_tier, ARMOR_TIER_PRECISION),
		ARMOR_LASER_SOAK = round(ablation_damping * 0.0025 + ablation_diffusion * 0.005, DAMAGE_PRECISION),
		ARMOR_ENERGY = round(exotic_absorption, ARMOR_PRECISION),
		ARMOR_BOMB = round(direct_bomb, ARMOR_PRECISION),
		ARMOR_BIO = round(direct_bio, ARMOR_PRECISION),
		ARMOR_ACID = round(direct_acid, ARMOR_PRECISION),
		ARMOR_FIRE = round(direct_fire, ARMOR_PRECISION),
		ARMOR_RAD = round(direct_rad, ARMOR_PRECISION),
	)))

/**
 * combines multiple material armors into one
 *
 * @params
 * * materials - material instances associated to significance.
 *
 * @return /datum/armor instance
 */
/datum/controller/subsystem/materials/proc/combined_materials_armor(list/datum/prototype/material/materials)
	var/list/cache_key = list()
	for(var/datum/prototype/material/mat as anything in materials)
		cache_key += "[mat.id]-[materials[mat]]"
	cache_key = jointext(cache_key, ";")
	var/datum/armor/resolved = combined_armor_cache[cache_key]
	if(!isnull(resolved))
		return resolved
	var/list/datum/armor/collected = list()
	for(var/datum/prototype/material/mat as anything in materials)
		collected[mat.create_armor(materials[mat]).to_list()] = materials[mat]

	// todo: this is shitty but we just do the best of all
	//       as a result, combined materials armor tends to be pretty op
	//       please rework when possible.
	var/list/combined = list()
	for(var/list/armor_list as anything in collected)
		for(var/key in armor_list)
			combined[key] = max(combined[key], armor_list[key])

	resolved = fetch_armor_struct(combined)
	combined_armor_cache[cache_key] = resolved
	return resolved

/**
 * combines multiple material armors into one
 * used for reinforcing / whatevers
 *
 * @params
 * * materials - material instances associated to significance. first is lowest; put exterior armors on last!
 *
 * @return /datum/armor instance
 */
/datum/controller/subsystem/materials/proc/reinforcing_materials_armor(list/datum/prototype/material/materials)
	var/list/cache_key = list()
	for(var/datum/prototype/material/mat as anything in materials)
		if(isnull(mat))
			continue
		cache_key += "[mat.id]-[materials[mat]]"
	cache_key = jointext(cache_key, ";")
	var/datum/armor/resolved = layered_armor_cache[cache_key]
	if(!isnull(resolved))
		return resolved
	var/list/datum/armor/collected = list()
	for(var/datum/prototype/material/mat as anything in materials)
		if(isnull(mat))
			continue
		collected[mat.create_armor(materials[mat]).to_list()] = materials[mat]

	// todo: this is shitty but we just do the best of all
	//       as a result, combined materials armor tends to be pretty op
	//       please rework when possible.
	var/list/combined = list()
	for(var/list/armor_list as anything in collected)
		for(var/key in armor_list)
			combined[key] = max(combined[key], armor_list[key])

	resolved = fetch_armor_struct(combined)
	layered_armor_cache[cache_key] = resolved
	return resolved

/**
 * combines multiple material armors into one
 * used for reinforcing / whatevers
 *
 * todo: this is just a snowflake wall variant to give them deflect. please, find a less shitty solution to this. yikes.
 *
 * @params
 * * materials - material instances associated to significance. first is lowest; put exterior armors on last!
 *
 * @return /datum/armor instance
 */
/datum/controller/subsystem/materials/proc/wall_materials_armor(list/datum/prototype/material/materials)
	var/list/cache_key = list()
	for(var/datum/prototype/material/mat as anything in materials)
		if(isnull(mat))
			continue
		cache_key += "[mat.id]-[materials[mat]]"
	cache_key = jointext(cache_key, ";")
	var/datum/armor/resolved = wall_armor_cache[cache_key]
	if(!isnull(resolved))
		return resolved
	var/list/datum/armor/collected = list()
	for(var/datum/prototype/material/mat as anything in materials)
		if(isnull(mat))
			continue
		collected[mat.create_armor(materials[mat]).to_list()] = materials[mat]

	// todo: this is shitty but we just do the best of all
	//       as a result, combined materials armor tends to be pretty op
	//       please rework when possible.
	var/list/combined = list()
	for(var/list/armor_list as anything in collected)
		for(var/key in armor_list)
			combined[key] = max(combined[key], armor_list[key])

	//* give walls some special shit so they don't get literally greytided to shit and back
	combined[ARMOR_MELEE_DEFLECT] = 5 // good enough

	resolved = fetch_armor_struct(combined)
	wall_armor_cache[cache_key] = resolved
	return resolved

//* Integrity *//

/**
 * gets overall integrity multiplier from a list of materials associated to significances
 */
/datum/controller/subsystem/materials/proc/dynamic_calculate_relative_integrity(list/datum/prototype/material/materials)
	var/total = 0
	var/pieces = 0

	for(var/datum/prototype/material/material as anything in materials)
		var/significance = materials[material]

		pieces += significance
		total += material.relative_integrity * significance

	return total / pieces

//* Melee *//

/**
 * get melee stats
 * autodetect with initial damage modes of item
 * alternatively forced modes can be specified via the param
 *
 * @params
 * * initial_modes - modes of attack the weapon normally is
 * * significance - a modifier that determines how well materials scale; lighter weapons scale less, etc. this is a very arbitrary value.
 *
 * @return list(damage, armorflag, tier, mode)
 */
/datum/prototype/material/proc/melee_stats(initial_modes, significance = MATERIAL_SIGNIFICANCE_BASELINE)
	var/cache_key = "[initial_modes]_[significance]"
	if(!isnull(melee_cache[cache_key]))
		return melee_cache[cache_key]
	. = new /list(MATERIAL_MELEE_STATS_LISTLEN)

	// see [code/__DEFINEs/materials/dynamics.dm] for equations / desmos links
	// this is far less documented than carry weight but this shit is hellish so whatever.

	// todo: damage mode flag has some overlap/confusing semantics
	if(initial_modes & (DAMAGE_MODE_PIERCE | DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE))
		// use hardness
		.[MATERIAL_MELEE_STATS_FLAG] = ARMOR_MELEE
		.[MATERIAL_MELEE_STATS_MODE] = initial_modes
		var/damage = (MATERIAL_DYNAMICS_DAMAGE_CEILING / (1 + (NUM_E ** -(MATERIAL_DYNAMICS_DAMAGE_LOGISTIC * ((hardness * MATERIAL_DYNAMICS_DAMAGE_INTENSIFIER * MATERIAL_SIGNIFICANCE_TO_DAMAGE_INTENSIFIER(significance) * MATERIAL_DENSITY_TO_DAMAGE_INTENSIFIER(density) - MATERIAL_DYNAMICS_DAMAGE_SHIFT) / MATERIAL_DYNAMICS_DAMAGE_DIVISOR)))))
		var/tier = (( \
			  (MATERIAL_DYNAMICS_DAMTIER_CEILING * 2) \
			/ (1 + NUM_E ** -( \
				MATERIAL_DYNAMICS_DAMTIER_LOGISTIC * \
				((hardness * MATERIAL_DYNAMICS_DAMTIER_INTENSIFIER * MATERIAL_SIGNIFICANCE_TO_DAMAGE_INTENSIFIER(significance) * MATERIAL_DENSITY_TO_DAMAGE_INTENSIFIER(density) - MATERIAL_DYNAMICS_DAMTIER_SHIFT) / MATERIAL_DYNAMICS_DAMTIER_DIVISOR) \
			)) \
		) - MATERIAL_DYNAMICS_DAMTIER_CEILING + MATERIAL_DYNAMICS_DAMTIER_ADJUST ) * MATERIAL_DYNAMICS_DAMTIER_SCALER
		.[MATERIAL_MELEE_STATS_DAMAGE] = round(damage, DAMAGE_PRECISION)
		.[MATERIAL_MELEE_STATS_TIERMOD] = round(tier, DAMAGE_TIER_PRECISION)
	else
		// use toughness, density
		.[MATERIAL_MELEE_STATS_FLAG] = ARMOR_MELEE
		.[MATERIAL_MELEE_STATS_MODE] = initial_modes
		var/damage = (MATERIAL_DYNAMICS_DAMAGE_CEILING / (1 + (NUM_E ** -(MATERIAL_DYNAMICS_DAMAGE_LOGISTIC * ((toughness * MATERIAL_DYNAMICS_DAMAGE_INTENSIFIER * MATERIAL_SIGNIFICANCE_TO_DAMAGE_INTENSIFIER(significance) * MATERIAL_DENSITY_TO_DAMAGE_INTENSIFIER(density) - MATERIAL_DYNAMICS_DAMAGE_SHIFT) / MATERIAL_DYNAMICS_DAMAGE_DIVISOR)))))
		.[MATERIAL_MELEE_STATS_DAMAGE] = round(damage, DAMAGE_PRECISION)
		var/tier = (( \
			  (MATERIAL_DYNAMICS_DAMTIER_CEILING * 2) \
			/ (1 + NUM_E ** -( \
				MATERIAL_DYNAMICS_DAMTIER_LOGISTIC * \
				((toughness * MATERIAL_DYNAMICS_DAMTIER_INTENSIFIER * MATERIAL_SIGNIFICANCE_TO_DAMAGE_INTENSIFIER(significance) * MATERIAL_DENSITY_TO_DAMAGE_INTENSIFIER(density) - MATERIAL_DYNAMICS_DAMTIER_SHIFT) / MATERIAL_DYNAMICS_DAMTIER_DIVISOR) \
			)) \
		) - MATERIAL_DYNAMICS_DAMTIER_CEILING + MATERIAL_DYNAMICS_DAMTIER_ADJUST ) * MATERIAL_DYNAMICS_DAMTIER_SCALER
		.[MATERIAL_MELEE_STATS_TIERMOD] = round(tier, DAMAGE_TIER_PRECISION)

	melee_cache[cache_key] = .

/obj/item/proc/apply_melee_stats(list/melee_stats, base_damage = 0, base_tier = 0, mod_damage = 1)
	damage_force = base_damage + mod_damage * melee_stats[MATERIAL_MELEE_STATS_DAMAGE]
	damage_flag = melee_stats[MATERIAL_MELEE_STATS_FLAG]
	damage_mode = melee_stats[MATERIAL_MELEE_STATS_MODE]
	damage_tier = base_tier + melee_stats[MATERIAL_MELEE_STATS_TIERMOD]


//* Tools *//

/**
 * Get toolspeed
 *
 * @params
 * * hardness_weight : weight of material hardness (0-1), should sum with all other weights to 1
 * * toughness_weight : weight of material tougness (0-1), should sum with all other weights to 1
 * * refraction_weight : weight of material refr (0-1), should sum with all other weights to 1
 * * absorption_weight : weight of material absorp (0-1), should sum with all other weights to 1
 * * nullification_weight : weight of material nulli (0-1), should sum with all other weights to 1
 * * initial_toolspeed : speed of the tool to begin with
 * * significance - a modifier that determines how well materials scale; less significant tools scale less. we assume baseline for most tools.
 *
 * https://www.desmos.com/calculator/m4gtk3aabl
 * @return new_toolspeed
 */
/datum/prototype/material/proc/tool_stats(hardness_weight = 0.5, toughness_weight = 0.5, refraction_weight = 0, absorption_weight = 0, nullification_weight = 0, initial_toolspeed = 1, significance = MATERIAL_SIGNIFICANCE_BASELINE)
	//-80-80 value for the tool.
	//20 is the 'baseline' value. Anything worse than 20 will reduce stats, anything better than 20 will improve it.
	var/tool_score = ((hardness_weight * hardness)+(toughness_weight*toughness)+(refraction_weight*refraction)+(absorption_weight*absorption)+(nullification_weight*nullification))/10


	//amount toolspeed will be adjusted by
	var/toolspeed_adjust = (-1 * ( (2*MATERIAL_DYNAMICS_TOOLSPEED_BOUND)/(1+(NUM_E**( (MATERIAL_DYNAMICS_TOOLSPEED_GRADIENT) * (tool_score - MATERIAL_DYNAMICS_TOOLSPEED_X_INTERCEPT) ) ) ) ) ) + MATERIAL_DYNAMICS_TOOLSPEED_BOUND

	return round(1/((1/initial_toolspeed) + toolspeed_adjust),MATERIAL_DYNAMICS_TOOLSPEED_PRECISION)

