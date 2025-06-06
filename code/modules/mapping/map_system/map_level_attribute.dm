//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Attributes must either be text or numbers.
 */
/datum/map_level_attribute
	/// our enum
	var/id
	/// description
	var/desc = "Some kind of attribute."
	/// allow admin editing
	var/allow_edit = FALSE
	/// numeric?
	var/numeric = FALSE
