//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * An entry for a species organ preset.
 */
/datum/species_organ_entry
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

/datum/species_organ_entry/proc/create_organ() as /obj/item/organ
	

#warn impl all
