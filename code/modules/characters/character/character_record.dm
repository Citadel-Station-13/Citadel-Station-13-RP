//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Base type of a character record.
 *
 * * Requires database backend.
 */
/datum/character_record
	/// string date of application
	///
	/// * set by serializer / deserializer; do not touch
	var/timestamp
	/// database ID
	///
	/// * set by serializer / deserializer; do not touch
	/// * this is global, not per-character.
	var/id

	/// flags
	///
	/// * directly serialized to DB
	var/character_record_flags = NONE

	/// real ckey of writer
	///
	/// * directly serialized to DB
	/// * this can be null if unknown.
	/// * this is not always accurate; the game tries to guess this from usually-accurate metrics.
	/// * if you're reading this as an admin, do your own investigation, seriously; don't follow this blindly.
	/// * this is OOC information and should never be viewable by players
	var/audit_player_id
	/// real character ID of writer
	///
	/// * directly serialized to DB
	/// * this can be null if unknown.
	/// * this is not always accurate; the game tries to guess this from usually-accurate metrics.
	/// * if you're reading this as an admin, do your own investigation, seriously; don't follow this blindly.
	/// * this is OOC information and should never be viewable by players
	var/audit_character_id

	// TODO: how do we record characters if names are not UIDs?

#warn impl

/datum/character_record/serialize()
	return list()

/datum/character_record/deserialize(list/data)
	return
