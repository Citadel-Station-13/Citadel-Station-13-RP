//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Base type of a character record.
 *
 * * Requires database backend.
 */
/datum/character_record
	/// database ID
	///
	/// * set by serializer / deserializer; do not touch
	/// * this is global, not per-character.
	var/id

	/// flags
	///
	/// * directly serialized to DB
	var/character_record_flags = NONE
	/// type
	///
	/// * directly serialized to DB
	/// * determines datum typepath!!
	var/character_record_type

	//* audit fields *//

	/// string date of application
	///
	/// * set by serializer / deserializer; do not touch
	var/audit_timestamp
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
	#warn these are logs, not fields on the record itself.

	//* common record fields *//

	/// string date-time this was applied on
	///
	/// * this is IC time
	var/r_timestamp
	/// location; where was this added?
	var/r_location
	/// label; short description
	var/r_label
	/// is content plaintext?
	///
	/// todo: for now, everything is CHARACTER_RECORD_CONTENT_TYPE_PLAINTEXT,
	///       rich-er content support comes later
	var/r_content_type = CHARACTER_RECORD_CONTENT_TYPE_PLAINTEXT
	/// text; long description
	var/r_content
	/// author character id
	///
	/// * set by serializer / deserializer, do not touch
	var/r_author_character_id

	// TODO: how do we record characters if names are not UIDs?

#warn impl

/datum/character_record/serialize()
	return list()

/datum/character_record/deserialize(list/data)
	return
