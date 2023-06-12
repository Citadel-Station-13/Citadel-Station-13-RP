//////////////////////////////////////////////
/// Example Template                       ///
//////////////////////////////////////////////

/datum/map_template/lateload/example
	name = "Example Planet"
	/// ^ The name of your planet. This is what you will need to put in the lateload_z_level list to actually have it be created.
	/// If it is not on the list it will not be created, simple as that

	desc = "A completely generic and unassuming planet"
	/// ^ The description of the planet. Is only seen by admins if they manually load in a planet, dont be
	/// too verbose. For changing what people see in game when they scan it you will need to edit the overmap effect itself
	/// (overmap effect as of me writing this are in the overmap folder)

	map_path = "maps/map_levels/192x192/Class_G.dmm"
	/// ^ The direct file path for your map. Is case sensitive and you need to use /'s not \'s
	/// Make sure your map file is in a sensible location please for organization sake

	associated_map_datum = /datum/map_level/example
	/// ^ This should point to the datum down below. Is used ingame after the z level is index'd for debugging purposes

	ztraits = list(ZTRAIT_AWAY = TRUE, ZTRAIT_GRAVITY = TRUE)
	/// Z level traits. Controls some behavior of the z level. Check out maps.dm for more information

/datum/map_level/example
	name = "Away Mission - Example Planet"
	/// Does not have to be the same name as the one you used above. Keep it short and to the point

	base_turf = /turf/space/basic
	/// What the base turf of the z level is, aka what is left when something like maxcap bomb goes off. If not defined
	/// it will default to /turf/simulated/space

	flags = LEGACY_LEVEL_CONTACT|LEGACY_LEVEL_PLAYER
	/// Z level flags. Similiar to traits except they control a couple different things. These two are what you are likely going
	/// to be using a lot. LEGACY_LEVEL_CONTACT means you will be able to hear station alerts and such. LEGACY_LEVEL_PLAYER simply tells
	/// the z level that players will likely be on the z level. Check out maps.dm for more information

/datum/map_template/lateload/example/on_map_loaded(z)
	. = ..()
	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, z, world.maxx - 4, world.maxy - 4) // Create the mining Z-level.
	seed_submaps(list(z), 150, /area/class_d/unexplored, /datum/map_template/submap/level_specific/class_d)
	/// Anything you want to have happen when the z level is loaded. In this case cave automata is generating caves in mineral
	/// turfs as well as making basic ores. seed_submaps is generating submaps in a specified area from a map_template file.
	/// Check the generic/submaps from the main map file section for example submaps
