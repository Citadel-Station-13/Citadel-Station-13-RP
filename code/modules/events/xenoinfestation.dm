#define LOC_KITCHEN 1
#define LOC_ATMOS 2
#define LOC_CHAPEL 3
#define LOC_LIBRARY 4
#define LOC_HALLWAYS 5
#define LOC_RESEARCH 6
#define LOC_MINING 7
#define LOC_HYDRO 8
#define LOC_ENGINEERING 9

#define MOTHER "mother"
#define EMPRESS "empress"
#define QUEEN "queen"
#define PRAE "praetorian"
#define SENTINEL "sentinel"
#define DRONE "drone"
#define HUNTER "hunter"

/datum/event/xeno_infestation
	var/location
	var/locstring
	var/spawn_area_type
	var/spawn_types = list( MOTHER = 0,
							EMPRESS = 0,
							QUEEN = 0,
							PRAE = 0,
							SENTINEL = 0,
							DRONE = 0,
							HUNTER = 0)
	var/strength = 2//one player = 2 points
	var/additional_players = 3//adds three points of aliens independent of player count

/datum/event/xeno_infestation/extreme
	strength = 4
	additional_players = 10

/datum/event/xeno_infestation/setup()
	// make sure startWhen doesn't go to 0 or below!
	announceWhen = rand(2, 5)
	startWhen = announceWhen - 1
	endWhen = 30

/datum/event/xeno_infestation/announce()
	command_announcement.Announce("Bioscans indicate that Lizards have been breeding in [locstring]. Clear them out, before this starts to affect productivity.", "Vermin infestation")

/datum/event/xeno_infestation/start()
	location = rand(1,9)
	switch(location)
		if(LOC_KITCHEN)
			spawn_area_type = /area/crew_quarters/kitchen
			locstring = "kitchen"
		if(LOC_ATMOS)
			spawn_area_type = /area/engineering/atmos
			locstring = "atmospherics"
		if(LOC_CHAPEL)
			spawn_area_type = /area/chapel
			locstring = "the chapel"
		if(LOC_LIBRARY)
			spawn_area_type = /area/library
			locstring = "library"
		if(LOC_HALLWAYS)
			spawn_area_type = /area/hallway
			locstring = "public hallways"
		if(LOC_RESEARCH)
			spawn_area_type = /area/rnd
			locstring = "research and development"
		if(LOC_MINING)
			spawn_area_type = /area/quartermaster
			locstring = "cargo & mining"
		if(LOC_HYDRO)
			spawn_area_type = /area/hydroponics
			locstring = "hydroponics"
		if(LOC_ENGINEERING)
			spawn_area_type = /area/engineering/hallway //To make sure that we don't have roaches suicide bomb the SME
			locstring = "engineering"
	if(!locstring)
		spawn_area_type = /area/hallway
		locstring = "public hallways"



/datum/event/xeno_infestation/end()
	var/list/vents = list()
	for(var/areapath in typesof(spawn_area_type))
		var/area/A = locate(areapath)
		for(var/obj/machinery/atmospherics/component/unary/vent_pump/temp_vent in A.contents)
			if(!temp_vent.welded && temp_vent.network && (temp_vent.loc.z in GLOB.using_map.station_levels))
				vents += temp_vent
	if(vents.len <= 0)
		log_admin("No valid vents to spawn infestation.")
		return
	fill_spawn_type()
	log_this()
	spawn(0)
		for(var/obj/machinery/atmospherics/component/unary/vent_pump/V in vents)
			new /obj/structure/alien/weeds/node(V.loc)
		for(var/xeno_type in list(MOTHER, EMPRESS, QUEEN, PRAE, SENTINEL, DRONE, HUNTER))
			while(spawn_types[xeno_type] > 0)
				var/obj/machinery/atmospherics/component/unary/vent_pump/V = pick(vents)
				switch(xeno_type)
					if(MOTHER)
						new /mob/living/simple_mob/animal/space/alien/queen/empress/mother(V.loc)
					if(EMPRESS)
						new /mob/living/simple_mob/animal/space/alien/queen/empress(V.loc)
					if(QUEEN)
						new /mob/living/simple_mob/animal/space/alien/queen(V.loc)
					if(PRAE)
						new /mob/living/simple_mob/animal/space/alien/sentinel/praetorian(V.loc)
					if(SENTINEL)
						new /mob/living/simple_mob/animal/space/alien/sentinel(V.loc)
					if(DRONE)
						new /mob/living/simple_mob/animal/space/alien/drone(V.loc)
					if(HUNTER)
						new /mob/living/simple_mob/animal/space/alien(V.loc)
				spawn_types[xeno_type]--

/datum/event/xeno_infestation/proc/log_this()
	log_debug(SPAN_DEBUGINFO("Xenomorph Infestation Event: Spawned the following: [spawn_types[MOTHER]] Queen Mother(s), [spawn_types[EMPRESS]] Empress(es), [spawn_types[QUEEN]] Queen(s), [spawn_types[PRAE]] Preatorian(s), [spawn_types[SENTINEL]] Sentinel(s), [spawn_types[DRONE]] Drone(s), and [spawn_types[HUNTER]] Hunter(s). Spawning in [locstring]"))


/datum/event/xeno_infestation/proc/fill_spawn_type()
	var/player_value = get_player_count() * strength
	if(additional_players)
		player_value += additional_players
	var/queen_spawning = FALSE
	/**
	 * 20 /mob/living/simple_mob/animal/space/alien/queen/empress/mother
	 * 15 /mob/living/simple_mob/animal/space/alien/queen/empress
	 * 10 /mob/living/simple_mob/animal/space/alien/queen
	 * 05 /mob/living/simple_mob/animal/space/alien/sentinel/praetorian
	 * 04 /mob/living/simple_mob/animal/space/alien/sentinel
	 * 02 /mob/living/simple_mob/animal/space/alien/drone
	 * 01 /mob/living/simple_mob/animal/space/alien
	 */
	while(player_value > 0)
		if(player_value >= (20 * 1.5))//Multiplier to rather spawn more small ones than one big one
			spawn_types[MOTHER] += 1
			player_value -= 20
			queen_spawning = TRUE
			continue
		if(player_value >= (15 * 1.5))
			spawn_types[EMPRESS] += 1
			player_value -= 15
			queen_spawning = TRUE
			continue
		if(player_value >= (10 * 1.5))
			spawn_types[QUEEN] += 1
			player_value -= 10
			queen_spawning = TRUE
			continue
		if(player_value >= 5)
			spawn_types[PRAE] += 1
			if(queen_spawning && rand(5)) // 5% chance to reduce the costs of spawning
				player_value -= 3
			else
				player_value -= 5
			continue
		if(player_value >= 4)
			spawn_types[SENTINEL] += 1
			if(queen_spawning && rand(10)) // 10% chance to reduce the costs of spawning
				player_value -= 2
			else
				player_value -= 4
			continue
		if(player_value >= 3)
			spawn_types[DRONE] += 1
			if(queen_spawning && rand(15)) // 15% chance to reduce the costs of spawning
				player_value -= 1
			else
				player_value -= 3
			continue
		spawn_types[HUNTER] += 1
		if(queen_spawning && rand(5)) // 5% chance to negate cost!
			player_value -= 0
		else
			player_value -= 1

/datum/event/xeno_infestation/proc/get_player_count()
	var/i = 0
	for(var/mob/living/carbon/human/C in living_mob_list)
		var/turf/T = get_turf(C)
		if(!T)
			continue
		if(!(T.z in GLOB.using_map.station_levels))
			continue
		i++
	log_admin("Xenoinfestation found [i] players on station")
	return i

#undef LOC_KITCHEN
#undef LOC_ATMOS
#undef LOC_CHAPEL
#undef LOC_LIBRARY
#undef LOC_HALLWAYS
#undef LOC_RESEARCH
#undef LOC_MINING
#undef LOC_HYDRO
#undef LOC_ENGINEERING

#undef MOTHER
#undef EMPRESS
#undef QUEEN
#undef PRAE
#undef SENTINEL
#undef DRONE
#undef HUNTER
