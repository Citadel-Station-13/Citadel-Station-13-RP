//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/emote/standard/basic/targetable
	/// maximum distance target can be from us
	var/max_distance = 7
	/// requires a target?
	var/target_required = FALSE

/datum/emote/standard/basic/targetable/process_parameters(datum/event_args/actor/actor, parameter_string)
	. = ..()
	#warn impl

#warn impl

