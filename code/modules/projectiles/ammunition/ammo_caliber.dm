//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

GLOBAL_LIST_INIT(calibers, init_calibers())

/proc/init_calibers()
	. = list()
	GLOB.calibers = .
	for(var/datum/ammo_caliber/path as anything in subtypesof(/datum/ammo_caliber))
		if(initial(path.abstract_type) == path)
			continue
		var/datum/ammo_caliber/created = new path
		.[created.type] = created
		.[created.id] = created
		if(created.caliber && created.caliber != created.id)
			if(.[created.caliber])
				stack_trace("collision between [path] and [.[created.caliber]:type] for caliber [created.caliber]")
			.[created.caliber] = created

/proc/resolve_caliber(datum/ammo_caliber/caliberlike)
	RETURN_TYPE(/datum/ammo_caliber)
	if(istext(caliberlike))
		return GLOB.calibers[caliberlike]
	if(ispath(caliberlike))
		return GLOB.calibers[caliberlike]
	if(istype(caliberlike))
		return caliberlike

/**
 * desc wip
 *
 * todo: make this a /prototype
 *
 * welcome to hell: brought to you by a webdev
 *
 * naming convention: c[whatever] for the caliber, subtype to a[whatever] for different ammo lengths
 *
 * direct subtypes of /datum/ammo_caliber should be for diameter, usually,
 * and length subtypes go from the diameter subtype.
 */
/datum/ammo_caliber
	abstract_type = /datum/ammo_caliber
	/// id ; must be unique
	var/id
	/// display name, if any; this is allowed to be null
	var/name
	/// caliber string
	var/caliber
	/// both diameter / length are set, which means we can do dynamic measurements
	var/measured
	/// width in millimeters
	var/diameter
	/// length in millimeters, if known; if not known / unbounded, this is null
	var/length

/datum/ammo_caliber/New()
	if(isnull(measured))
		measured = !isnull(diameter) && !isnull(length)

/**
 * checks if other caliber is smaller or equal to this one
 */
/datum/ammo_caliber/proc/smaller_or_equal(datum/ammo_caliber/other)
	return other.caliber == caliber || (measured && other.measured && ((other.diameter <= diameter) && (other.length <= length)))

/**
 * checks if other caliber is same diameter as this one
 */
/datum/ammo_caliber/proc/equivalent_diameter(datum/ammo_caliber/other)
	return other.caliber == caliber || (measured && other.measured && (other.diameter == diameter))

/**
 * checks if other caliber is equivalent to us
 */
/datum/ammo_caliber/proc/equivalent(datum/ammo_caliber/other)
	return other.id == id || other.caliber == caliber || (measured && other.measured && (other.diameter == diameter) && (other.length == length))
