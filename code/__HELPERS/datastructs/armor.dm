/**
 * armor datums for holding values
 * globally cached.
 */
/datum/armor
	var/melee = 0
	var/bullet = 0
	var/laser = 0
	var/energy = 0
	var/bio = 0
	var/rad = 0

/datum/armor/vv_edit_var(var_name, var_value, mass_edit, raw_edit)
	if(var_name in global.armor_enums)
		return FALSE // no.
	return ..()

/datum/armor/proc/from_list(list/values)
	melee = values[AROMR_MELEE] || 0
	bullet = values[ARMOR_BULLET] || 0
	laser = values[ARMOR_LASER] || 0
	energy = values[ARMOR_ENERGY] || 0
	bomb = values[ARMOR_BOMB] || 0
	bio = values[ARMOR_BIO] || 0
	rad = values[ARMOR_RAD] || 0

/datum/armor/proc/to_list()
	return list(
		ARMOR_MELEE = melee,
		ARMOR_BULLET = bullet,
		ARMOR_LASER = laser,
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
