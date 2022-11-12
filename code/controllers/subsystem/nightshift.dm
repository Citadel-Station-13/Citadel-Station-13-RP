SUBSYSTEM_DEF(nightshift)
	name = "Night Shift"
	init_order = INIT_ORDER_NIGHTSHIFT
	priority = FIRE_PRIORITY_NIGHTSHIFT
	wait = 60 SECONDS
	subsystem_flags = SS_NO_TICK_CHECK

	var/nightshift_active = FALSE
	var/nightshift_start_time = 702000		//7:30 PM, station time
	var/nightshift_end_time = 270000		//7:30 AM, station time
	var/nightshift_first_check = 30 SECONDS

	var/high_security_mode = FALSE

/datum/controller/subsystem/nightshift/Initialize()
	if (!CONFIG_GET(flag/nightshifts_enabled))
		can_fire = FALSE
	//if(CONFIG_GET(flag/randomized_start_time_enabled))
		//GLOB.gametime_offset = rand(0, 23) HOURS
	return ..()

/datum/controller/subsystem/nightshift/fire(resumed = FALSE)
	if(world.time - SSticker.round_start_time < nightshift_first_check)
		return
	check_nightshift()

/datum/controller/subsystem/nightshift/proc/announce(message)
	var/announce_z
	if(GLOB.using_map.station_levels.len)
		announce_z = pick(GLOB.using_map.station_levels)
	priority_announcement.Announce(message, new_title = "Automated Lighting System Announcement", new_sound = 'sound/misc/notice2.ogg', zlevel = announce_z)

/datum/controller/subsystem/nightshift/proc/check_nightshift(check_canfire=FALSE) //This is called from elsewhere, like setting the alert levels
	if(check_canfire && !can_fire)
		return
	var/emergency = GLOB.security_level > SEC_LEVEL_GREEN
	var/announcing = TRUE
	var/time = station_time()
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
	for(var/obj/machinery/power/apc/apc in GLOB.apcs)
		if(apc.z in GLOB.using_map.station_levels)
			apc.set_nightshift(active, TRUE)
			CHECK_TICK
