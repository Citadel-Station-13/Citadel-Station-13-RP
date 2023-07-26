
/mob/living/silicon/mob_hear_language_scramble(list/hear_args)
	var/datum/language/lang = hear_args[MOVABLE_HEAR_ARG_LANG]
	var/message = hear_args[MOVABLE_HEAR_ARG_MESSAGE]
	var/translated = translation_context?.attempt_translation(lang, message)
	hear_args[MOVABLE_HEAR_ARG_MESSAGE] = isnull(translated)? lang.scramble(message, languages) : translated
