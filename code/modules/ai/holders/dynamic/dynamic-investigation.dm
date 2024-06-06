//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/ai_holder/dynamic
	/// associate mob tag to time to expire
	/// murder on sight list
	var/list/investigate_murder_on_sight
	/// associate mob tag to time to expire
	/// escalation level 2 list
	var/list/investigate_threaten_on_sight

/datum/ai_holder/dynamic/proc/investigate_location(turf/location)

#warn uhhh
