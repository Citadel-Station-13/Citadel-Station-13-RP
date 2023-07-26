/mob/observer/dead/mob_see_action(raw_message, message, name, face_ident, atom/actor, remote, list/params)
	if(params[SAYCODE_PARAM_NO_OBSERVERS])
		// drop
		return TRUE
	if(!is_preference_enabled(/datum/client_preference/ghost_sight) && (isnull(actor) || (get_dist(actor, src) < 7)))
		return TRUE
	return ..()

/mob/observer/dead/mob_hear_say(raw_message, message, name, voice_ident, atom/actor, remote, list/params, datum/language/lang, list/spans, say_verb)
	if(params[SAYCODE_PARAM_NO_OBSERVERS])
		// drop
		return TRUE
	if(!is_preference_enabled(/datum/client_preference/ghost_ears) && (isnull(actor) || (get_dist(actor, src) < 7)))
		return TRUE
	return ..()
