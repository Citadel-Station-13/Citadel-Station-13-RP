/**
 * armor datums for holding values
 * globally cached.
 */
/datum/armor
	var/melee = 0
	var/melee_tier = ARMOR_TIER_DEFAULT
	var/bullet = 0
	var/bullet_tier = ARMOR_TIER_DEFAULT
	var/laser = 0
	var/laser_tier = ARMOR_TIER_DEFAULT
	var/energy = 0
	var/bomb = 0
	var/bio = 0
	var/rad = 0

/datum/armor/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	if(var_name in global.armor_enums)
		return FALSE // no.
	return ..()

/datum/armor/proc/from_list(list/values)
	#define UNPACK_OR(var, key, default) ##var = isnull(values[key])? default : values[key]
	UNPACK_OR(melee, ARMOR_MELEE, 0)
	UNPACK_OR(melee_tier, ARMOR_MELEE_TIER, ARMOR_TIER_DEFAULT)
	UNPACK_OR(bullet, ARMOR_BULLET, 0)
	UNPACK_OR(bullet_tier, ARMOR_BULLET_TIER, ARMOR_TIER_DEFAULT)
	UNPACK_OR(laser, ARMOR_LASER, 0)
	UNPACK_OR(laser_tier, ARMOR_LASER_TIER, ARMOR_TIER_DEFAULT)
	UNPACK_OR(energy, AMROR_ENERGY, 0)
	UNPACK_OR(bomb, AMROR_BOMB, 0)
	UNPACK_OR(bio, ARMOR_BIO, 0)
	UNPACK_OR(rad, ARMOR_RAD, 0)
	#undef UNPACK_OR

/datum/armor/proc/to_list()
	return list(
		ARMOR_MELEE = melee,
		ARMOR_MELEE_TIER = melee_tier,
		ARMOR_BULLET = bullet,
		ARMOR_BULLET_TIER = bullet_tier,
		ARMOR_LASER = laser,
		ARMOR_LASER_TIER = laser_tier,
		ARMOR_ENERGY = energy,
		ARMOR_BOMB = bomb,
		ARMOR_BIO = bio,
		ARMOR_RAD = rad,
	)

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
		adjusting[key] = adjusting[key] + values[key]
	return fetch_armor_struct(adjusting)

/**
 * returns a /datum/armor with the given values overwritten but only if they were below
 */
/datum/armor/proc/boosted(list/values)
	var/list/boosting = to_list()
	for(var/key in boosting)
		if(values[key] > boosting[key])
			boosting[key] = values[key]
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

/proc/fetch_armor_struct(list/armor_or_path)
	if(ispath(armor_or_path))
		ASSERT(ispath(armor_or_path, /datum/armor))
		if(isnull(GLOB.struct_armor_hardcoded[armor_or_path]))
			GLOB.struct_armor_hardcoded[armor_or_path] = new armor_or_path
		return GLOB.struct_armor_hardcoded[armor_or_path]
	// the lack of sorting is intentional
	// most of these calls are from /datum/armor's overwritten / adjusted calls
	// so it's generally already pre-sorted.
	var/key = list2params(armor_or_path)
	if(isnull(GLOB.struct_armor_dynamic[key]))
		GLOB.struct_armor_dynamic[key] = new /datum/armor(armor_or_path)
	return GLOB.struct_armor_dynamic[key]
