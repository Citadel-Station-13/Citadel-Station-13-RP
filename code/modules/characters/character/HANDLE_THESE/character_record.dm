//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Base type of a character record.
 *
 * * Requires database backend.
 */
/datum/character_record
	/// database ID
	/// * set by serializer / deserializer; do not touch
	/// * this is global, not per-character.
	var/id
	/// database ID of character
	var/character_id
	/// timestamp this was created on
	/// * this is OOC time as UTC
	var/timestamp_created
	/// timestamp this was modified on
	/// * this is OOC time as UTC
	var/timestamp_edited

	/// flags
	/// * directly serialized to DB
	var/character_record_flags = NONE
	/// type
	/// * directly serialized to DB
	var/character_record_type

	//* record fields *//

	/// string date-time this was applied on
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

/datum/character_record/New(record_type)
	ASSERT(istext(record_type))

	src.character_record_type = record_type

#warn impl; how do we do this?

/datum/character_record/serialize()
	return list()

/datum/character_record/deserialize(list/data)
	return
