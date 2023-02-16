SUBSYSTEM_DEF(nightshift)
	name = "Night Shift"
	init_order = INIT_ORDER_NIGHTSHIFT
	priority = FIRE_PRIORITY_NIGHTSHIFT
	wait = 60 SECONDS
	subsystem_flags = SS_NO_TICK_CHECK

	var/nightshift_active = FALSE
	var/nightshift_start_time = 19 HOURS + 30 MINUTES		//7:30 PM, station time
	var/nightshift_end_time = 7 HOURS + 30 MINUTES		//7:30 AM, station time
	var/nightshift_first_check = 30 SECONDS

	var/overridden //Overridden by a C&C console.

	var/high_security_mode = FALSE

/datum/controller/subsystem/nightshift/Initialize()
	if (!CONFIG_GET(flag/nightshifts_enabled))
		can_fire = FALSE
	//if(CONFIG_GET(flag/randomized_start_time_enabled))
		//GLOB.gametime_offset = rand(0, 23) HOURS
	return ..()

/datum/controller/subsystem/nightshift/fire(resumed = FALSE)
	if(world.time - round_duration_in_ds < nightshift_first_check)
		return
	check_nightshift()

/datum/controller/subsystem/nightshift/proc/announce(message)
	var/announce_z
	var/list/possible = SSmapping.levels_by_trait(ZTRAIT_STATION)
	announce_z = SAFEPICK(possible)
	priority_announcement.Announce(message, new_title = "Automated Lighting System Announcement", new_sound = 'sound/misc/notice2.ogg', zlevel = announce_z)

/datum/controller/subsystem/nightshift/proc/check_nightshift(check_canfire=FALSE) //This is called from elsewhere, like setting the alert levels
	if(overridden || (check_canfire && !can_fire))
		return
	var/emergency = GLOB.security_level > SEC_LEVEL_GREEN
	var/announcing = TRUE
	var/time = station_time_in_ds
	var/night_time = (time < nightshift_end_time) || (time > nightshift_start_time)
	if(high_security_mode != emergency)
		high_security_mode = emergency
		if(night_time)
			announcing = FALSE
			if(!emergency)
				announce("Restoring night lighting configuration to normal operation.")
			else
				announce("Disabling night lighting: Station is in a state of emergency.")
	if(emergency)
		night_time = FALSE
	if(nightshift_active != night_time)
		update_nightshift(night_time, announcing)

/datum/controller/subsystem/nightshift/proc/update_nightshift(active, announce = TRUE)
	nightshift_active = active
	if(announce)
		if(active)
			announce("Good evening, crew. To reduce power consumption and stimulate the circadian rhythms of some species, all of the lights aboard the station have been dimmed for the night.")
		else
			announce("Good morning, crew. As it is now day time, all of the lights aboard the station have been restored to their former brightness.")

	SSlighting.pause_instant()

	for(var/obj/machinery/power/apc/apc in GLOB.apcs)
<<<<<<< HEAD
		if(!SSmapping.level_trait(apc.z, ZTRAIT_STATION))
			continue
		apc.set_nightshift(active, TRUE)
		CHECK_TICK

// TODO: WORLD SECTOR TIME SYSTEM

// Gets the current time on a current zlevel, and returns a time datum
/proc/get_zlevel_time(var/z)
	if(!z)
		z = 1
	var/datum/planet/P = z <= SSplanets.z_to_planet.len ? SSplanets.z_to_planet[z] : null
	// We found a planet tied to that zlevel, give them the time
	if(P?.current_time)
		return P.current_time

	// We have to invent a time
	else
		var/datum/time/T = new (station_time_in_ds)
		return T

// Returns a boolean for if it's night or not on a particular zlevel
/proc/get_night(var/z)
	if(!z)
		z = 1
	var/datum/time/now = get_zlevel_time(z)
	var/percent = now.seconds_stored / now.seconds_in_day //practically all of these are in DS
	testing("get_night is [percent] through the day on [z]")

	// First quarter, last quarter
	if(percent < 0.25 || percent > 0.75)
		return TRUE
	// Second quarter, third quarter
	else
		return FALSE

// Boolean for if we should use SSnightshift night hours
/proc/get_nightshift()
	return get_night(1) //Defaults to z1, customize however you want on your own maps

=======
		if(apc.z in GLOB.using_map.station_levels)
			apc.set_nightshift(active, TRUE)
			CHECK_TICK

	SSlighting.resume_instant()
>>>>>>> citrp/master
