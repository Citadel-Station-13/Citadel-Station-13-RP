// Special wall type for Point of Interests.

/turf/simulated/wall/dungeon
	block_tele = TRUE // Anti-cheese.

/turf/simulated/wall/dungeon/Initialize(mapload, materialtype, rmaterialtype, girder_material)
	return ..(mapload, "dungeonium")

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
	icon_state = "bedrock"
	var/base_state = "bedrock"
	block_tele = TRUE

/turf/simulated/wall/solidrock/find_type_in_direction(direction)
	var/turf/T = get_step(src, direction)
	if(!T)
		return NULLTURF_BORDER
	return T.density? ADJ_FOUND : NO_ADJ_FOUND

/turf/simulated/wall/solidrock/custom_smooth(dirs)
	smoothing_junction = dirs

	if(!(smoothing_junction & NORTH_JUNCTION))
		add_overlay(get_cached_rock_border("rock_side", NORTH, 'icons/turf/walls.dmi', "rock_side"))
	if(!(smoothing_junction & SOUTH_JUNCTION))
		add_overlay(get_cached_rock_border("rock_side", SOUTH, 'icons/turf/walls.dmi', "rock_side"))
	if(!(smoothing_junction & EAST_JUNCTION))
		add_overlay(get_cached_rock_border("rock_side", EAST, 'icons/turf/walls.dmi', "rock_side"))
	if(!(smoothing_junction & WEST_JUNCTION))
		add_overlay(get_cached_rock_border("rock_side", WEST, 'icons/turf/walls.dmi', "rock_side"))

/turf/simulated/wall/solidrock/Initialize(mapload)
	. = ..()
	icon_state = base_state

/turf/simulated/wall/solidrock/attackby()
	return

/turf/simulated/wall/solidrock/legacy_ex_act()
	return

/turf/simulated/wall/solidrock/take_damage()	//These things are suppose to be unbreakable
	return
