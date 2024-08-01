//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

GLOBAL_LIST_INIT(calibers, init_calibers())

/proc/init_calibers()
	. = list()
	GLOB.calibers = .
	for(var/datum/caliber/path as anything in subtypesof(/datum/caliber))
		if(initial(path.abstract_type) == path)
			continue
		var/datum/caliber/created = new path
		.[created.type] = created
		.[created.caliber] = created

/proc/resolve_caliber(datum/caliber/caliberlike)
	RETURN_TYPE(/datum/caliber)
	if(istext(caliberlike))
		return GLOB.calibers[caliberlike]
	if(ispath(caliberlike))
		return GLOB.calibers[caliberlike]
	if(istype(caliberlike))
		return caliberlike

/**
 * desc wip
 *
 * welcome to hell: brought to you by a webdev
 *
 * naming convention: c[whatever] for the caliber, subtype to a[whatever] for different ammo lengths
 *
 * direct subtypes of /datum/caliber should be for diameter, usually,
 * and length subtypes go from the diameter subtype.
 */
/datum/caliber
	abstract_type = /datum/caliber
	/// caliber string
	var/caliber
	/// does dynamic measurements
	var/measured
	/// width in millimeters
	var/diameter
	/// length in millimeters, if known; if not known / unbounded, this is null
	var/length

/datum/caliber/New()
	if(isnull(measured))
		measured = !isnull(diameter) && !isnull(length)

/**
 * checks if other caliber is smaller or equal to this one
 */
/datum/caliber/proc/smaller_or_equal(datum/caliber/other)
	return other.caliber == caliber || (measured && other.measured && ((other.diameter <= diameter) && (other.length <= length)))

/**
 * checks if other caliber is same diameter as this one
 */
/datum/caliber/proc/equivalent_diameter(datum/caliber/other)
	return other.caliber == caliber || (measured && other.measured && (other.diameter == diameter))

/**
 * checks if other caliber is equivalent to us
 */
/datum/caliber/proc/equivalent(datum/caliber/other)
	return other.caliber == caliber || (measured && other.measured && (other.diameter == diameter) && (other.length == length))
