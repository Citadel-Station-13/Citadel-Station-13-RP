//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/character_note
	/// database ID
	/// * set by system; do not touch
	/// * this is global, not per-character
	var/id
	/// database ID of character
	var/character_id
	/// timestamp this was created on
	/// * this is OOC time as UTC
	var/timestamp_created
	/// timestamp this was modified on
	/// * this is OOC time as UTC
	var/timestamp_edited

	/// string date-time this was applied on
	/// * this is IC time
	var/n_timestamp
	/// label; short description
	var/n_label
	/// is content plaintext?
	/// todo: for now, everything is CHARACTER_RECORD_CONTENT_TYPE_PLAINTEXT,
	///       rich-er content support comes later
	var/n_content_type = CHARACTER_NOTE_CONTENT_TYPE_PLAINTEXT
	/// text; long description
	var/n_content

#warn impl
