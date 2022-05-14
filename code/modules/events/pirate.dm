#define LOC_CARGO		0
#define LOC_SECURITY	1
#define LOC_RESEARCH	2
#define LOC_HALLWAYS	3
#define LOC_BRIDGE		4
#define LOC_TALON		5

/datum/event/pirate
	var/location
	var/locstring
	var/spawn_area_type
	var/spawncount = 1
	var/boss_spawn_count = 1
	var/piratestring
	var/toughness
	var/cloud_hueshift
	var/isTalon = 0
	var/list/players = list()
	has_skybox_image = FALSE

/datum/event/pirate/setup()
	announceWhen = rand(announceWhen+2, announceWhen + 3)
	startWhen = announceWhen
	endWhen = 45

/datum/event/pirate/announce()
	if	(piratestring == "human")
		command_announcement.Announce("Attention, Crew of the [station_name()], hand over your valuables and your vessel and no one gets hurt!", "Incoming Transmission", new_sound = sound('sound/effects/siren.ogg', volume=25))
	if 	(piratestring == "vox")
		command_announcement.Announce("Hellos Dustlungs of [station_name()], you be handings over your scrap and tasty Teshari or we wills skrek you up!", "Incoming Transmission", new_sound = sound('sound/effects/siren.ogg', volume=25))
	if 	(piratestring =="rats")
		command_announcement.Announce("Tiny Boarding Torpedos have been detected on Route to [station_name()]. Prepare Crew to repell small boarders.", "Boarding Alert", new_sound = sound('sound/effects/siren.ogg', volume=25))

/datum/event/pirate/start()
	switch(rand(1,100))
		if(1 to 60)
			toughness = 1
			piratestring = "human"
		if(61 to 80)
			toughness = 1
			piratestring = "vox"
		else
			toughness = 2
			piratestring = "rats"
	sleep(1)
	if(isTalon == 0)
		location = rand(0,4)
	switch(location)
		if(LOC_CARGO)
			spawn_area_type = /area/quartermaster
			locstring = "cargo & mining"
			spawncount = rand(1 * severity * toughness, 3 * severity * toughness)
			boss_spawn_count = 1
		if(LOC_SECURITY)
			spawn_area_type = /area/security
			locstring = "security"
			spawncount = rand(1 * severity * toughness, 3 * severity * toughness)
			boss_spawn_count = rand(1,toughness)
		if(LOC_RESEARCH)
			spawn_area_type = /area/rnd
			locstring = "research and development"
			spawncount = rand(1 * severity * toughness, 3 * severity * toughness)
			boss_spawn_count = rand(1,toughness)
		if(LOC_HALLWAYS)
			spawn_area_type =  /area/hallway
			locstring = "public hallways"
			spawncount = rand(2 * severity * toughness, 4 * severity * toughness)
			boss_spawn_count = rand(1,toughness)
		if(LOC_BRIDGE)
			spawn_area_type = /area/bridge
			locstring = "bridge"
			spawncount = rand(1 * severity * toughness, 3 * severity * toughness)
			boss_spawn_count = rand(1,toughness)
		if(LOC_TALON) //The Talon. Outside of the random range. Should never be picked randomly.
			spawn_area_type = /area/talon
			locstring = "talon"
			spawncount = rand(1 * severity * toughness, 3 * severity * toughness)
			boss_spawn_count = rand(0,toughness)

/datum/event/pirate/end()
	var/list/vents = list()
	var/pirate_spawn = list()
	var/pirate_boss = list()
	for(var/areapath in typesof(spawn_area_type))
		var/area/A = locate(areapath)
		for(var/obj/machinery/atmospherics/component/unary/vent_pump/temp_vent in A.contents)
			if(temp_vent.network && ((temp_vent.loc.z in GLOB.using_map.station_levels) || isTalon == 1))
				vents += temp_vent

	if(piratestring == "human")
		pirate_spawn = list(/mob/living/simple_mob/humanoid/pirate,
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

		pirate_boss = list(/mob/living/simple_mob/humanoid/pirate/mate,
		/mob/living/simple_mob/humanoid/pirate/mate/ranged,
		/mob/living/simple_mob/humanoid/pirate/mate/ranged/shotgun,
		/mob/living/simple_mob/humanoid/pirate/mate/ranged/rifle)

	if(piratestring == "vox")
		pirate_spawn = list(/mob/living/simple_mob/humanoid/merc/voxpirate/pirate,
		/mob/living/simple_mob/humanoid/merc/voxpirate/boarder,
		/mob/living/simple_mob/humanoid/merc/voxpirate/shotgun,
		/mob/living/simple_mob/humanoid/merc/voxpirate/technician,
		/mob/living/simple_mob/humanoid/merc/voxpirate/suppressor)

		pirate_boss = /mob/living/simple_mob/humanoid/merc/voxpirate/captain

	if(piratestring == "rats")
		pirate_spawn = list(/mob/living/simple_mob/animal/space/mouse_army/operative,
		/mob/living/simple_mob/animal/space/mouse_army/pyro,
		/mob/living/simple_mob/animal/space/mouse_army/ammo,
		/mob/living/simple_mob/animal/space/mouse_army/stealth)

		pirate_boss = list(/mob/living/simple_mob/mechanical/mecha/mouse_tank/manned,
		/mob/living/simple_mob/mechanical/mecha/mouse_tank/livewire/manned,
		/mob/living/simple_mob/mechanical/mecha/mouse_tank/eraticator/manned)


	var/num = spawncount
	while(vents.len > 0 && num > 0)
		var/obj/machinery/atmospherics/component/unary/vent_pump/V = pick(vents)
		num--
		var/spawn_type = pick(pirate_spawn)
		new spawn_type(V.loc)
	var/bossnum = boss_spawn_count
	while(vents.len > 0 && bossnum > 0)
		bossnum--
		var/obj/machinery/atmospherics/component/unary/vent_pump/V = pick(vents)
		var/spawn_type = pick(pirate_boss)
		new spawn_type(V.loc)
	isTalon = 0

// Overmap version
/datum/event/pirate/overmap/announce()
	if(istype(victim, /obj/effect/overmap/visitable/ship/talon))
		if(piratestring == "human")
			command_announcement.Announce("Attention, Crew of the ITV Talon, thanks for delivering your ship to us suckers!", "Incoming Transmission")
		if (piratestring == "vox")
			command_announcement.Announce("Skreking Dustlungs of ITV Talon, yous in Voxy Territory! We's coming over to collect yours scrap", "Incoming Transmission")
		if (piratestring =="rats")
			command_announcement.Announce("A tiny teleportation matrix has been detected on the nearby vessel ITV Talon. Prepare Crew to repell small boarders.", "Boarding Alert")
	else
		if(piratestring == "human")
			command_announcement.Announce("Attention, Crew of the [station_name()], thanks for delivering your ship to us suckers!", "Incoming Transmission", new_sound = sound('sound/effects/siren.ogg', volume=25))
		if (piratestring == "vox")
			command_announcement.Announce("Skreking Dustlungs of [station_name()], yous in Voxy Territory! We's coming over to collect yours scrap", "Incoming Transmission", new_sound = sound('sound/effects/siren.ogg', volume=25))
		if (piratestring =="rats")
			command_announcement.Announce("Attention [station_name()], a tiny teleportation matrix has been detected on the nearby vessel. Prepare Crew to repell small boarders.", "Boarding Alert", new_sound = sound('sound/effects/siren.ogg', volume=25))

/datum/event/pirate/overmap/start()		// override - cancel if not main ship since it doesn't properly target the actual triggering ship
	if(istype(victim, /obj/effect/overmap/visitable/ship/landable))
		kill()
	if(istype(victim, /obj/effect/overmap/visitable/ship/talon)) //Forces the location to be the Talon.
		isTalon = 1
		location = 5
	return ..()

#undef	LOC_CARGO
#undef	LOC_SECURITY
#undef	LOC_RESEARCH
#undef	LOC_HALLWAYS
#undef	LOC_BRIDGE
#undef	LOC_TALON
