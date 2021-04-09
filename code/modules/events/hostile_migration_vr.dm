#define LOC_KITCHEN 1
#define LOC_LIBRARY 2
#define LOC_HALLWAYS 3
#define LOC_RESEARCH 4
#define LOC_MINING 5
#define LOC_HYDRO 6

/datum/event/hostile_migration
	var/location
	var/locstring
	var/spawn_area_type
	var/spawncount = 1
	var/boss_spawn_count = 1
	var/cloud_hueshift
	var/list/players = list()
	has_skybox_image = TRUE

/datum/event/hostile_migration/get_skybox_image()
	if(!cloud_hueshift)
		cloud_hueshift = color_rotation(rand(-3, 3) * 15)
	var/image/res = image('icons/skybox/caelus.dmi', "rats")
	res.color = cloud_hueshift
	res.appearance_flags = RESET_COLOR
	res.blend_mode = BLEND_ADD
	return res

/datum/event/hostile_migration/setup()
	announceWhen = rand(announceWhen, announceWhen + 3)
	startWhen = announceWhen - 1
	endWhen = 50

/datum/event/hostile_migration/announce()
	command_announcement.Announce("Unidentified lifesigns moving through the [station_name()]'s pipe-net heading towards [locstring]. Secure any ducting and ventilation.", "Vermin Migration Alert")


/datum/event/hostile_migration/start()
	location = rand(1,6)
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
	if(!locstring)
		spawn_area_type = /area/hallway
		locstring = "public hallways"
		spawncount = rand(2 * severity, 5 * severity)
		boss_spawn_count = rand(1,2)

/datum/event/hostile_migration/end()
	var/list/vents = list()
	for(var/areapath in typesof(spawn_area_type))
		var/area/A = locate(areapath)
		for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in A.contents)
			if(!temp_vent.welded && temp_vent.network && (temp_vent.loc.z in GLOB.using_map.station_levels))
				vents += temp_vent

	var/rats = /mob/living/simple_mob/animal/passive/mouse/rat
	var/bossrats = /mob/living/simple_mob/vore/aggressive/rat
	spawn(0)
		var/num = spawncount
		while(vents.len > 0 && num > 0)
			var/obj/machinery/atmospherics/unary/vent_pump/V = pick(vents)
			num--
			var/spawn_type = rats
			new spawn_type(V.loc)
		var/bossnum = boss_spawn_count
		while(vents.len > 0 && bossnum > 0)
			bossnum--
			var/obj/machinery/atmospherics/unary/vent_pump/V = pick(vents)
			var/spawn_type = bossrats
			new spawn_type(V.loc)

// Overmap version
/datum/event/hostile_migration/overmap/announce()
	command_announcement.Announce("Unidentified hostile lifesigns detected migrating towards [station_name()]'s [locstring] through the exterior pipes. Secure any exterior access, including ducting and ventilation.", "Hostile Vermin Boarding Alert", new_sound = 'sound/AI/aliens.ogg')
	return

// override: cancel if not main ship as this is too dumb to target the actual ship crossing it.
/datum/event/hostile_migration/overmap/start()
	if(istype(victim, /obj/effect/overmap/visitable/ship/landable))
		kill()
		return
	return ..()

#undef LOC_KITCHEN
#undef LOC_LIBRARY
#undef LOC_HALLWAYS
#undef LOC_RESEARCH
#undef LOC_MINING
#undef LOC_HYDRO
