#define LOC_LIBRARY		0
#define LOC_SECURITY	1
#define LOC_RESEARCH	2
#define LOC_CHAPEL		3
#define LOC_BRIDGE		4

/datum/event/cult
	var/location
	var/locstring
	var/spawn_area_type
	var/spawncount = 1
	var/boss_spawn_count = 1
	var/cloud_hueshift
	var/list/players = list()
	has_skybox_image = TRUE

/datum/event/cult/get_skybox_image()
	if(!cloud_hueshift)
		cloud_hueshift = color_rotation(rand(-3, 3) * 15)
	var/image/res = image('icons/skybox/cult.dmi', "narsie")
	res.color = cloud_hueshift
	res.appearance_flags = RESET_COLOR
	res.blend_mode = BLEND_ADD
	return res

/datum/event/cult/setup()
	announceWhen = rand(announceWhen, announceWhen + 3)
	startWhen = announceWhen
	endWhen = 45

/datum/event/cult/announce()
	command_announcement.Announce("Attention [station_name()], unknown humanoid and non-humanoid entities are warping onto the ships! Advise immediate removal of these intruders before productivy aboard gets hindered!", "Screaming Signals Detected", new_sound = sound('sound/effects/c_alarm.mp3',volume=20))


/datum/event/cult/start()
	location = rand(0,4)
	switch(location)
		if(LOC_LIBRARY)
			spawn_area_type = /area/library
			locstring = "library"
			spawncount = rand(1 * severity, 2 * severity)
			boss_spawn_count = 0
		if(LOC_SECURITY)
			spawn_area_type = /area/security
			locstring = "security"
			spawncount = rand(3 * severity, 5 * severity)
			boss_spawn_count = rand(0,2)
		if(LOC_RESEARCH)
			spawn_area_type = /area/rnd
			locstring = "research and development"
			spawncount = rand(1 * severity, 3 * severity)
			boss_spawn_count = rand(0,1)
		if(LOC_CHAPEL)
			spawn_area_type = /area/chapel/main
			locstring = "chapel"
			spawncount = rand(1 * severity, 3 * severity)
			boss_spawn_count = rand(0,1)
		if(LOC_BRIDGE)
			spawn_area_type = /area/bridge
			locstring = "bridge"
			spawncount = rand(1 * severity, 3 * severity)
			boss_spawn_count = rand(0,1)

/datum/event/cult/end()
	var/list/vents = list()
	for(var/areapath in typesof(spawn_area_type))
		var/area/A = locate(areapath)
		for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in A.contents)
			if(temp_vent.network && temp_vent.loc.z in GLOB.using_map.station_levels)
				vents += temp_vent

	var/cult_spawn = list(/mob/living/simple_mob/humanoid/cultist/human, /mob/living/simple_mob/humanoid/cultist/tesh,
	/mob/living/simple_mob/humanoid/cultist/lizard, /mob/living/simple_mob/humanoid/cultist/castertesh)
	var/cult_boss = /mob/living/simple_mob/humanoid/cultist/elite
	spawn(0)
		var/num = spawncount
		while(vents.len > 0 && num > 0)
			var/obj/machinery/atmospherics/unary/vent_pump/V = pick(vents)
			num--
			var/spawn_type = pick(cult_spawn)
			new spawn_type(V.loc)
		var/bossnum = boss_spawn_count
		while(vents.len > 0 && bossnum > 0)
			bossnum--
			var/obj/machinery/atmospherics/unary/vent_pump/V = pick(vents)
			var/spawn_type = cult_boss
			new spawn_type(V.loc)

// Overmap version
/datum/event/cult/overmap/announce()
	command_announcement.Announce("Attention [station_name()], the ship has ran into a hostile sub-sector and reports of humanoid and non-humanoid entities are warping onto the ships! Advise immediate removal of these intruders before productivy aboard gets hindered!", "Screaming Signals Intercepted", new_sound = 'sound/effects/c_alarm.mp3')
	return

#undef LOC_LIBRARY
#undef LOC_SECURITY
#undef LOC_RESEARCH
#undef LOC_CHAPEL
#undef LOC_BRIDGE