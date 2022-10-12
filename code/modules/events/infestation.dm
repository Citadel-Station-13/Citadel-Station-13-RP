#define LOC_KITCHEN 1
#define LOC_ATMOS 2
#define LOC_CHAPEL 3
#define LOC_LIBRARY 4
#define LOC_HALLWAYS 5
#define LOC_RESEARCH 6
#define LOC_MINING 7
#define LOC_HYDRO 8
#define LOC_ENGINEERING 9

#define VERM_MICE 1
#define VERM_LIZARDS 2
#define VERM_SPIDERS 3
#define VERM_ROACHES 4

/datum/event/infestation
	var/location
	var/locstring
	var/spawn_area_type
	var/spawncount = 1
	var/vermin
	var/vermstring
	var/spawn_types = list()
	var/cloud_hueshift
	var/list/players = list()
	has_skybox_image = TRUE

/datum/event/infestation/get_skybox_image()
	var/color1 = color_matrix_multiply(color_matrix_rotate_hue(rand(-3, 3) * 15), rgba_auto_greyscale_matrix("#8888ff"))
	var/color2 = color_matrix_multiply(color_matrix_rotate_hue(rand(-3, 3) * 15), rgba_auto_greyscale_matrix("#88ff88"))
	var/image/res = image('icons/skybox/caelus.dmi', "aurora")
	res.appearance_flags = RESET_COLOR
	res.blend_mode = BLEND_ADD
	animate_color_shift(res, color1, color2, 1080 * 0.5, 1080 * 0.5)
	return res

/datum/event/infestation/setup()
	// make sure startWhen doesn't go to 0 or below!
	announceWhen = rand(2, 5)
	startWhen = announceWhen - 1
	endWhen = 30

/datum/event/infestation/announce()
	command_announcement.Announce("Bioscans indicate that [vermstring] have been breeding in [locstring]. Clear them out, before this starts to affect productivity.", "Vermin infestation")

/datum/event/infestation/start()
	location = rand(1,9)
	switch(location)
		if(LOC_KITCHEN)
			spawn_area_type = /area/crew_quarters/kitchen
			locstring = "kitchen"
			spawncount = rand(3,15)
		if(LOC_ATMOS)
			spawn_area_type = /area/engineering/atmos
			locstring = "atmospherics"
			spawncount = rand(3,15)
		if(LOC_CHAPEL)
			spawn_area_type = /area/chapel
			locstring = "the chapel"
			spawncount = rand(3,15)
		if(LOC_LIBRARY)
			spawn_area_type = /area/library
			locstring = "library"
			spawncount = rand(3,15)
		if(LOC_HALLWAYS)
			spawn_area_type = /area/hallway
			locstring = "public hallways"
			spawncount = rand(3,15)
		if(LOC_RESEARCH)
			spawn_area_type = /area/rnd
			locstring = "research and development"
			spawncount = rand(3,15)
		if(LOC_MINING)
			spawn_area_type = /area/quartermaster
			locstring = "cargo & mining"
			spawncount = rand(3,15)
		if(LOC_HYDRO)
			spawn_area_type = /area/hydroponics
			locstring = "hydroponics"
			spawncount = rand(3,15)
		if(LOC_ENGINEERING)
			spawn_area_type = /area/engineering/
			locstring = "engineering"
			spawncount = rand(3,15)
	if(!locstring)
		spawn_area_type = /area/hallway
		locstring = "public hallways"
		spawncount = rand(3,15)

	vermin = rand(1,4)
	switch(vermin)
		if(VERM_MICE)
			spawn_types = list(/mob/living/simple_mob/animal/passive/mouse/gray, /mob/living/simple_mob/animal/passive/mouse/brown, /mob/living/simple_mob/animal/passive/mouse/white)
			vermstring = "mice"
		if(VERM_LIZARDS)
			spawn_types = list(/mob/living/simple_mob/animal/passive/lizard)
			vermstring = "lizards"
		if(VERM_SPIDERS)
			spawn_types = list(/obj/effect/spider/spiderling/no_crawl)
			vermstring = "spiders"
		if(VERM_ROACHES)
			spawn_types = list(/mob/living/simple_mob/animal/roach/roachling)
			vermstring = "giant roaches"

/datum/event/infestation/end()
	var/list/vents = list()
	for(var/areapath in typesof(spawn_area_type))
		var/area/A = locate(areapath)
		for(var/obj/machinery/atmospherics/component/unary/vent_pump/temp_vent in A.contents)
			if(!temp_vent.welded && temp_vent.network && (temp_vent.loc.z in GLOB.using_map.station_levels))
				vents += temp_vent

	spawn(0)
		var/num = spawncount
		var/spawn_type = pick(spawn_types)
		while(vents.len > 0 && num > 0)
			var/obj/machinery/atmospherics/component/unary/vent_pump/V = pick(vents)
			num--
			new spawn_type(V.loc)

			/*	//This prevents spiderlings from maturing into hostile spiders. I'm disabling it because this event has no stakes otherwise.
			if(vermin == VERM_SPIDERS)
				var/obj/effect/spider/spiderling/S = new(T)
				S.amount_grown = -1
			else
				var/spawn_type = pick(spawn_types)
				new spawn_type(T)
			*/

// Overmap version
/datum/event/infestation/overmap/announce()
	command_announcement.Announce("Unidentified hostile lifesigns detected migrating towards [station_name()]'s [locstring] through the exterior pipes. Secure any exterior access, including ducting and ventilation.", "Hostile Vermin Boarding Alert", new_sound = 'sound/AI/aliens.ogg')
	return

// override: cancel if not main ship as this is too dumb to target the actual ship crossing it.
/datum/event/infestation/overmap/start()
	if(istype(victim, /obj/effect/overmap/visitable/ship/landable))
		kill()
		return
	return ..()

#undef LOC_KITCHEN
#undef LOC_ATMOS
#undef LOC_CHAPEL
#undef LOC_LIBRARY
#undef LOC_HALLWAYS
#undef LOC_RESEARCH
#undef LOC_MINING
#undef LOC_HYDRO
#undef LOC_ENGINEERING

#undef VERM_MICE
#undef VERM_LIZARDS
#undef VERM_SPIDERS
#undef VERM_ROACHES
