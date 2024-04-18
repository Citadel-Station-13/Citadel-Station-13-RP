/obj/map_helper/tradeshuttle_side_selector
	name = "tradeshuttle side selector"
	early = TRUE

/obj/map_helper/tradeshuttle_side_selector/New()
	return ..()

/obj/map_helper/tradeshuttle_side_selector/Initialize(mapload)
	return ..()

/obj/map_helper/tradeshuttle_side_selector/map_initializations(list/bounds, lx, ly, lz, ldir)
	var/active_map = SSmapping.loaded_station.id
	var/datum/map_template/tradeshuttle_side/used_side
	if(active_map == "tether")
		used_side = new /datum/map_template/tradeshuttle_side/starbord
	else
		used_side = new /datum/map_template/tradeshuttle_side/port
	var/turf/our_loc = get_turf(src)

	used_side.load(locate(our_loc.x, our_loc.y, our_loc.z), orientation = ldir)


/datum/map_template/tradeshuttle_side
	abstract_type = /datum/map_template/tradeshuttle_side
	name = "Tradeshuttle Content"
	desc = "Because sometimes you cant just use the portside airlock to dock."
	prefix = "maps/tether/engines/"

/datum/map_template/tradeshuttle_side/starbord
	name = "starbord"
	desc = "starbord side docking"
	suffix = "starbord.dmm"

/datum/map_template/tradeshuttle_side/port
	name = "port"
	desc = "port side docking"
	suffix = "port.dmm"
