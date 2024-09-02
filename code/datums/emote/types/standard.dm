//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * General handling for SFX / VFX / a lot of other stuff
 */
/datum/emote/standard
	abstract_type = /datum/emote/standard

	//* Feedback *//

	/// outgoing saycode type flags
	var/feedback_saycode_type = SAYCODE_TYPE_VISIBLE

	//* SFX *//

	/// sound to play
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

#warn impl


