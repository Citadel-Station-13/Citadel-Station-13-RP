//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/prototype/eldritch_ability
	/// ability type to instance
	var/ability_type = /datum/ability/eldritch_ability

/datum/prototype/eldritch_ability/proc/create_ability(datum/eldritch_holder/for_holder)
	return new ability_type(for_holder)

/datum/ability/eldritch_ability
	/// bound holder, if any
	var/datum/eldritch_holder/eldritch

/datum/ability/eldritch_ability/New(datum/eldritch_holder/bind_to_holder)
	if(bind_to_holder)
		src.eldritch = bind_to_holder
