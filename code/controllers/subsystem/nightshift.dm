SUBSYSTEM_DEF(nightshift)
	name = "Night Shift"
	wait = 5 MINUTES

	/// Set from configuration - enabled nightshift flags.
	var/nightshift_level = NONE

	//! legacy below

	var/nightshift_active = FALSE

	var/nightshift_start_time = 19 HOURS + 30 MINUTES		//7:30 PM, station time
	var/nightshift_end_time = 7 HOURS + 30 MINUTES		//7:30 AM, station time
	var/nightshift_first_check = 5 MINUTES // Wait 5 minutes after roundstart to turn on nightshift

	var/high_security_mode = FALSE
	var/list/currentrun

	/// Override by a C&C console
	var/overridden

/datum/controller/subsystem/nightshift/Initialize()
	if (!CONFIG_GET(flag/nightshifts_enabled))
		can_fire = FALSE
	return SS_INIT_SUCCESS

/datum/controller/subsystem/nightshift/fire(resumed = FALSE)
	if(resumed)
		update_nightshift(resumed = TRUE)
		return
	if(round_duration_in_ds < nightshift_first_check)
		return
	check_nightshift()

/datum/controller/subsystem/nightshift/proc/announce(message)
	priority_announcement.Announce(
		message,
		new_title = "Automated Lighting System Announcement",
		new_sound = 'sound/misc/notice2.ogg',
	)

/datum/controller/subsystem/nightshift/proc/check_nightshift(check_canfire=FALSE) //This is called from elsewhere, like setting the alert levels
	if(overridden || (check_canfire && !can_fire))
		return
	var/emergency = GLOB.security_level > SEC_LEVEL_GREEN
	var/announcing = TRUE

	//station_time_in_ds = deciseconds after midnight in station time
	//nightshift_start_time = 702,000 deciseconds after midnight (7:30 PM)
	//nightshift_end_time = 207,000 deciseconds after midnight (7:30 AM)
	//if time is greater than start time (between 7:30pm and 11:59pm) OR less than end time (between midnight and 7:29am) it should turn on.
	//If time rolls over to midnight, station_time will keep incrementing so there is no need for a special case.
	var/time = station_time_in_ds	
	var/night_time = (time > nightshift_start_time) || (time < nightshift_end_time)

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

/datum/controller/subsystem/nightshift/proc/update_nightshift(active, announce = TRUE, resumed = FALSE, forced = FALSE)
	if(!resumed)
		currentrun = GLOB.apcs.Copy()
		nightshift_active = active
		if(announce)
			if (active)
				announce("Good evening, crew. To reduce power consumption and stimulate the circadian rhythms of some species, all of the non-essential lights have been dimmed for the night.")
			else
				announce("Good morning, crew. As it is now day time, all of the non-essential lights have been restored to their former brightness.")

	SSlighting.pause_instant()

	for(var/obj/machinery/power/apc/APC as anything in currentrun)
		currentrun -= APC
		if (APC.area && (APC.z in (LEGACY_MAP_DATUM).station_levels))
			APC.set_nightshift(nightshift_active && (APC.area.nightshift_level & nightshift_level), TRUE)
		
		//TODO: redo below logic: as-is, it does not allow the nightshift subsystem to actually finish processing

		//if(MC_TICK_CHECK && !forced) // subsystem will be in state SS_IDLE if forced by an admin
		//return

	SSlighting.resume_instant()
