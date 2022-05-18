/datum/automata/wave/sonar
	wave_spread = WAVE_SPREAD_MINIMAL
	/// global resolution
	var/resolution = SONAR_RESOLUTION_OUTLINE

/datum/automata/wave/sonar/act(turf/T, dirs, power)
	. = power - 1
	if(T.density)
		flick_sonar(T)
	else
		flick_scan(T)
	for(var/obj/O in T)
		flick_sonar(O)
	for(var/mob/M in T)
		flick_sonar(M)

/datum/automata/wave/sonar/act_cross(atom/movable/AM, power)
	flick_sonar(AM)

/datum/automata/wave/sonar/proc/flick_sonar(atom/movable/AM)
	#warn impl

/datum/automata/wave/sonar/proc/flick_scan(turf/T)
/datum/automata/wave/sonar/single_mob
	var/mob/receiver

/datum/automata/wave/sonar/single_mob/Destroy()
	receiver = null
	return ..()

/datum/automata/wave/sonar/single_mob/flick_sonar(atom/movable/AM)

/datum/automata/wave/sonar/single_mob/flick_scan(turf/T)
