/datum/event/meteor_wave
	startWhen		= 5
	endWhen 		= 7
	var/next_meteor = 6
	var/waves = 1
	var/start_side

/datum/event/meteor_wave/setup()
	waves = 2 + rand(1, severity)		//EVENT_LEVEL_MAJOR is 3-5 waves
	start_side = pick(cardinal)
	endWhen = worst_case_end()

/datum/event/meteor_wave/announce()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce("Danger! A large meteor storm has been detected on approach with \the [station_name()]!", "Meteor Alert", new_sound = sound('sound/effects/meteor_storm.wav',volume=5))
		else
			command_announcement.Announce("Caution. Meteors have been detected on collision course with \the [station_name()].", "Meteor Alert", new_sound = 'sound/AI/meteors.ogg')

/datum/event/meteor_wave/tick()
	if(waves && activeFor >= next_meteor)
		var/pick_side = prob(80) ? start_side : (prob(50) ? turn(start_side, 90) : turn(start_side, -90))

		spawn() spawn_meteors(severity * rand(2,4), get_meteors(), pick_side)
		next_meteor += rand(5, 14) / severity
		waves--
		endWhen = worst_case_end()

/datum/event/meteor_wave/proc/worst_case_end()
	return activeFor + ((14 / severity) * waves) + 5

/datum/event/meteor_wave/end()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce("\The [station_name()] has cleared the meteor storm.", "Meteor Alert")
		else
			command_announcement.Announce("\The [station_name()] has cleared the meteor shower", "Meteor Alert")

/datum/event/meteor_wave/proc/get_meteors()
	if(severity == EVENT_LEVEL_MAJOR)
		if(prob(35))
			return meteors_catastrophic
		else
			return meteors_threatening
	else
		return meteors_normal
