//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/ai_holder/dynamic
	/// wander in idle mode
	var/idle_wander = TRUE
	/// idle wander speed
	/// we will use this speed if it's slower than our top speed
	var/idle_wander_speed = 5 SECONDS
	/// automatically shut-off if no one's on the zlevel and we're not doing much
	var/idle_sleep_if_no_players_present = TRUE

#warn automatic shutoff if no one's on the zlevel
