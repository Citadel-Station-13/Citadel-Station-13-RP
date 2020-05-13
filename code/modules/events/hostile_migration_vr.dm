#define LOC_KITCHEN 0
#define LOC_SECURITY 1
#define LOC_CHAPEL 2
#define LOC_LIBRARY 3
#define LOC_HYDRO 4
#define LOC_MEDBAY 5
#define LOC_TETHER 6
#define LOC_TECH 7
#define LOC_RESEARCH 8

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
	location = rand(0,8)
	switch(location)
		if(LOC_KITCHEN)
			spawn_area_type = /area/crew_quarters/kitchen
			locstring = "kitchen"
			spawncount = rand(2 * severity, 5 * severity)
		if(LOC_SECURITY)
			spawn_area_type = /area/security/
			locstring = "security department"
			spawncount = rand(5 * severity, 10 * severity)
		if(LOC_CHAPEL)
			spawn_area_type = /area/chapel/main
			locstring = "chapel"
			spawncount = rand(2 * severity, 3 * severity)
		if(LOC_LIBRARY)
			spawn_area_type = /area/library
			locstring = "library"
			spawncount = rand(2 * severity, 3 * severity)
		if(LOC_HYDRO)
			spawn_area_type = /area/hydroponics
			locstring = "hydroponics bay"
			spawncount = rand(2,4 * severity)
		if(LOC_MEDBAY)
			spawn_area_type = /area/medical
			locstring = "medbay"
			spawncount = rand(3 * severity, 5 * severity)
		if(LOC_TETHER)
			spawn_area_type = /area/tether/surfacebase
			locstring = "tether surface halls"
			spawncount = rand(6 * severity, 9 * severity)
		if(LOC_TECH)
			spawn_area_type = /area/storage/tech
			locstring = "technical storage"
			spawncount = rand(6 * severity, 12 * severity)
		if(LOC_RESEARCH)
			spawn_area_type = /area/rnd
			locstring = "research and development"
			spawncount = rand(2 * severity, 4 * severity)

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
/*
	if(location != 6)
		command_announcement.Announce("Sensors have located the location of the migration! Lifesigns are nesting in [locstring]!", "Confirmed Migration Alert", new_sound = 'sound/AI/aliens.ogg')
	else
		command_announcement.Announce("Sensors have detected the migration has split in [locstring]! Crew intervention advised.", "Confirmed Migration Alert", new_sound = 'sound/AI/aliens.ogg')
*/
#undef LOC_KITCHEN
#undef LOC_SECURITY
#undef LOC_CHAPEL
#undef LOC_LIBRARY
#undef LOC_HYDRO
#undef LOC_MEDBAY
#undef LOC_TETHER
#undef LOC_TECH
#undef LOC_RSEARCH