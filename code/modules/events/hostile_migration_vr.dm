#define LOC_KITCHEN 1
#define LOC_LIBRARY 2
#define LOC_HALLWAYS 3
#define LOC_RESEARCH 4
#define LOC_MINING 5
#define LOC_HYDRO 6
#define LOC_ENGINEERING 7
#define LOC_TALON 8

/datum/event/hostile_migration
	var/location
	var/locstring
	var/spawn_area_type
	var/spawncount = 1
	var/boss_spawn_count = 1
	var/cloud_hueshift
	var/isTalon = 0
	var/list/players = list()
	has_skybox_image = TRUE

/datum/event/hostile_migration/get_skybox_image()
	var/color1 = color_matrix_multiply(color_matrix_rotate_hue(rand(-3, 3) * 15), rgba_auto_greyscale_matrix("#8888ff"))
	var/color2 = color_matrix_multiply(color_matrix_rotate_hue(rand(-3, 3) * 15), rgba_auto_greyscale_matrix("#88ff88"))
	var/image/res = image('icons/skybox/caelus.dmi', "aurora")
	res.appearance_flags = RESET_COLOR
	res.blend_mode = BLEND_ADD
	animate_color_shift(res, color1, color2, 1080 * 0.5, 1080 * 0.5)
	return res

/datum/event/hostile_migration/setup()
	announceWhen = rand(announceWhen, announceWhen + 3)
	startWhen = announceWhen - 1
	endWhen = 50

/datum/event/hostile_migration/announce()
	command_announcement.Announce("Unidentified lifesigns moving through the [station_name()]'s pipe-net heading towards [locstring]. Secure any ducting and ventilation.", "Vermin Migration Alert")


/datum/event/hostile_migration/start()
	sleep(1)
	if(isTalon == 0)
		location = rand(1,7)
	switch(location)
		if(LOC_KITCHEN)
			spawn_area_type = /area/crew_quarters/kitchen
			locstring = "kitchen"
			spawncount = rand(1 * severity, 3 * severity)
			boss_spawn_count = rand(0,2)
		if(LOC_LIBRARY)
			spawn_area_type = /area/library
			locstring = "library"
			spawncount = rand(1, 3 * severity)
			boss_spawn_count = rand(0,1)
		if(LOC_HALLWAYS)
			spawn_area_type = /area/hallway
			locstring = "public hallways"
			spawncount = rand(2 * severity, 5 * severity)
			boss_spawn_count = rand(1,2)
		if(LOC_RESEARCH)
			spawn_area_type = /area/rnd
			locstring = "research and development"
			spawncount = rand(1 , 2 * severity)
			boss_spawn_count = rand(1,2)
		if(LOC_MINING)
			spawn_area_type = /area/quartermaster
			locstring = "cargo & mining"
			spawncount = rand(1 , 3 * severity)
			boss_spawn_count = rand(1,2)
		if(LOC_HYDRO)
			spawn_area_type = /area/hydroponics
			locstring = "hydroponics"
			spawncount = rand(1 * severity, 3 * severity)
			boss_spawn_count = rand(0,1)
		if(LOC_ENGINEERING)
			spawn_area_type = /area/engineering/hallway/lower
			locstring = "engineering"
			spawncount = rand(1 , 3 * severity)
			boss_spawn_count = rand(1,2)
		if(LOC_TALON) //The Talon. Outside of the random range. Should never be picked randomly.
			spawn_area_type = /area/talon
			locstring = "talon"
			spawncount = rand(2 * severity, 5 * severity)
			boss_spawn_count = rand(1,2)
	if(!locstring)
		spawn_area_type = /area/hallway
		locstring = "public hallways"
		spawncount = rand(2 * severity, 5 * severity)
		boss_spawn_count = rand(1,2)

/datum/event/hostile_migration/end()
	var/list/vents = list()
	for(var/areapath in typesof(spawn_area_type))
		var/area/A = locate(areapath)
		for(var/obj/machinery/atmospherics/component/unary/vent_pump/temp_vent in A.contents)
			if(!temp_vent.welded && temp_vent.network && ((temp_vent.loc.z in GLOB.using_map.station_levels) || isTalon == 1))
				vents += temp_vent

	var/rats = /mob/living/simple_mob/animal/passive/mouse/rat
	var/bossrats = /mob/living/simple_mob/vore/aggressive/rat
	spawn(0)
		var/num = spawncount
		while(vents.len > 0 && num > 0)
			var/obj/machinery/atmospherics/component/unary/vent_pump/V = pick(vents)
			num--
			var/spawn_type = rats
			new spawn_type(V.loc)
		var/bossnum = boss_spawn_count
		while(vents.len > 0 && bossnum > 0)
			bossnum--
			var/obj/machinery/atmospherics/component/unary/vent_pump/V = pick(vents)
			var/spawn_type = bossrats
			new spawn_type(V.loc)
		isTalon = 0

// Overmap version
/datum/event/hostile_migration/overmap/announce()
	if(istype(victim, /obj/effect/overmap/visitable/ship/talon))
		command_announcement.Announce("Unidentified hostile lifesigns detected migrating towards ITV Talon through the exterior pipes. Secure any exterior access, including ducting and ventilation.","Hostile Vermin Boarding Alert")
		return
	else
		command_announcement.Announce("Unidentified hostile lifesigns detected migrating towards [station_name()]'s [locstring] through the exterior pipes. Secure any exterior access, including ducting and ventilation.", "Hostile Vermin Boarding Alert", new_sound = 'sound/AI/aliens.ogg')
		return

// override: cancel if not main ship as this is too dumb to target the actual ship crossing it.
/datum/event/hostile_migration/overmap/start()
	if(istype(victim, /obj/effect/overmap/visitable/ship/landable))
		kill()
		return
	if(istype(victim, /obj/effect/overmap/visitable/ship/talon)) //Forces the location to the Talon.
		isTalon = 1
		location = 8
	return ..()

#undef LOC_KITCHEN
#undef LOC_LIBRARY
#undef LOC_HALLWAYS
#undef LOC_RESEARCH
#undef LOC_MINING
#undef LOC_HYDRO
#undef LOC_ENGINEERING
#undef LOC_TALON


//These spawn lists are here for an eventual expansion. Having code issues with this at the moment.
/*
	var/roaches = list(
						/mob/living/simple_mob/animal/roach,
						/mob/living/simple_mob/animal/roach/panzer,
						/mob/living/simple_mob/animal/roach/jaeger,
						/mob/living/simple_mob/animal/roach/seuche,
						/mob/living/simple_mob/animal/roach/atomar,
						/mob/living/simple_mob/animal/roach/strahlend
						)
	var/bossroaches = list(
							/mob/living/simple_mob/animal/roach/zeitraum,
							/mob/living/simple_mob/animal/roach/fuhrer
							)
*/
