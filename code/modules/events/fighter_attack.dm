#define LOC_SPACE		0

/datum/event/fighter
	var/location
	var/locstring
	var/spawn_area_type
	var/spawncount = 1
	var/piratestring
	var/toughness
	var/cloud_hueshift
	var/list/players = list()
	has_skybox_image = FALSE

/datum/event/fighter/setup()
	announceWhen = rand(announceWhen+2, announceWhen + 3)
	startWhen = announceWhen
	endWhen = 45

/datum/event/fighter/announce()
	if	(piratestring == "bandits")
		command_announcement.Announce("Attention, [station_name()], hostile fighters entered the area of operations", "GPS Displaying hostile signals", new_sound = sound('sound/effects/siren.ogg', volume=25))

/datum/event/fighter/start()
	switch(rand(0,100))
		if(1 to 100)
			spawncount = rand(2 * severity * toughness, 4 * severity * toughness)
			piratestring = "bandits"
		if(LOC_SPACE)
			spawn_area_type = /area/space
			locstring = "space"


/datum/event/fighter/end()
	// var/bandits_spawn = list()
	// for(var/areapath in typesof(spawn_area_type))

	// if(piratestring == "bandits")
	// 	bandits_spawn = list(/mob/living/simple_mob/mechanical/mecha/fighter/duke/manned,
	// 	/mob/living/simple_mob/mechanical/mecha/fighter/baron/manned)

#undef	LOC_SPACE
