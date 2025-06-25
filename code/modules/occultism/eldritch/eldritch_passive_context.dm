//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * State holder for passives, as they're singletons.
 */
/datum/eldritch_passive_context
	/// currently enabled?
	var/enabled = TRUE

	/// granted from knowledge ids; once all of these are gone, we are removed
	/// * not serialized
	var/tmp/list/granted_from_knowledge_ids

// todo: ser/de
// todo: clone

/datum/eldritch_passive_context/proc/ui_serialize_passive_context()
	return list(
		"enabled" = enabled,
	)
