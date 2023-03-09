/datum/automata/wave/sonar
	wave_spread = WAVE_SPREAD_MINIMAL
	/// global resolution
	var/resolution = SONAR_RESOLUTION_VISIBLE
	/// flicked this tick
	var/list/atom/movable/flicking = list()

/datum/automata/wave/sonar/tick()
	. = ..()
	flick_images(flicking)
	flicking = list()

/datum/automata/wave/sonar/act(turf/T, dirs, power)
	. = power - 1
	if(isspaceturf(T))
		return 0	// nah
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

/datum/automata/wave/sonar/cleanup()
	flicking = list()
	return ..()

/datum/automata/wave/sonar/proc/flick_sonar(atom/movable/AM)
	if(ismob(AM))
		var/mob/M = AM
		if(M.client && !TIMER_COOLDOWN_CHECK(M, CD_INDEX_SONAR_NOISE))
			to_chat(M, SPAN_WARNING("You hear a quiet click."))
			TIMER_COOLDOWN_START(M, CD_INDEX_SONAR_NOISE, 7.5 SECONDS)
		// todo: M.provoke() for AI...
	var/atom/movable/holder = AM.make_sonar_image(resolution)
	if(holder)
		holder.alpha = 0
		flicking += holder

/datum/automata/wave/sonar/proc/flick_scan(turf/T)

/datum/automata/wave/sonar/proc/flick_images(list/atom/movable/holders)
	// since image flicking is dead due to byond..
	for(var/atom/movable/holder as anything in holders)
		animate(holder, alpha = 255, time = 0.1 SECONDS)
		animate(alpha = 0, time = 0.5 SECONDS)
	// end
	QDEL_LIST_IN(holders, 2 SECONDS)

/datum/automata/wave/sonar/single_mob
	var/mob/receiver

/datum/automata/wave/sonar/single_mob/Destroy()
	receiver = null
	return ..()

// /datum/automata/wave/sonar/single_mob/flick_images(list/atom/movable/holders)
// 	if(!receiver.client)
// 		return
// 	SSsonar.flick_sonar_image(images, list(receiver.client))
