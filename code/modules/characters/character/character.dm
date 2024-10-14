//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * A character in the game.
 *
 * Can represent anything from a human to a cyborg.
 */
/datum/character
	/// character ID in the table
	///
	/// * for savefile / legacy characters, this will **not be set.**
	/// * if this is null, no persistence can proceed as we are operating in legacy / savefile mode.
	var/character_id

#warn impl

