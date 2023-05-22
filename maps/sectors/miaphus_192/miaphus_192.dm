
/datum/map_template/lateload/planets/away_beach
	name = "Desert Planet - Z1 Beach"
	desc = "The beach away mission."
	mappath = "maps/map_levels/192x192/miaphus_beach.dmm"
	associated_map_datum = /datum/map_level/planets_lateload/away_beach

/datum/map_level/planets_lateload/away_beach
	name = "Away Mission - Desert Beach"
	base_turf = /turf/simulated/floor/outdoors/rocks/caves

/datum/map_template/lateload/planets/away_beach_cave
	name = "Desert Planet - Z2 Cave"
	desc = "The beach away mission's cave."
	mappath = "maps/map_levels/192x192/miaphus_cave.dmm"
	associated_map_datum = /datum/map_level/planets_lateload/away_beach_cave

/datum/map_template/lateload/planets/away_beach_cave/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 225, /area/tether_away/cave/unexplored/normal, /datum/map_template/submap/level_specific/mountains/normal)
	//seed_submaps(list(z), 70, /area/tether_away/cave/unexplored/normal, /datum/map_template/submap/level_specific/mountains/deep)

	// Now for the tunnels.
	new /datum/random_map/automata/cave_system/no_cracks(null, 3, 3, z, world.maxx - 4, world.maxy - 4)
	new /datum/random_map/noise/ore/beachmine(null, 1, 1, z, 64, 64)

/datum/map_level/planets_lateload/away_beach_cave
	name = "Away Mission - Desert Cave"
	base_turf = /turf/simulated/floor/outdoors/rocks/caves

/datum/map_template/lateload/planets/away_desert
	name = "Desert Planet - Z3 Desert"
	desc = "The inland desert of V-4."
	mappath = "maps/map_levels/192x192/miaphus_desert.dmm"
	associated_map_datum = /datum/map_template/submap/level_specific/class_h

/datum/map_template/lateload/planets/away_desert/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 225, /area/tether_away/beach/desert/unexplored, /datum/map_template/submap/level_specific/class_h)

/datum/map_level/planets_lateload/away_desert
	name = "Away Mission - Desert"
	base_turf = /turf/simulated/floor/outdoors/beach/sand/lowdesert


/obj/effect/step_trigger/zlevel_fall/beach
	var/static/target_z
