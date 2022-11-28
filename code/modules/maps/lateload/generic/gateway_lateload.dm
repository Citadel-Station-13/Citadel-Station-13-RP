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

//////////////////////////////
/// Generic overmap effect ///
//////////////////////////////
/*
Use a subtype of this please if you are wanting to have your gateway map be accessible on the overmap
*/
/obj/effect/overmap/visitable/sector/gateway
	name = "Unknown"
	desc = "Approach and perform a scan to obtain further information."
	icon_state = "object" //or "globe" for planetary stuff
	known = FALSE

//////////////////////////////
/// Generic Template Thing ///
//////////////////////////////
/datum/map_template/gateway_lateload/gateway
	name = "Gateway Submap"
	desc = "Please do not use this."
	mappath = null
	associated_map_datum = null

/datum/map_z_level/gateway_lateload/gateway_destination
	name = "Gateway Destination"

//////////////////////////////
/// Snow Outpost		   ///
//////////////////////////////
/datum/map_template/gateway_lateload/gateway/snow_outpost
	name = "Snow Outpost"
	desc = "Big snowy area with various outposts."
	mappath = '_maps/away_missions/140x140/snow_outpost.dmm'
	associated_map_datum = /datum/map_z_level/gateway_lateload/gateway_destination

//////////////////////////////
/// Zoo? 				   ///
//////////////////////////////
/datum/map_template/gateway_lateload/gateway/zoo
	name = "Zoo"
	desc = "Gigantic space zoo"
	mappath = '_maps/away_missions/140x140/zoo.dmm'
	associated_map_datum = /datum/map_z_level/gateway_lateload/gateway_destination

//////////////////////////////
/// Carp Farm   		   ///
//////////////////////////////
/datum/map_template/gateway_lateload/gateway/carpfarm
	name = "Carp Farm"
	desc = "Asteroid base surrounded by carp"
	mappath = '_maps/away_missions/140x140/carpfarm.dmm'
	associated_map_datum = /datum/map_z_level/gateway_lateload/gateway_destination

//////////////////////////////
/// Snow Field  		   ///
//////////////////////////////
/datum/map_template/gateway_lateload/gateway/snowfield
	name = "Snow Field"
	desc = "An old base in middle of snowy wasteland"
	mappath = '_maps/away_missions/140x140/snowfield.dmm'
	associated_map_datum = /datum/map_z_level/gateway_lateload/gateway_destination

//////////////////////////////
/// Listening Post		   ///
//////////////////////////////
/datum/map_template/gateway_lateload/gateway/listeningpost
	name = "Listening Post"
	desc = "Asteroid-bound mercenary listening post"
	mappath = '_maps/away_missions/140x140/listeningpost.dmm'
	associated_map_datum = /datum/map_z_level/gateway_lateload/gateway_destination
