/mob/living/silicon/ai/sync_translation_context(datum/language/L)
	if(!length(connected_robots))
		return
	if(!istype(translation_context, /datum/translation_context/variable/learning/silicons))
		return
	var/datum/translation_context/variable/learning/silicons/ours = translation_context
	if(!L)
		// full pull + push
		for(var/mob/living/silicon/robot/R as anything in connected_robots)
			if(!istype(R.translation_context, /datum/translation_context/variable/learning/silicons))
				return
			var/datum/translation_context/variable/learning/silicons/theirs = R.translation_context
			theirs.copy_knowledge(ours)
			ours.copy_knowledge(theirs)
		return
	// partial sync - give, not receive
	if(!ours.translated_list_detached)
		return	// full sync didn't happen yet
	for(var/mob/living/silicon/robot/R as anything in connected_robots)
		if(!istype(R.translation_context, /datum/translation_context/variable/learning/silicons))
			return
		var/datum/translation_context/variable/learning/silicons/theirs = R.translation_context
		if(!theirs.translated_list_detached)
			return	// full sync didn't happen yet
		theirs.translated_ids[L.id] = max(ours.translated_ids[L.id], theirs.translated_ids[L.id])
