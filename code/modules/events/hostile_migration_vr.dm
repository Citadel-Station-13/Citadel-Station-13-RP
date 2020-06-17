#define LOC_KITCHEN 0
#define LOC_LIBRARY 1
#define LOC_HYDRO 2
#define LOC_TETHER 3
#define LOC_RESEARCH 4

/datum/event/hostile_migration
	announceWhen = 2
	endWhen = 50
	var/location
	var/locstring
	var/spawn_area_type
	var/spawncount = 1

/datum/event/hostile_migration/setup()
	announceWhen = rand(announceWhen, announceWhen + 3)
	startWhen = announceWhen - 1

/datum/event/hostile_migration/announce()
	command_announcement.Announce("Unidentified hostile lifesigns detected migrating towards [station_name()]'s [locstring]. Secure any exterior access, including ducting and ventilation.", "Vermin Migration Alert", new_sound = 'sound/AI/aliens.ogg')


/datum/event/hostile_migration/start()
	location = rand(0,4)
	switch(location)
		if(LOC_KITCHEN)
			spawn_area_type = /area/crew_quarters/kitchen
			locstring = "kitchen"
			spawncount = rand(7 * severity, 12 * severity)
		if(LOC_LIBRARY)
			spawn_area_type = /area/library
			locstring = "library"
			spawncount = rand(9 * severity, 15 * severity)
		if(LOC_HYDRO)
			spawn_area_type = /area/hydroponics
			locstring = "hydroponics bay"
			spawncount = rand(6,12 * severity)
		if(LOC_TETHER)
			spawn_area_type = /area/tether/surfacebase
			locstring = "tether surface halls"
			spawncount = rand(15 * severity, 20 * severity)
		if(LOC_RESEARCH)
			spawn_area_type = /area/rnd
			locstring = "research and development"
			spawncount = rand(10 * severity, 15 * severity)

/datum/event/hostile_migration/end()
	var/list/vents = list()
	for(var/areapath in typesof(spawn_area_type))
		var/area/A = locate(areapath)
		for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in A.contents)
			if(!temp_vent.welded && temp_vent.network && temp_vent.loc.z in GLOB.using_map.station_levels)
				vents += temp_vent

	var/rats = /mob/living/simple_mob/animal/passive/mouse/rat
	spawn(0)
		var/num = spawncount
		while(vents.len > 0 && num > 0)
			var/obj/machinery/atmospherics/unary/vent_pump/V = pick(vents)
			num--
			var/spawn_type = rats
			new spawn_type(V.loc)

#undef LOC_KITCHEN
#undef LOC_LIBRARY
#undef LOC_HYDRO
#undef LOC_TETHER
#undef LOC_RESEARCH