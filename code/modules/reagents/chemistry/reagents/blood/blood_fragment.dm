//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Reagent blood data
 */
/datum/blood_fragment
	/// the blood's color
	var/color

	//! LEGACY FIELDS
	var/legacy_species
	var/legacy_blood_dna
	var/legacy_blood_type
	var/legacy_donor
	var/legacy_name
	//! END

/datum/blood_fragment/clone(include_contents)
	var/datum/blood_fragment/copy = new /datum/blood_fragment
	copy.color = color
	if(legacy_blood_dna)
		copy.legacy_blood_dna = legacy_blood_dna
	if(legacy_blood_type)
		copy.legacy_blood_type = legacy_blood_type
	if(legacy_donor)
		copy.legacy_donor = legacy_donor
	if(legacy_name)
		copy.legacy_name = legacy_name
	if(legacy_species)
		copy.legacy_species = legacy_species
	return copy

/**
 * Checks if other is equivalent to self.
 *
 * * We intentionally do not check color. It's too expensive to, given this is used for
 *   deduping.
 * * We intentionally do not check name. It's too expensive to, given this is used for
 *   deduping.
 * * This implies that color / name should implicitly be the same if this proc returns TRUE
 *   for two given blood fragments.
 */
/datum/blood_fragment/proc/equivalent(datum/blood_fragment/other)
	if(other.legacy_species != src.legacy_species)
		return FALSE
	if(other.legacy_blood_dna != src.legacy_blood_dna)
		return FALSE
	if(other.legacy_blood_type != src.legacy_blood_type)
		return FALSE
	return TRUE

/**
 * Checks if other is compatible with self.
 *
 * * This is **not** a symmetric relation. Some bloods are universally compatible with others,
 *   and accept everything.
 * * This means that if host is not compatible with donor, but donor is compatible with host,
 *   the host attacks the donoar, even if the donor wouldn't if it was reversed.
 */
/datum/blood_fragment/proc/compatible_with_self(datum/blood_fragment/other)
	return legacy_blood_compatible_with_self(legacy_blood_type, other.legacy_blood_type, legacy_species, other.legacy_species)

/proc/legacy_blood_compatible_with_self(our_blood_type, their_blood_type, our_species_name, their_species_name)
	// todo: remove species check, we have dumb xeno-compatibility-like canon anyways
	if(our_species_name && their_species_name && (their_species_name != our_species_name))
		return FALSE

	var/our_antigen = copytext(our_blood_type, 1, length(our_blood_type))
	var/their_antigen = copytext(their_blood_type, 1, length(their_blood_type))

	var/static/antigen_incompatible_matrix = list(
		"AB" = list(),
		"A" = list("AB" = TRUE, "B" = TRUE),
		"B" = list("AB" = TRUE, "A" = TRUE),
		"O" = list("AB" = TRUE, "A" = TRUE, "B" = TRUE),
	)
	if(antigen_incompatible_matrix[our_antigen]?[their_antigen])
		return FALSE

	var/our_rh = our_blood_type[length(our_blood_type)] == "+"
	var/their_rh = their_blood_type[length(their_blood_type)] == "+"

	if(their_rh && !our_rh)
		return FALSE

	return TRUE
