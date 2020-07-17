#define LOC_KITCHEN 0
#define LOC_LIBRARY 1
#define LOC_TETHER 2
#define LOC_RESEARCH 3
#define LOC_MINING 4
#define LOC_HYDRO 5

/datum/event/hostile_migration
	announceWhen = 2
	endWhen = 50
	var/location
	var/locstring
	var/spawn_area_type
	var/spawncount = 1
	var/boss_spawn_count = 1

/datum/event/hostile_migration/setup()
	announceWhen = rand(announceWhen, announceWhen + 3)
	startWhen = announceWhen - 1

/datum/event/hostile_migration/announce()
	command_announcement.Announce("Unidentified hostile lifesigns detected migrating towards [station_name()]'s [locstring]. Secure any exterior access, including ducting and ventilation.", "Vermin Migration Alert", new_sound = 'sound/AI/aliens.ogg')


/datum/event/hostile_migration/start()
	location = rand(0,5)
	switch(location)
		if(LOC_KITCHEN)
			spawn_area_type = /area/crew_quarters/kitchen
			locstring = "kitchen"
			spawncount = rand(6 * severity, 10 * severity)
			boss_spawn_count = rand(0,2)
		if(LOC_LIBRARY)
			spawn_area_type = /area/library
			locstring = "library"
			spawncount = rand(9 * severity, 12 * severity)
			boss_spawn_count = rand(0,2)
		if(LOC_TETHER)
			spawn_area_type = /area/tether/surfacebase
			locstring = "tether surface halls"
			spawncount = rand(20 * severity, 30 * severity)
			boss_spawn_count = rand(3,7)
		if(LOC_RESEARCH)
			spawn_area_type = /area/rnd
			locstring = "research and development"
			spawncount = rand(10 * severity, 15 * severity)
			boss_spawn_count = rand(1,5)
		if(LOC_MINING)
			spawn_area_type = /area/tether/surfacebase/mining_main
			locstring = "surface mining"
			spawncount = rand(10 * severity, 19 * severity)
			boss_spawn_count = rand(2,4)
		if(LOC_HYDRO)
			spawn_area_type = /area/hydroponics
			locstring = "hydroponics"
			spawncount = rand(7 * severity, 18 * severity)
			boss_spawn_count = rand(1,5)

/datum/event/hostile_migration/end()
	var/list/vents = list()
	for(var/areapath in typesof(spawn_area_type))
		var/area/A = locate(areapath)
		for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in A.contents)
			if(!temp_vent.welded && temp_vent.network && temp_vent.loc.z in GLOB.using_map.station_levels)
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

#undef LOC_KITCHEN
#undef LOC_LIBRARY
#undef LOC_TETHER
#undef LOC_RESEARCH
#undef LOC_MINING
#undef LOC_HYDRO