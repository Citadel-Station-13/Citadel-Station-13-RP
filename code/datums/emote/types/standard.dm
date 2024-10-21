//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * General handling for SFX / VFX / a lot of other stuff
 */
/datum/emote/standard
	abstract_type = /datum/emote/standard

	//* SFX *//

	/// sound to play, or a list of sounds to pick from (equal weight)
	var/sfx
	/// volume of sound to play
	var/sfx_volume = 75
	/// vary the sound?
	var/sfx_vary = TRUE
	/// extra range
	///
	/// todo: legacy; playsound should allow specifying range directly.
	var/sfx_extra_range = 0

	//* VFX *//

	// todo: vfx support

/**
 * Gets a SFX to play.
 */
/datum/emote/standard/proc/get_sfx(datum/event_args/actor/actor, list/arbitrary)
	return islist(sfx) ? (length(sfx) ? pick(sfx) : null) : sfx

#warn impl


