/////////////////////////////////////////////
//SPARK SYSTEM (like steam system)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like the RCD, so then you can just call start() and the sparks
// will always spawn at the items location.
/////////////////////////////////////////////

/obj/effect/particle_effect/sparks
	name = "sparks"
	icon_state = "sparks"
	anchored = TRUE
	light_range = 1.5
	light_power = 0.8
	light_color = LIGHT_COLOR_FIRE
	var/amount = 6.0

/obj/effect/particle_effect/sparks/Initialize(mapload)
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/particle_effect/sparks/LateInitialize()
	flick(icon_state, src)
	playsound(src, /datum/soundbyte/sparks, 100, 1)
	var/turf/location = loc
	if(isturf(location))
		affect_location(location, just_initialized = TRUE)
	QDEL_IN(src, 2 SECONDS)

/obj/effect/particle_effect/sparks/Destroy()
	var/turf/location = loc
	if(isturf(location))
		affect_location(location)
	return ..()

/obj/effect/particle_effect/sparks/Move()
	..()
	var/turf/location = loc
	if(isturf(location))
		affect_location(location)

/*
* Apply the effects of this spark to its location.
*
* When the spark is first created, Cross() and Crossed() don't get called,
* so for the first initialization, we make sure to specifically invoke the
* behavior of the spark on all the mobs and objects in the location.
* turf/location - The place the spark is affectiong
* just_initialized - If the spark is just being created, and we need to manually affect everything in the location
*/
/obj/effect/particle_effect/sparks/proc/affect_location(turf/location, just_initialized = FALSE)
	location.hotspot_expose(1000,100)
	// SEND_SIGNAL(location, COMSIG_ATOM_TOUCHED_SPARKS, src) // for plasma floors; other floor types only have to worry about the mysterious HAZARDOUS sparks

/datum/effect_system/spark_spread
	var/total_sparks = 0 // To stop it being spammed and lagging!

/datum/effect_system/spark_spread/set_up(n = 3, c = 0, loca)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)

/datum/effect_system/spark_spread/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		if(src.total_sparks > 20)
			return
		spawn(0)
			if(holder)
				src.location = get_turf(holder)
			var/obj/effect/particle_effect/sparks/sparks = new /obj/effect/particle_effect/sparks(src.location)
			src.total_sparks++
			var/direction
			if(src.cardinals)
				direction = pick(GLOB.cardinal)
			else
				direction = pick(GLOB.alldirs)
			for(i=0, i<pick(1,2,3), i++)
				sleep(5)
				if(isloc(sparks.loc) && !QDELETED(sparks))
					step(sparks,direction)
			spawn(20)
				src.total_sparks--
