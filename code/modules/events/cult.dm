#define LOC_LIBRARY		0
#define LOC_SECURITY	1
#define LOC_RESEARCH	2
#define LOC_CHAPEL		3
#define LOC_BRIDGE		4
#define LOC_TALON		5

/datum/event/cult
	var/location
	var/locstring
	var/spawn_area_type
	var/spawncount = 1
	var/boss_spawn_count = 1
	var/cloud_hueshift
	var/isTalon = 0
	var/list/players = list()
	has_skybox_image = TRUE

/datum/event/cult/get_skybox_image()
	if(!cloud_hueshift)
		cloud_hueshift = color_matrix_rotate_hue(rand(-3, 3) * 15)
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
	command_announcement.Announce("Attention [station_name()], unknown humanoid and non-humanoid entities are warping onto the ships! Advise immediate removal of these intruders before productivity aboard gets hindered!", "Screaming Signals Detected", new_sound = sound('sound/effects/c_alarm.mp3',volume=5))


/datum/event/cult/start()
	sleep(1)
	if(isTalon == 0)
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
			spawncount = rand(1 * severity, 3 * severity)
			boss_spawn_count = rand(0,2)
		if(LOC_RESEARCH)
			spawn_area_type = /area/rnd
			locstring = "research and development"
			spawncount = rand(1 * severity, 2 * severity)
			boss_spawn_count = rand(0,1)
		if(LOC_CHAPEL)
			spawn_area_type = /area/chapel/main
			locstring = "chapel"
			spawncount = rand(1 * severity, 2 * severity)
			boss_spawn_count = rand(0,1)
		if(LOC_BRIDGE)
			spawn_area_type = /area/bridge
			locstring = "bridge"
			spawncount = rand(1 * severity, 2 * severity)
			boss_spawn_count = rand(0,1)
		if(LOC_TALON) //The Talon. Outside of the random range. Should never be picked randomly.
			spawn_area_type = /area/talon
			locstring = "talon"
			spawncount = rand(1 * severity, 3 * severity)
			boss_spawn_count = rand(0,2)

/datum/event/cult/end()
	var/list/vents = list()
	for(var/areapath in typesof(spawn_area_type))
		var/area/A = locate(areapath)
		for(var/obj/machinery/atmospherics/component/unary/vent_pump/temp_vent in A.contents)
			if(temp_vent.network && ((temp_vent.loc.z in GLOB.using_map.station_levels) || isTalon == 1))
				vents += temp_vent

	var/cult_spawn = list(/mob/living/simple_mob/humanoid/cultist/human,
	/mob/living/simple_mob/humanoid/cultist/human/bloodjaunt,
	/mob/living/simple_mob/humanoid/cultist/initiate,
	/mob/living/simple_mob/humanoid/cultist/tesh,
	/mob/living/simple_mob/humanoid/cultist/lizard,
	 /mob/living/simple_mob/humanoid/cultist/castertesh,
	 /mob/living/simple_mob/faithless/cult/strong,
	 /mob/living/simple_mob/construct/artificer,
	 /mob/living/simple_mob/construct/shade)

	var/cult_boss = list(/mob/living/simple_mob/humanoid/cultist/elite,
	/mob/living/simple_mob/creature/cult/strong,
	 /mob/living/simple_mob/humanoid/cultist/caster,
	/mob/living/simple_mob/construct/artificer/caster,
	/mob/living/simple_mob/construct/wraith)

	spawn(0)
		var/num = spawncount
		while(vents.len > 0 && num > 0)
			var/obj/machinery/atmospherics/component/unary/vent_pump/V = pick(vents)
			num--
			var/spawn_type = pick(cult_spawn)
			new spawn_type(V.loc)
		var/bossnum = boss_spawn_count
		while(vents.len > 0 && bossnum > 0)
			bossnum--
			var/obj/machinery/atmospherics/component/unary/vent_pump/V = pick(vents)
			var/spawn_type = pick(cult_boss)
			new spawn_type(V.loc)
		isTalon = 0

// Overmap version
/datum/event/cult/overmap/announce()
	if(istype(victim, /obj/effect/overmap/visitable/ship/talon))
		command_announcement.Announce("Attention ITV Talon. You have run into a hostile sub-sector. High potential for humanoid and non-humanoid entities to warp on your ship. Brace.", "Screaming Signals Intercepted")
	else
		command_announcement.Announce("Attention [station_name()], the ship has run into a hostile sub-sector and reports of humanoid and non-humanoid entities are warping onto the ships! Advise immediate removal of these intruders before productivy aboard gets hindered!", "Screaming Signals Intercepted", new_sound = 'sound/effects/c_alarm.mp3')//,volume=5)
		return

/datum/event/cult/overmap/start()		// override - cancel if not main ship since it doesn't properly target the actual triggering ship
	if(istype(victim, /obj/effect/overmap/visitable/ship/landable))
		kill()
		return
	if(istype(victim, /obj/effect/overmap/visitable/ship/talon)) //Forces the location to be the Talon.
		isTalon = 1
		location = 5
	return ..()

#undef LOC_LIBRARY
#undef LOC_SECURITY
#undef LOC_RESEARCH
#undef LOC_CHAPEL
#undef LOC_BRIDGE
#undef LOC_TALON
