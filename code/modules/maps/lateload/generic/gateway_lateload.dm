////////////////////////////////////////////////
///////    Gateway Templates     ///////////////
////////////////////////////////////////////////

/*
This is for gateway maps. These are unique in that there should only ever be one loaded in if any. As well you can make them
overmap accessible or not if you like.

If you are wanting to add a map like lavaland that isn't accessible
from the overmap and *are not* gateway missions please put it in unique_lateload.dm

For overmap things that are planets and accessible from the overmap please put them
in planets_lateload.dm

For overmap things that are in space and *are not* planets put them in space_lateload.dm

*/

/datum/map_template/gateway_lateload
	allow_duplicates = FALSE
	var/associated_map_datum

/datum/map_template/gateway_lateload/on_map_loaded(z)
	if(!associated_map_datum || !ispath(associated_map_datum))
		log_game("Extra z-level [src] has no associated map datum")
		return

	new associated_map_datum(GLOB.using_map, z)

/datum/map_z_level/gateway_lateload
	z = 0

/datum/map_z_level/gateway_lateload/New(var/datum/map/map, mapZ)
	if(mapZ && !z)
		z = mapZ
	return ..(map)

