//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * structured memory storage
 * * for /datum/mind but technically is just a datastructure
 * * should be flat; all behavior on base types. subtypes are there for ease of use with new().
 */
/datum/memory
	/// a key; if set, we are keyed. this should not be modified once inserted into /datum/mind.
	var/key
	/// priority; higher ones are up top; lower is higher.
	/// this should not be modified once inserted into /datum/mind without using helpers.
	var/priority = 0
	/// removable, in the context of what it's in
	/// * if you don't want the player to forget this, set this to TRUE
	var/can_delete = TRUE
	/// memory types
	var/memory_class = MEMORY_CLASS_GENERIC

	/// content type
	/// * for the love of god do not allow players to put in html content themselves
	var/content_type
	/// content, as per content type; serialized directly to tgui
	var/content

/datum/memory/clone()
	var/datum/memory/cloned = new /datum/memory
	cloned.key = key
	cloned.priority = priority
	cloned.can_delete = can_delete
	cloned.content_type = content_type
	cloned.content = content
	return cloned

// todo: serialize / deserialize

/datum/memory/proc/ui_memory_data()
	return list(
		"key" = key,
		"priority" = priority,
		"canDelete" = can_delete,
		"contentType" = content_type,
		"content" = content,
	)

/datum/memory/textual/New(text)
	src.content_type = MEMORY_CONTENT_TYPE_TEXT
	src.content = text

/datum/memory/unsafe_html/New(html)
	src.content_type = MEMORY_CONTENT_TYPE_HTML
	src.content = html
