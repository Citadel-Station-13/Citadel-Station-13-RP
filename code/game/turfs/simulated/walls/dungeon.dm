// Special wall type for Point of Interests.

/turf/simulated/wall/dungeon
	block_tele = TRUE // Anti-cheese.

/turf/simulated/wall/dungeon
	material = /datum/material/alienalloy/dungeonium

/turf/simulated/wall/dungeon/attackby()
	return

/turf/simulated/wall/dungeon/legacy_ex_act()
	return

/turf/simulated/wall/dungeon/take_damage()	//These things are suppose to be unbreakable
	return

/turf/simulated/wall/solidrock //for more stylish anti-cheese.
	name = "solid rock"
	desc = "This rock seems dense, impossible to drill."
	description_info = "Probably not going to be able to drill or bomb your way through this, best to try and find a way around."
	icon = 'icons/turf/walls/rock.dmi'
	block_tele = TRUE

/turf/simulated/wall/solidrock/update_overlays()
	. = ..()

	if(!(smoothing_junction & NORTH_JUNCTION))
		. += mutable_appearance(get_cached_rock_border("solidrock_rock_side", NORTH, icon, "rock_side"), "rock_side")
	if(!(smoothing_junction & SOUTH_JUNCTION))
		. += mutable_appearance(get_cached_rock_border("solidrock_rock_side", SOUTH, icon, "rock_side"), "rock_side")
	if(!(smoothing_junction & EAST_JUNCTION))
		. += mutable_appearance(get_cached_rock_border("solidrock_rock_side", EAST, icon, "rock_side"), "rock_side")
	if(!(smoothing_junction & WEST_JUNCTION))
		. += mutable_appearance(get_cached_rock_border("solidrock_rock_side", WEST, icon, "rock_side"), "rock_side")

/turf/simulated/wall/solidrock/attackby()
	return

/turf/simulated/wall/solidrock/legacy_ex_act()
	return

/turf/simulated/wall/solidrock/take_damage()	//These things are suppose to be unbreakable
	return
