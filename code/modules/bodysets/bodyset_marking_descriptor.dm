//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * data on a single instance of a /datum/prototype/bodyset_marking
 */
/datum/bodyset_marking_descriptor
	/// marking ID
	var/id
	/// color set
	var/color = "#ffffff"
	/// emissive strength 0 to 100
	var/emissive_strength = 0
	/// relative layer, -10 to 10 usually
	/// * trampled with a * 0.01, so technically -100 to 100 is valid, but -10 to 10 is an enforced
	///   constraint for players
	var/rel_layer

/datum/bodyset_marking_descriptor/New(datum/prototype/bodyset_marking/marking, color = "#ffffff", emissive_strength = 0, layer = 0)
	src.id = marking.id
	src.color = color
	src.emissive_strength = emissive_strength
	src.rel_layer = layer

// TODO: serialize/deserialize
