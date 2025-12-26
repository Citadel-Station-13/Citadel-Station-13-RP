//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * * Considered immutable once created; many datums may be shared!
 */
/datum/resleeving_mind_backup
	/// mind reference; this is what actually stores the player's soul
	var/datum/mind_ref/mind_ref

	/// what their name is; stored separately from mind because
	/// remember; lying about names is IC, mind is OOC
	/// * default is "Unknown"
	var/user_name = "--unknown--"

	//* LEGACY *//

	// why is this legacy?
	// because shit like languages should just be stored on mind, not the fucking body

	// lazy list
	var/list/legacy_language_ids

/datum/resleeving_mind_backup/New(datum/mind/from_mind)
	if(from_mind)
		initialize_from_mind(from_mind)

/datum/resleeving_mind_backup/Destroy()
	// we don't own the mindref handle; just drop the reference
	mind_ref = null
	return ..()

/datum/resleeving_mind_backup/proc/initialize_from_mind(datum/mind/from_mind)
	src.mind_ref = from_mind.get_mind_ref()

	do
		// sigh, grab their languages from their mob
		src.legacy_language_ids = list()
		for(var/lang_name in from_mind.current?.languages)
			var/datum/prototype/language/lang = RSlanguages.legacy_resolve_language_name(lang_name)
			src.legacy_language_ids += lang.id
	while(FALSE)


