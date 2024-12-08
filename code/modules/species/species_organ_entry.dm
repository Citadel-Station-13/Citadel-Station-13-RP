//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * An entry for a species organ preset.
 */
/datum/species_organ_entry
	//* Set *//

	/// override biology
	///
	/// overrides:
	/// * species default biology
	///
	/// accepts:
	/// * typepath
	/// * instance
	var/datum/biology/override_biology
	/// override typepath
	///
	/// overrides:
	/// * biology default organ
	///
	/// accepts:
	/// * typepath
	var/override_type
	/// physiology modifiers to apply to just that limb
	///
	/// accepts (as a list of):
	/// * typepaths
	/// * instances
	var/list/physiology_modifiers

	//* Generated *//

	/// our name.
	///
	/// * if specified, this overrides normal organ name
	/// * if not specified, this will be generated on species init for the species's resultant organ caches.
	var/name

/datum/species_organ_entry/clone(include_contents)
	var/datum/species_organ_entry/cloning = new
	#warn impl

/datum/species_organ_entry/serialize()
	. = list()
	#warn impl

/datum/species_organ_entry/deserialize(list/data)
	#warn impl

/datum/species_organ_entry/proc/create_organ() as /obj/item/organ


#warn impl all
