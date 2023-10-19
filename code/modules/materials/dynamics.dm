//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* Page has all balancing parameters + algorithms for dynamic attribute computations for things like armor

/**
 * creates an armor datum based off of our stats
 *
 * @params
 * * significance - relative amount of this material used should be a multiplier of MATERIAL_SIGNIFICANCE_BASELINE
 * * mob_armor - is this going to be used as mob armor? mob armor generally won't have vulnerability.
 *
 * @return /datum/armor instance
 */
/datum/material/proc/create_armor(significance = MATERIAL_SIGNIFICANCE_BASELINE, mob_armor)
	var/cache_key = "[significance]_[!!mob_armor]"
	if(!isnull(armor_cache[cache_key]))
		return armor_cache[cache_key]

	//! Not even Desmos will save you now. !//
	// absorbing kinetic energy
	var/kinetic_damping = toughness * ((density ** 0.5) * (1 / 3))
	// stopping kinetic penetrators
	var/kinetic_hardness = hardness * ((density ** 0.5) * (1 / 8) + 0.7)
	// absorbing energy blasts
	var/ablation_damping =
	// spreading energy blasts from going through
	var/ablation_diffusion =
	// exotic 'energy' armor
	var/exotic_absorption =
	// bomb values : from kinetic damping and hardness
	var/direct_bomb =
	// direct values
	// todo: integrate significance
	var/direct_bio = relative_permeability > 1? -relative_permeability : relative_permeability
	// todo: integrate significance
	var/direct_acid = relative_reactivity > 1? -relative_reactivity : relative_reactivity
	// todo: integrate significance
	var/direct_fire = relative_reactivity > 1? -relative_reactivity : relative_reactivity
	var/direct_rad = (density * (1 / 16))**2 * ((MATERIAL_SIGNIFICANCE_BASELINE + (significance - MATERIAL_SIGNIFICANCE_BASELINE)) * 0.1)
	#warn FUCK
	// we don't allow deflection for now
	return (armor_cache = fetch_armor_struct(list(
		ARMOR_MELEE = ,
		ARMOR_MELEE_TIER = ,
		ARMOR_MELEE_SOAK = ,
		ARMOR_BULLET = ,
		ARMOR_BULLET_TIER = ,
		ARMOR_BULLET_SOAK = ,
		ARMOR_LASER = ,
		ARMOR_LASER_TIER = ,
		ARMOR_LASER_SOAK = ,
		ARMOR_BOMB = direct_bomb,
		ARMOR_BIO = direct_bio,
		ARMOR_ACID = direct_acid,
		ARMOR_FIRE = direct_fire,
		ARMOR_RAD = direct_rad,
	)))

/**
 * combines multiple material armors into one
 *
 * @params
 * * materials - material instances associated to significance.
 *
 * @return /datum/armor instance
 */
/datum/controller/subsystem/materials/proc/combined_materials_armor(list/datum/material/materials)
	#warn impl - this requires caching

/**
 * combines multiple material armors into one
 * used for reinforcing / whatevers
 *
 * @params
 * * materials - material instances associated to significance. first is lowest; put exterior armors on last!
 *
 * @return /datum/armor instance
 */
/datum/controller/subsystem/materials/proc/reinforcing_materials_armor(list/datum/material/materials)
	#warn impl - this requires caching

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
/datum/material/proc/melee_stats(initial_modes, significance = MATERIAL_SIGNIFICANCE_BASELINE)
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
		var/damage = (MATERIAL_DYNAMICS_DAMAGE_CEILING / (1 + (NUM_E ** -(MATERIAL_DYNAMICS_DAMAGE_LOGISTIC * ((regex_this_hardness * MATERIAL_DYNAMICS_DAMAGE_INTENSIFIER * MATERIAL_SIGNIFICANCE_TO_DAMAGE_INTENSIFIER(significance) * MATERIAL_DENSITY_TO_DAMAGE_INTENSIFIER(density) - MATERIAL_DYNAMICS_DAMAGE_SHIFT) / MATERIAL_DYNAMICS_DAMAGE_DIVISOR)))))
		var/tier = (( \
			  (MATERIAL_DYNAMICS_DAMTIER_CEILING * 2) \
			/ (1 + NUM_E ** -( \
				MATERIAL_DYNAMICS_DAMTIER_LOGISTIC * \
				((regex_this_hardness * MATERIAL_DYNAMICS_DAMTIER_INTENSIFIER * MATERIAL_SIGNIFICANCE_TO_DAMAGE_INTENSIFIER(significance) * MATERIAL_DENSITY_TO_DAMAGE_INTENSIFIER(density) - MATERIAL_DYNAMICS_DAMTIER_SHIFT) / MATERIAL_DYNAMICS_DAMTIER_DIVISOR) \
			)) \
		) - MATERIAL_DYNAMICS_DAMTIER_CEILING + MATERIAL_DYNAMICS_DAMTIER_ADJUST ) * MATERIAL_DYNAMICS_DAMTIER_SCALER
		.[MATERIAL_MELEE_STATS_DAMAGE] = damage
		.[MATERIAL_MELEE_STATS_TIERMOD] = tier
	else
		// use toughness, density
		.[MATERIAL_MELEE_STATS_FLAG] = ARMOR_MELEE
		.[MATERIAL_MELEE_STATS_MODE] = initial_modes
		var/damage = (MATERIAL_DYNAMICS_DAMAGE_CEILING / (1 + (NUM_E ** -(MATERIAL_DYNAMICS_DAMAGE_LOGISTIC * ((toughness * MATERIAL_DYNAMICS_DAMAGE_INTENSIFIER * MATERIAL_SIGNIFICANCE_TO_DAMAGE_INTENSIFIER(significance) * MATERIAL_DENSITY_TO_DAMAGE_INTENSIFIER(density) - MATERIAL_DYNAMICS_DAMAGE_SHIFT) / MATERIAL_DYNAMICS_DAMAGE_DIVISOR)))))
		.[MATERIAL_MELEE_STATS_DAMAGE] = damage
		var/tier = (( \
			  (MATERIAL_DYNAMICS_DAMTIER_CEILING * 2) \
			/ (1 + NUM_E ** -( \
				MATERIAL_DYNAMICS_DAMTIER_LOGISTIC * \
				((toughness * MATERIAL_DYNAMICS_DAMTIER_INTENSIFIER * MATERIAL_SIGNIFICANCE_TO_DAMAGE_INTENSIFIER(significance) * MATERIAL_DENSITY_TO_DAMAGE_INTENSIFIER(density) - MATERIAL_DYNAMICS_DAMTIER_SHIFT) / MATERIAL_DYNAMICS_DAMTIER_DIVISOR) \
			)) \
		) - MATERIAL_DYNAMICS_DAMTIER_CEILING + MATERIAL_DYNAMICS_DAMTIER_ADJUST ) * MATERIAL_DYNAMICS_DAMTIER_SCALER
		.[MATERIAL_MELEE_STATS_TIERMOD] = tier

	melee_cache[cache_key] = .

