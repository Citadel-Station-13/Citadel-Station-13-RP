//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

// /mob/visible_action_dual(hard_range, soft_range, visible_hard, visible_soft, list/exclude_cache, self, ghosts, face_ident)
// 	if(!isnull(identity))


// /mob/audible_action_dual(hard_range, soft_range, audible_hard, audible_soft, list/exclude_cache, self, ghosts, voice_ident)

// /mob/full_action_dual(hard_range, soft_range, visible_hard, audible_hard, visible_soft, audible_soft, list/exclude_cache, visible_self, audible_self, ghosts, face_ident, voice_ident)

// /mob/visible_action(range, message, list/exclude_cache, self, ghosts, face_ident)

// /mob/audible_action(range, message, list/exclude_cache, self, ghosts, voice_ident)

// /mob/full_action(range, visible, audible, list/exclude_cache, visible_self, audible_self, ghosts, face_ident, voice_ident)

#warn impl all

/mob/proc/mob_say_verb(message, list/params)
	var/len = length_char(message)
	switch(message[len])
		if("!")
			if(message[len - 1] == "!")
				return sayverb_yell
			return sayverb_exclaim
		if("?")
			return sayverb_question
	if(params[SAYCODE_PARAM_SUBTLEWHISPER])
		return sayverb_whisper
	return sayverb_say
