//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/mob/observer/dead/process_emote(datum/emote/emote, raw_parameter_string, datum/event_args/actor/actor, used_binding)
	actor.chat_feedback(
		SPAN_WARNING("Ghosts can't send normal emotes!"),
		target = src,
	)
	return FALSE
