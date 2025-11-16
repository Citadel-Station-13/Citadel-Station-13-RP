//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/proc/log_mortar(datum/event_args/actor/actor, what)
	log_game("MORTAR: [actor ? actor.actor_log_string() : "--userless--"] - [what]")

/proc/log_mortar_shell(datum/event_args/actor/actor, what, list/log_list)
	log_game("MORTAR: [actor ? actor.actor_log_string() : "--userless--"] - [what] on [json_encode(log_list)]")
