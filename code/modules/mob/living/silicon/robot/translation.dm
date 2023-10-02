/mob/living/silicon/robot/sync_translation_context(datum/language/L)
	if(!connected_ai)
		return
	if(!istype(connected_ai.translation_context, /datum/translation_context/variable/learning/silicons))
		return
	if(!istype(translation_context, /datum/translation_context/variable/learning/silicons))
		return
	var/datum/translation_context/variable/learning/silicons/ours = translation_context
	var/datum/translation_context/variable/learning/silicons/theirs = connected_ai.translation_context
	if(!L)
		// expensive full sync
		theirs.copy_knowledge(ours)
		ours.copy_knowledge(theirs)
		to_chat(src, SPAN_NOTICE("Adaptive translator synced to master AI."))
		return
	// partial sync - give, not receive
	if(!theirs.translated_list_detached || !ours.translated_list_detached)
		return	// full sync didn't happen yet
	if(!theirs.translated_ids[L.id])
		to_chat(connected_ai, SPAN_NOTICE("New language received from connected units: [L.name]. Adaptive translation started."))
	theirs.translated_ids[L.id] = max(ours.translated_ids[L.id], theirs.translated_ids[L.id])
