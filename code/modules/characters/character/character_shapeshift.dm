//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Not truly used in the character module, but this is such an useful utility
 * for shapeshifters and disguising functionalities for both crew and antagonists.
 *
 * * This basically lets you use the datastructures of the character API to
 *   describe and transform a mob, make fake clothing, etc.
 */
/datum/character_shapeshift
	/// character appearance
	var/datum/character_appearance/body
	#warn how to deal with clothing
