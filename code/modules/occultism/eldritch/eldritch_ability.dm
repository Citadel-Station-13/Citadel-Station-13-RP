//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/prototype/eldritch_ability
	/// ability type to instance
	var/ability_type = /datum/ability/eldritch_ability

/datum/prototype/eldritch_ability/proc/create_ability()
	return new ability_type

/datum/ability/eldritch_ability
