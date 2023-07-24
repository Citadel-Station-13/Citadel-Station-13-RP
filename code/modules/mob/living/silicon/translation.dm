/datum/translation_context/simple/silicons
	translation_class = TRANSLATION_CLASSES_STANDARD_TRANSLATE

/datum/translation_context/variable/learning/silicons
	translation_class = TRANSLATION_CLASSES_STANDARD_TRANSLATE
	translation_class_learn = TRANSLATION_CLASSES_STANDARD_TRANSLATE

/**
 * @params
 * - L - language to sync; if null, syncs all
 */
/mob/living/silicon/proc/sync_translation_context(datum/language/L)
	return

/mob/living/silicon/proc/translation_train_hook(datum/translation_context/context, datum/language/L, old_efficiency)
	if(!old_efficiency)
		to_chat(src, SPAN_NOTICE("Identifying new language . . ."))
		to_chat(src, SPAN_NOTICE("New language identified: [L.name]. Registering and beginning adaptive translation."))
	sync_translation_context(L)

/mob/living/silicon/proc/create_translation_context(path = translation_context_type)
	if(istype(translation_context))
		qdel(translation_context)
	translation_context = new path
	if(istype(translation_context, /datum/translation_context/variable/learning/silicons))
		var/datum/translation_context/variable/learning/silicons/CTX = translation_context
		CTX.on_train = CALLBACK(src, .proc/translation_train_hook)
