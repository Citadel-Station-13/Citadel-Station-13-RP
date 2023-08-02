// Special wall type for Point of Interests.

/turf/simulated/wall/dungeon
	block_tele = TRUE // Anti-cheese.

/turf/simulated/wall/dungeon
	material = /datum/material/alienalloy/dungeonium

/turf/simulated/wall/dungeon/attackby()
	return

/turf/simulated/wall/dungeon/legacy_ex_act()
	return

/turf/simulated/wall/dungeon/take_damage_legacy()	//These things are suppose to be unbreakable
	return

/turf/simulated/wall/solidrock //for more stylish anti-cheese.
	name = "solid rock"
	desc = "This rock seems dense, impossible to drill."
	description_info = "Probably not going to be able to drill or bomb your way through this, best to try and find a way around."
	icon = 'icons/turf/walls/rock.dmi'
	block_tele = TRUE

	var/rock_side_icon_state = "rock_side"

/turf/simulated/wall/solidrock/update_overlays()
	. = ..()

	// TODO: Replace these layers with defines. (I have some being added in another PR) @Zandario
	var/mutable_appearance/appearance
	if(!(smoothing_junction & NORTH_JUNCTION))
		appearance = mutable_appearance(icon, "[rock_side_icon_state]_s", layer = EDGE_LAYER)
		appearance.pixel_y = 32
		. += appearance
	if(!(smoothing_junction & SOUTH_JUNCTION))
		appearance = mutable_appearance(icon, "[rock_side_icon_state]_n", layer = EDGE_LAYER)
		appearance.pixel_y = -32
		. += appearance
	if(!(smoothing_junction & WEST_JUNCTION))
		appearance = mutable_appearance(icon, "[rock_side_icon_state]_e", layer = EDGE_LAYER)
		appearance.pixel_x = -32
		. += appearance
	if(!(smoothing_junction & EAST_JUNCTION))
		appearance = mutable_appearance(icon, "[rock_side_icon_state]_w", layer = EDGE_LAYER)
		appearance.pixel_x = 32
		. += appearance

/turf/simulated/wall/solidrock/attackby()
	return

/turf/simulated/wall/solidrock/legacy_ex_act()
	return

/turf/simulated/wall/solidrock/take_damage_legacy()	//These things are suppose to be unbreakable
	return
