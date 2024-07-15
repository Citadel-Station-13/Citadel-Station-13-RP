//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * data on a single instance of a /datum/bodyset_marking
 */
/datum/bodyset_marking_descriptor
	/// marking ID
	var/id
	/// color set
	var/color = "#ffffff"
	/// emissive strength 0 to 100
	var/emissive_strength = 0

/datum/bodyset_marking_descriptor/New(datum/bodyset_marking/marking, color = "#ffffff", emissive_strength = 0)
	src.id = marking.id
	src.color = color
	src.emissive_strength = emissive_strength
