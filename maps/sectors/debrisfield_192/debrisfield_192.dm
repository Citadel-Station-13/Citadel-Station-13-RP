/datum/map_template/lateload/space/away_debrisfield
	name = "Debris Field - Z1 Space"
	desc = "A random debris field out in space."
	mappath = "maps/map_levels/192x192/debrisfield.dmm"
	associated_map_datum = /datum/map_level/space_lateload/away_debrisfield


/datum/map_template/lateload/space/away_debrisfield/on_map_loaded(z)
	. = ..()
	seed_submaps(list(z), 200, /area/space/debrisfield/unexplored, /datum/map_template/submap/level_specific/debrisfield)

/datum/map_level/space_lateload/away_debrisfield
	name = "Away Mission - Debris Field"
	base_turf = /turf/space

#warn translate
