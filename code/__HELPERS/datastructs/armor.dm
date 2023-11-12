//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * armor datums for holding values
 * globally cached.
 */
/datum/armor
	/// just for vv
	var/name

	var/melee = 0
	var/melee_tier = ARMOR_TIER_DEFAULT
	var/melee_soak = 0
	var/melee_deflect = 0
	var/bullet = 0
	var/bullet_tier = ARMOR_TIER_DEFAULT
	var/bullet_soak = 0
	var/bullet_deflect = 0
	var/laser = 0
	var/laser_tier = ARMOR_TIER_DEFAULT
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

/datum/armor/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	if(var_name in global.armor_enums)
		return FALSE // no.
	return ..()

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
		"[round(melee * 100, 0.1)]@[melee_tier]-[melee_soak]^[melee_deflect]",
		"[round(bullet * 100, 0.1)]@[bullet_tier]-[bullet_soak]^[bullet_deflect]",
		"[round(laser * 100, 0.1)]@[laser_tier]-[laser_soak]^[laser_deflect]",
		"[round(energy * 100, 0.1)]",
		"[round(bomb * 100, 0.1)]",
		"[round(bio * 100, 0.1)]",
		"[round(rad * 100, 0.1)]",
		"[round(fire * 100, 0.1)]",
		"[round(acid * 100, 0.1)]",
	), " | ")

/datum/armor/proc/raw(flag)
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
			CRASH("Invalid flag: [flag]")

/datum/armor/proc/mitigation(flag, tier = ARMOR_TIER_DEFAULT)
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
			CRASH("Invalid flag: [flag]")

/datum/armor/proc/soak(flag)
	switch(flag)
		if(ARMOR_MELEE)
			return melee_soak
		if(ARMOR_BULLET)
			return bullet_soak
		if(ARMOR_LASER)
			return laser_soak
		else
			return 0

/datum/armor/proc/deflect(flag)
	switch(flag)
		if(ARMOR_MELEE)
			return melee_deflect
		if(ARMOR_BULLET)
			return bullet_deflect
		if(ARMOR_LASER)
			return laser_deflect
		else
			return 0

/datum/armor/proc/resultant_damage(damage, tier, flag)
	switch(flag)
		if(ARMOR_MELEE)
			if(!melee)
				return damage
			var/tdiff = melee_tier - tier
			damage = max(0, (tdiff? (damage * (1 - ARMOR_TIER_CALC(melee, tdiff))) : (damage * (1 - melee))) - melee_soak)
			if(damage <= melee_deflect)
				return 0
			return damage
		if(ARMOR_BULLET)
			if(!bullet)
				return damage
			var/tdiff = bullet_tier - tier
			damage = max(0, (tdiff? (damage * (1 - ARMOR_TIER_CALC(bullet, tdiff))) : (damage * (1 - bullet))) - bullet_soak)
			if(damage <= bullet_deflect)
				return 0
			return damage
		if(ARMOR_LASER)
			if(!laser)
				return damage
			var/tdiff = laser_tier - tier
			damage = max(0, (tdiff? (damage * (1 - ARMOR_TIER_CALC(laser, tdiff))) : (damage * (1 - laser))) - laser_soak)
			if(damage <= laser_deflect)
				return 0
			return damage
		if(ARMOR_ENERGY)
			return damage * (1 - energy)
		if(ARMOR_BOMB)
			return damage * (1 - bomb)
		if(ARMOR_BIO)
			return damage * (1 - bio)
		if(ARMOR_RAD)
			return damage * (1 - rad)
		if(ARMOR_FIRE)
			return damage * (1 - fire)
		if(ARMOR_ACID)
			return damage * (1 - acid)
		else
			CRASH("Invalid flag: [flag]")

/datum/armor/proc/describe_list()
	RETURN_TYPE(/list)
	. = list()
	. += "Melee: [round(melee * 100, 0.1)]% [melee_soak] flat @ [melee_tier] hardness"
	. += "Bullet: [round(bullet * 100, 0.1)]% [bullet_soak] flat @ [bullet_tier] hardness"
	. += "Laser: [round(laser * 100, 0.1)]% [laser_soak] flat @ [laser_tier] hardness"
	. += "Energy: [round(energy * 100, 0.1)]%"
	. += "Bomb: [round(bomb * 100, 0.1)]%"
	. += "Bio: [round(bio * 100, 0.1)]%"
	. += "Radiation: [round(rad * 100, 0.1)]%"
	. += "Thermal: [round(fire * 100, 0.1)]%"
	. += "Acid: [round(acid * 100, 0.1)]%"

/datum/armor/proc/log_string()
	var/list/built = list()
	var/list/ours = to_list()
	for(var/key in ours)
		built += "[key]: [ours[key]]"
	return jointext(built, ", ")

/**
 * returns a /datum/armor with the given values overwritten
 */
/datum/armor/proc/overwritten(list/values)
	return fetch_armor_struct(values | to_list())

/**
 * returns a /datum/armor with the given values adjusted
 */
/datum/armor/proc/adjusted(list/values)
	var/list/adjusting = to_list()
	for(var/key in adjusting)
		adjusting[key] = clamp(adjusting[key] + values[key], 0, 1)
	return fetch_armor_struct(adjusting)

/**
 * returns a /datum/armor with the given values overwritten but only if they were below
 */
/datum/armor/proc/boosted(list/values)
	var/list/boosting = to_list()
	for(var/key in boosting)
		if(values[key] > boosting[key])
			boosting[key] = clamp(values[key], 0, 1)
	return fetch_armor_struct(boosting)

/**
 * returns if we're atleast the values given, for the values given
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
