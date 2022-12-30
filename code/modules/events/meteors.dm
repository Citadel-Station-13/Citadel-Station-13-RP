/datum/event/meteor_wave
	startWhen		= 30	// About one minute early warning
	endWhen 		= 60	// Adjusted automatically in tick()
	has_skybox_image = TRUE
	var/alarmWhen   = 30
	var/next_meteor = 40
	var/waves = 1
	var/start_side
	var/next_meteor_lower = 10
	var/next_meteor_upper = 20

/datum/event/meteor_wave/get_skybox_image()
	var/image/res = image('icons/skybox/rockbox.dmi', "rockbox")
	res.color = COLOR_ASTEROID_ROCK
	res.appearance_flags = RESET_COLOR
	return res

/datum/event/meteor_wave/setup()
	waves = (2 + rand(1, severity)) * severity
	start_side = pick(GLOB.cardinal)
	endWhen = worst_case_end()

/datum/event/meteor_wave/start()
	affecting_z -= GLOB.using_map.sealed_levels	// Space levels only please!
	..()

/datum/event/meteor_wave/announce()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce("Meteors have been detected on collision course with \the [location_name()].", "Meteor Alert", new_sound = sound('sound/effects/meteor_storm.ogg',volume=20))
		else
			command_announcement.Announce("\The [location_name()] is now in a meteor shower.", "Meteor Alert")

/datum/event/meteor_wave/tick()
	// Begin sending the alarm signals to shield diffusers so the field is already regenerated (if it exists) by the time actual meteors start flying around.
	if(activeFor >= alarmWhen)
		for(var/obj/machinery/shield_diffuser/SD in GLOB.machines)
			if(SD.z in affecting_z)
				SD.meteor_alarm(10)

	if(waves && activeFor >= next_meteor)
		send_wave()

/datum/event/meteor_wave/proc/send_wave()
	var/pick_side = prob(80) ? start_side : (prob(50) ? turn(start_side, 90) : turn(start_side, -90))

	spawn() spawn_meteors(get_wave_size(), get_meteors(), pick_side, pick(affecting_z))
	next_meteor += rand(next_meteor_lower, next_meteor_upper) / severity
	waves--
	endWhen = worst_case_end()

/datum/event/meteor_wave/proc/get_wave_size()
	return severity * rand(2, 3)

/datum/event/meteor_wave/proc/worst_case_end()
	return activeFor + ((14 / severity) * waves) + 5

/datum/event/meteor_wave/end()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce("\The [location_name()] has cleared the meteor storm.", "Meteor Alert")
		else
			command_announcement.Announce("\The [location_name()] has cleared the meteor shower", "Meteor Alert")

/datum/event/meteor_wave/proc/get_meteors()
	if(severity == EVENT_LEVEL_MAJOR)
		if(prob(35))
			return meteors_catastrophic
		else
			return meteors_threatening
	else
		return meteors_normal

// Overmap version
/datum/event/meteor_wave/overmap
	next_meteor_lower = 5
	next_meteor_upper = 10
	next_meteor = 0
	alarmWhen = 0

/datum/event/meteor_wave/overmap/announce()
	command_announcement.Announce("Meteors have been detected on collision course with \the [location_name()].", "Meteor Alert", new_sound = 'sound/AI/meteors.ogg')
	return

/datum/event/meteor_wave/overmap/tick()
	if(victim && !!victim.is_moving())	// Meteors mostly fly in your face
		start_side = prob(90) ? victim.fore_dir : pick(GLOB.cardinal)
	else	// Unless you're standing still
		start_side = pick(GLOB.cardinal)
	..()

/datum/event/meteor_wave/overmap/get_wave_size()
	. = ..()
	if(!victim)
		return
	var/skill = victim.get_helm_skill()
	var/speed = victim.get_speed_legacy()
	if(skill >= SKILL_PROF)
		. = round(. * 0.5)
	if(!victim.is_moving())		// Standing still means less shit flies your way
		. = round(. * 0.1)
	if(speed < SHIP_SPEED_SLOW)	// Slow and steady
		. = round(. * 0.5)
	if(speed > SHIP_SPEED_FAST)	// Sanic stahp
		. *= 2

	// Smol ship evasion
	if(victim.vessel_size < SHIP_SIZE_LARGE && speed < SHIP_SPEED_FAST)
		var/skill_needed = SKILL_PROF
		if(speed < SHIP_SPEED_SLOW)
			skill_needed = SKILL_ADEPT
		if(victim.vessel_size < SHIP_SIZE_SMALL)
			skill_needed = skill_needed - 1
		if(skill >= max(skill_needed, victim.skill_needed))
			. = round(. * 0.5)
