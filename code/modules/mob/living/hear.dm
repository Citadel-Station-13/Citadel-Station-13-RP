/mob/living/mob_hear_say(raw_message, message, name, voice_ident, atom/actor, remote, list/params, datum/language/lang, list/spans, say_verb)
	. = ..()
	// we don't just ?. because this also checks if there's no player
	if(. && has_AI())
		ai_holder.on_hear_say(actor, message)

/mob/living/mob_hear_pressure_check(list/hear_args)
	var/datum/language/lang = hear_args[MOVABLE_HEAR_ARG_LANG]
	if(lang?.language_flags & LANGUAGE_NONVERBAL)
		return TRUE
	var/turf/where = get_turf(src)
	var/pressure = where.return_pressure()
	. = pressure >= SOUND_MINIMUM_PRESSURE || (hear_args[MOVABLE_HEAR_ARG_ACTOR] && get_dist(src, hear_args[MOVABLE_HEAR_ARG_ACTOR] > 1))
	if(!.)
		return
	if(pressure < SOUND_SOFT_PRESSURE)
		var/list/spans = hear_args[MOVABLE_HEAR_ARG_SPANS]
		spans += SPAN_CLASS_ITALICS
		hear_args[MOVABLE_HEAR_ARG_SPANS] = spans

/mob/living/mob_hear_language_scramble(list/hear_args)
	var/datum/language/lang = hear_args[MOVABLE_HEAR_ARG_LANG]
	hear_args[MOVABLE_HEAR_ARG_MESSAGE] = lang.scramble(hear_args[MOVABLE_HEAR_ARG_MESSAGE], languages)
