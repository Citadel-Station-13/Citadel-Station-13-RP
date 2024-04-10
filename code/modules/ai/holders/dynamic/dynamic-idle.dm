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
	/// chance of going to sleep per tick if no one's around
	var/idle_sleep_chance = 5
	/// do we automatically set something to hover around if we have no home?
	/// we'll still use home_wander_distance
	var/idle_wander_auto_home
	/// temporary idle spot to hover around; this should hopefully be close to home
	var/turf/idle_wander_home

#warn automatic shutoff if no one's on the zlevel

/datum/ai_holder/dynamic/proc/idle_setup()
	if(!isturf(loc))
		idle_wander_home = null // wtf
	else if(home && get_dist(src, home) <= home_wander_distance)
		idle_wander_home = home
	else if(idle_wander_auto_home)
		idle_wander_home = get_turf(src)
	else
		idle_wander_home = null

/datum/ai_holder/dynamic/proc/idle_loop()
	#warn wander
