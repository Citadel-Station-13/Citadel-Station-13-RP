#define LOC_CARGO		0
#define LOC_SECURITY	1
#define LOC_RESEARCH	2
#define LOC_HALLWAYS	3
#define LOC_BRIDGE		4

/datum/event/pirate
	var/location
	var/locstring
	var/spawn_area_type
	var/spawncount = 1
	var/boss_spawn_count = 1
	var/cloud_hueshift
	var/list/players = list()
	has_skybox_image = FALSE

/datum/event/pirate/setup()
	announceWhen = rand(announceWhen, announceWhen + 3)
	startWhen = announceWhen
	endWhen = 45

/datum/event/pirate/announce()
	command_announcement.Announce("Attention Landlubers of the [station_name()], hand over your booty and your ship and no one gets hurt!", "Incoming Transmission", new_sound = sound('sound/effects/siren.ogg', volume=25))

/datum/event/pirate/start()
	location = rand(0,4)
	switch(location)
		if(LOC_CARGO)
			spawn_area_type = /area/quartermaster
			locstring = "cargo & mining"
			spawncount = rand(1 * severity, 3 * severity)
			boss_spawn_count = 1
		if(LOC_SECURITY)
			spawn_area_type = /area/security
			locstring = "security"
			spawncount = rand(1 * severity, 3 * severity)
			boss_spawn_count = rand(1,2)
		if(LOC_RESEARCH)
			spawn_area_type = /area/rnd
			locstring = "research and development"
			spawncount = rand(1 * severity, 3 * severity)
			boss_spawn_count = rand(1,2)
		if(LOC_HALLWAYS)
			spawn_area_type =  /area/hallway
			locstring = "public hallways"
			spawncount = rand(2 * severity, 4 * severity)
			boss_spawn_count = rand(1,2)
		if(LOC_BRIDGE)
			spawn_area_type = /area/bridge
			locstring = "bridge"
			spawncount = rand(1 * severity, 3 * severity)
			boss_spawn_count = rand(1,2)

/datum/event/pirate/end()
	var/list/vents = list()
	for(var/areapath in typesof(spawn_area_type))
		var/area/A = locate(areapath)
		for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in A.contents)
			if(temp_vent.network && (temp_vent.loc.z in GLOB.using_map.station_levels))
				vents += temp_vent

	var/pirate_spawn = list(/mob/living/simple_mob/humanoid/pirate, 
	/mob/living/simple_mob/humanoid/pirate/armored, 
	/mob/living/simple_mob/humanoid/pirate/machete,
	/mob/living/simple_mob/humanoid/pirate/machete/armored, 
	/mob/living/simple_mob/humanoid/pirate/shield, 
	/mob/living/simple_mob/humanoid/pirate/shield/armored,
	/mob/living/simple_mob/humanoid/pirate/shield/machete, 
	/mob/living/simple_mob/humanoid/pirate/shield/machete/armored, 
	/mob/living/simple_mob/humanoid/pirate/ranged,
	/mob/living/simple_mob/humanoid/pirate/ranged/armored, 
	/mob/living/simple_mob/humanoid/pirate/ranged/handcannon, 
	/mob/living/simple_mob/humanoid/pirate/ranged/shotgun)
	
	var/pirate_boss = list(/mob/living/simple_mob/humanoid/pirate/mate, 
	/mob/living/simple_mob/humanoid/pirate/mate/ranged,
	/mob/living/simple_mob/humanoid/pirate/mate/ranged/shotgun, 
	/mob/living/simple_mob/humanoid/pirate/mate/ranged/rifle)

	var/num = spawncount
	while(vents.len > 0 && num > 0)
		var/obj/machinery/atmospherics/unary/vent_pump/V = pick(vents)
		num--
		var/spawn_type = pick(pirate_spawn)
		new spawn_type(V.loc)
	var/bossnum = boss_spawn_count
	while(vents.len > 0 && bossnum > 0)
		bossnum--
		var/obj/machinery/atmospherics/unary/vent_pump/V = pick(vents)
		var/spawn_type = pick(pirate_boss)
		new spawn_type(V.loc)

// Overmap version
/datum/event/pirate/overmap/announce()
	command_announcement.Announce("Attention Landlubers of [station_name()], you are trespassing on pirate territory, we are sending over some boys to collect your ship and your loot.", "Incoming Transmission", new_sound = sound('sound/effects/siren.ogg', volume=25))


/datum/event/pirate/overmap/start()		// override - cancel if not main ship since it doesn't properly target the actual triggering ship
	if(istype(victim, /obj/effect/overmap/visitable/ship/landable))
		kill()
