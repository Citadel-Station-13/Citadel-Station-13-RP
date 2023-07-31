#define ZLEVEL_STATION (1<<0)
#define ZLEVEL_ADMIN   (1<<1)
#define ZLEVEL_CONTACT (1<<2)
#define ZLEVEL_PLAYER  (1<<3)
#define ZLEVEL_SEALED  (1<<4)

GLOBAL_LIST_EMPTY(levels_by_z)
GLOBAL_LIST_EMPTY(levels_by_id)

/obj/level_data
	// simulated = FALSE

	var/my_z
	var/level_id
	var/list/connects_to
	var/level_flags


INITIALIZE_IMMEDIATE(/obj/level_data)
/obj/level_data/Initialize()
	. = ..()
	my_z = z
	forceMove(null)
	if(GLOB.levels_by_z["[my_z]"])
		stack_trace("Duplicate level data created for z[z].")
	GLOB.levels_by_z["[my_z]"] = src
	if(!level_id)
		level_id = "leveldata_[my_z]_[sequential_id(/obj/level_data)]"
	if(level_id in GLOB.levels_by_id)
		stack_trace("Duplicate level_id '[level_id]' for z[my_z].")
	else
		GLOB.levels_by_id[level_id] = src

	if(level_flags & ZLEVEL_STATION)
		(LEGACY_MAP_DATUM).station_levels |= my_z
	if(level_flags & ZLEVEL_ADMIN)
		(LEGACY_MAP_DATUM).admin_levels   |= my_z
	if(level_flags & ZLEVEL_CONTACT)
		(LEGACY_MAP_DATUM).contact_levels |= my_z
	if(level_flags & ZLEVEL_PLAYER)
		(LEGACY_MAP_DATUM).player_levels  |= my_z
	if(level_flags & ZLEVEL_SEALED)
		(LEGACY_MAP_DATUM).sealed_levels  |= my_z

/obj/level_data/Destroy(force)
	if(force)
		new type(locate(round(world.maxx/2), round(world.maxy/2), my_z))
		return ..()
	return QDEL_HINT_LETMELIVE

/obj/level_data/proc/find_connected_levels(list/found)
	for(var/other_id in connects_to)
		var/obj/level_data/neighbor = GLOB.levels_by_id[other_id]
		neighbor.add_connected_levels(found)

/obj/level_data/proc/add_connected_levels(list/found)
	. = found
	if((my_z in found))
		return
	LAZYADD(found, my_z)
	if(!length(connects_to))
		return
	for(var/other_id in connects_to)
		var/obj/level_data/neighbor = GLOB.levels_by_id[other_id]
		neighbor.add_connected_levels(found)

// Mappable subtypes.
/obj/level_data/main_level
	name = "Main Station Level"
	level_flags = (ZLEVEL_STATION|ZLEVEL_CONTACT|ZLEVEL_PLAYER)

/obj/level_data/admin_level
	name = "Admin Level"
	level_flags = (ZLEVEL_ADMIN|ZLEVEL_SEALED)

/obj/level_data/player_level
	name = "Player Level"
	level_flags = (ZLEVEL_CONTACT|ZLEVEL_PLAYER)

BLOCK_BYOND_BUG_2072419

#undef ZLEVEL_STATION
#undef ZLEVEL_ADMIN
#undef ZLEVEL_CONTACT
#undef ZLEVEL_PLAYER
#undef ZLEVEL_SEALED
