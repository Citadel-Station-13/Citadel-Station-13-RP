//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * armor datums for holding values
 * globally cached.
 */
/datum/armor
	/// just for vv
	/// TODO: don't need name?
	var/name

	/**
	 * static randomization; all armor will be multiplied by `rand(-percent, percent) * 100`
	 */
	var/randomization_percent = 25

	var/melee = 0
	var/melee_tier = MELEE_TIER_DEFAULT
	var/melee_soak = 0
	var/melee_deflect = 0
	var/bullet = 0
	var/bullet_tier = BULLET_TIER_DEFAULT
	var/bullet_soak = 0
	var/bullet_deflect = 0
	var/laser = 0
	var/laser_tier = LASER_TIER_DEFAULT
	var/laser_soak = 0
	var/laser_deflect = 0
	var/energy = 0
	var/bomb = 0
	var/bio = 0
	var/rad = 0
	var/fire = 0
	var/acid = 0

/datum/armor/New(list/from_values)
	if(from_values)
		from_list(from_values)
	name = to_name()

/datum/armor/proc/from_list(list/values)
	#define UNPACK_OR(var, key, default) ##var = isnull(values[key])? default : values[key]
	UNPACK_OR(melee, ARMOR_MELEE, 0)
	UNPACK_OR(melee_tier, ARMOR_MELEE_TIER, ARMOR_TIER_DEFAULT)
	UNPACK_OR(melee_soak, ARMOR_MELEE_SOAK, 0)
	UNPACK_OR(melee_deflect, ARMOR_MELEE_DEFLECT, 0)
	UNPACK_OR(bullet, ARMOR_BULLET, 0)
	UNPACK_OR(bullet_tier, ARMOR_BULLET_TIER, ARMOR_TIER_DEFAULT)
	UNPACK_OR(bullet_soak, ARMOR_BULLET_SOAK, 0)
	UNPACK_OR(bullet_deflect, ARMOR_BULLET_DEFLECT, 0)
	UNPACK_OR(laser, ARMOR_LASER, 0)
	UNPACK_OR(laser_tier, ARMOR_LASER_TIER, ARMOR_TIER_DEFAULT)
	UNPACK_OR(laser_soak, ARMOR_LASER_SOAK, 0)
	UNPACK_OR(laser_deflect, ARMOR_LASER_DEFLECT, 0)
	UNPACK_OR(energy, ARMOR_ENERGY, 0)
	UNPACK_OR(bomb, ARMOR_BOMB, 0)
	UNPACK_OR(bio, ARMOR_BIO, 0)
	UNPACK_OR(rad, ARMOR_RAD, 0)
	UNPACK_OR(fire, ARMOR_FIRE, 0)
	UNPACK_OR(acid, ARMOR_ACID, 0)
	#undef UNPACK_OR

/datum/armor/proc/to_list()
	return list(
		ARMOR_MELEE = melee,
		ARMOR_MELEE_TIER = melee_tier,
		ARMOR_MELEE_SOAK = melee_soak,
		ARMOR_MELEE_DEFLECT = melee_deflect,
		ARMOR_BULLET = bullet,
		ARMOR_BULLET_TIER = bullet_tier,
		ARMOR_BULLET_SOAK = bullet_soak,
		ARMOR_BULLET_DEFLECT = bullet_deflect,
		ARMOR_LASER = laser,
		ARMOR_LASER_TIER = laser_tier,
		ARMOR_LASER_SOAK = laser_soak,
		ARMOR_LASER_DEFLECT = laser_deflect,
		ARMOR_ENERGY = energy,
		ARMOR_BOMB = bomb,
		ARMOR_BIO = bio,
		ARMOR_RAD = rad,
		ARMOR_FIRE = fire,
		ARMOR_ACID = acid,
	)

/datum/armor/proc/to_name()
	return jointext(list(
		"MEL [round(melee * 100, 0.1)]@[melee_tier]-[melee_soak]^[melee_deflect]",
		"BUL [round(bullet * 100, 0.1)]@[bullet_tier]-[bullet_soak]^[bullet_deflect]",
		"LAS [round(laser * 100, 0.1)]@[laser_tier]-[laser_soak]^[laser_deflect]",
		"ERG [round(energy * 100, 0.1)]",
		"BOM [round(bomb * 100, 0.1)]",
		"BIO [round(bio * 100, 0.1)]",
		"RAD [round(rad * 100, 0.1)]",
		"FIR [round(fire * 100, 0.1)]",
		"ACD [round(acid * 100, 0.1)]",
	), " | ")

/datum/armor/proc/get_mitigation(flag)
	switch(flag)
		if(ARMOR_MELEE)
			return melee
		if(ARMOR_MELEE_SOAK)
			return melee_soak
		if(ARMOR_MELEE_TIER)
			return melee_tier
		if(ARMOR_MELEE_DEFLECT)
			return melee_deflect
		if(ARMOR_BULLET)
			return bullet
		if(ARMOR_BULLET_SOAK)
			return bullet_soak
		if(ARMOR_BULLET_TIER)
			return bullet_tier
		if(ARMOR_BULLET_DEFLECT)
			return bullet_deflect
		if(ARMOR_LASER)
			return laser
		if(ARMOR_LASER_SOAK)
			return laser_soak
		if(ARMOR_LASER_TIER)
			return laser_tier
		if(ARMOR_LASER_DEFLECT)
			return laser_deflect
		if(ARMOR_ENERGY)
			return energy
		if(ARMOR_BOMB)
			return bomb
		if(ARMOR_BIO)
			return bio
		if(ARMOR_RAD)
			return rad
		if(ARMOR_FIRE)
			return fire
		if(ARMOR_ACID)
			return acid
		else
			return 0

/datum/armor/proc/get_tier(flag)
	switch(flag)
		if(ARMOR_MELEE)
			return melee_tier
		if(ARMOR_BULLET)
			return bullet_tier
		if(ARMOR_LASER)
			return laser_tier
		else
			return 0

/datum/armor/proc/get_soak(flag)
	switch(flag)
		if(ARMOR_MELEE)
			return melee_soak
		if(ARMOR_BULLET)
			return bullet_soak
		if(ARMOR_LASER)
			return laser_soak
		else
			return 0

/datum/armor/proc/get_deflect(flag)
	switch(flag)
		if(ARMOR_MELEE)
			return melee_deflect
		if(ARMOR_BULLET)
			return bullet_deflect
		if(ARMOR_LASER)
			return laser_deflect
		else
			return 0

/datum/armor/proc/get_tiered_mitigation(flag, tier = ARMOR_TIER_DEFAULT)
	switch(flag)
		if(ARMOR_MELEE)
			var/tdiff = melee_tier - tier
			return 1 - ARMOR_TIER_CALC(melee, tdiff)
		if(ARMOR_BULLET)
			var/tdiff = bullet_tier - tier
			return 1 - ARMOR_TIER_CALC(bullet, tdiff)
		if(ARMOR_LASER)
			var/tdiff = laser_tier - tier
			return 1 - ARMOR_TIER_CALC(laser, tdiff)
		if(ARMOR_ENERGY)
			return energy
		if(ARMOR_BOMB)
			return bomb
		if(ARMOR_BIO)
			return bio
		if(ARMOR_RAD)
			return rad
		if(ARMOR_FIRE)
			return fire
		if(ARMOR_ACID)
			return acid
		else
			return 0

/**
 * The big, bad proc that deals with inbound shieldcalls.
 */
/datum/armor/proc/handle_shieldcall(list/shieldcall_args, fake_attack)
	var/modified_damage = resultant_damage(
		shieldcall_args[SHIELDCALL_ARG_DAMAGE],
		shieldcall_args[SHIELDCALL_ARG_DAMAGE_TIER],
		shieldcall_args[SHIELDCALL_ARG_DAMAGE_FLAG],
		shieldcall_args[SHIELDCALL_ARG_DAMAGE_MODE] & DAMAGE_MODE_REQUEST_ARMOR_RANDOMIZATION,
	)
	shieldcall_args[SHIELDCALL_ARG_DAMAGE] = round(modified_damage, DAMAGE_PRECISION)
	if(shieldcall_args[SHIELDCALL_ARG_DAMAGE_MODE] & DAMAGE_MODE_REQUEST_ARMOR_BLUNTING)
		var/effective_blunt_tierdiff
		switch(shieldcall_args[SHIELDCALL_ARG_DAMAGE_FLAG])
			if(ARMOR_MELEE)
				effective_blunt_tierdiff = melee_tier - shieldcall_args[SHIELDCALL_ARG_DAMAGE_TIER]
			if(ARMOR_BULLET)
				effective_blunt_tierdiff = bullet_tier - shieldcall_args[SHIELDCALL_ARG_DAMAGE_TIER]
			if(ARMOR_LASER)
				effective_blunt_tierdiff = laser_tier - shieldcall_args[SHIELDCALL_ARG_DAMAGE_TIER]
		var/blunt_chance = ARMOR_TIER_BLUNT_CHANCE(effective_blunt_tierdiff)
		if(prob(blunt_chance))
			shieldcall_args[SHIELDCALL_ARG_DAMAGE_MODE] &= DAMAGE_MODES_BLUNTED_BY_ARMOR

/datum/armor/proc/resultant_damage(damage, tier, flag, randomize)
	var/effective_armor
	var/effective_soak
	var/effective_deflect

	switch(flag)
		if(ARMOR_MELEE)
			if(!melee)
				return damage
			effective_armor = armor_tier_calculation(melee, melee_tier - tier)
			effective_soak = melee_soak
			effective_deflect = melee_deflect
		if(ARMOR_BULLET)
			if(!bullet)
				return damage
			effective_armor = armor_tier_calculation(bullet, bullet_tier - tier)
			effective_soak = bullet_soak
			effective_deflect = bullet_deflect
		if(ARMOR_LASER)
			if(!laser)
				return damage
			effective_armor = armor_tier_calculation(laser, laser_tier - tier)
			effective_soak = laser_soak
			effective_deflect = laser_deflect
		if(ARMOR_ENERGY)
			effective_armor = energy
		if(ARMOR_BOMB)
			effective_armor = bomb
		if(ARMOR_BIO)
			effective_armor = bio
		if(ARMOR_RAD)
			effective_armor = rad
		if(ARMOR_FIRE)
			effective_armor = fire
		if(ARMOR_ACID)
			effective_armor = acid

	if(randomize)
		effective_armor = effective_armor * (1 + rand(-randomization_percent, randomization_percent) * 0.01)

	damage = max(0, damage * (1 - effective_armor) - effective_soak)
	if(damage < effective_deflect)
		return 0
	return damage

/**
 * Output should be monospaced if possible.
 * * This is expensive, please try to use describe_data_list() instead.
 */
/datum/armor/proc/describe_english_list() as /list
	RETURN_TYPE(/list)
	. = list()
	. += "-- % (mitigation) @ (tier) - (soak) ^ (deflect) --"
	. += "Melee:     [string_leftpad(round(melee * 100), 3)]% @ [melee_tier] -[melee_soak] ^[melee_deflect]"
	. += "Bullet:    [string_leftpad(round(bullet * 100), 3)]% @ [bullet_tier] -[bullet_soak] ^[bullet_deflect]"
	. += "Laser:     [string_leftpad(round(laser * 100), 3)]% @ [laser_tier] -[laser_soak] ^[laser_deflect]"
	. += "Energy:    [string_leftpad(round(energy * 100), 3)]%"
	. += "Bomb:      [string_leftpad(round(bomb * 100), 3)]%"
	. += "Bio:       [string_leftpad(round(bio * 100), 3)]%"
	. += "Radiation: [string_leftpad(round(rad * 100), 3)]%"
	. += "Thermal:   [string_leftpad(round(fire * 100), 3)]%"
	. += "Acid:      [string_leftpad(round(acid * 100), 3)]%"

/datum/armor/proc/describe_data_list() as /list
	RETURN_TYPE(/list)
	return to_list()

/datum/armor/proc/log_string()
	var/list/built = list()
	var/list/ours = to_list()
	for(var/key in ours)
		built += "[key]: [ours[key]]"
	return jointext(built, ", ")

/// tier_diff is tier difference of armor against attack; positive = armor is higher tier.
/// * see https://www.desmos.com/calculator/6uu1djsawl
/// * armor at or below 0 (added damage) are passed back without change
/datum/armor/proc/armor_tier_calculation(mit_ratio, tier_diff)
	if(mit_ratio <= 0)
		return 0
	if(!tier_diff)
		return mit_ratio
	if(tier_diff > 0)
		var/a = mit_ratio * (tier_diff + 1)
		return max(a / sqrt(2 + a ** 2), mit_ratio)
	else
		return mit_ratio / (1 + (((-tier_diff) ** 17.5) / 1.75))

/**
 * returns a /datum/armor with the given values overwritten
 */
/datum/armor/proc/overwritten(list/values)
	return fetch_armor_struct(values | to_list())

/**
 * returns a /datum/armor with the given values adjusted
 * * adjusting is linear / additive
 */
/datum/armor/proc/adjusted(list/values)
	var/list/adjusting = to_list()
	for(var/key in adjusting)
		adjusting[key] = clamp(adjusting[key] + values[key], 0, 1)
	return fetch_armor_struct(adjusting)

/**
 * returns a /datum/armor with the given values overwritten but only if they were below
 * * boosts with max()
 */
/datum/armor/proc/boosted(list/values)
	var/list/boosting = to_list()
	for(var/key in boosting)
		if(values[key] > boosting[key])
			boosting[key] = clamp(values[key], 0, 1)
	return fetch_armor_struct(boosting)

/**
 * returns if we're atleast the values given, for the values given
 * * checks all values
 */
/datum/armor/proc/is_atleast(list/values)
	var/list/us = to_list()
	for(var/key in values)
		if(us[key] < values[key])
			return FALSE
	return TRUE

GLOBAL_LIST_EMPTY(struct_armor_hardcoded)
GLOBAL_LIST_EMPTY(struct_armor_dynamic)

/**
 * fetches armor datum
 *
 * @params
 * * armor_or_path - either a path to an armor datum, an armor datum instance, or a list of armor values
 *
 * @return an armor datum; if a datum was passed in, it is passed back without replacement.
 */
/proc/fetch_armor_struct(list/armor_or_path)
	if(ispath(armor_or_path))
		ASSERT(ispath(armor_or_path, /datum/armor))
		if(isnull(GLOB.struct_armor_hardcoded[armor_or_path]))
			GLOB.struct_armor_hardcoded[armor_or_path] = new armor_or_path
		return GLOB.struct_armor_hardcoded[armor_or_path]
	if(istype(armor_or_path, /datum/armor))
		return armor_or_path
	// the lack of sorting is intentional
	// most of these calls are from /datum/armor's overwritten / adjusted calls
	// so it's generally already pre-sorted.
	var/key = list2params(armor_or_path)
	if(isnull(GLOB.struct_armor_dynamic[key]))
		GLOB.struct_armor_dynamic[key] = new /datum/armor(armor_or_path)
	return GLOB.struct_armor_dynamic[key]
