/**
 *! Gateway Templates
 *? This is for gateway maps. These are unique in that there should only ever be one loaded in if any. As well you can make them
 *? overmap accessible or not if you like.
 */

//////////////////////////////
/// Generic overmap effect ///
//////////////////////////////
/*
Use a subtype of this please if you are wanting to have your gateway map be accessible on the overmap
This overmap effect is a generic one that can be used if you do not have anything special to add to it
*/
/obj/effect/overmap/visitable/sector/gateway
	name = "Unknown"
	desc = "Approach and perform a scan to obtain further information."
	icon_state = "object" //or "globe" for planetary stuff
	known = FALSE

//////////////////////////////
/// Generic Template Thing ///
//////////////////////////////
/datum/map_template/lateload/gateway
	abstract_type = /datum/map_template/lateload/gateway
	name = "Gateway Submap"
	desc = "Please do not use this."
	mappath = null
	associated_map_datum = null

/datum/map_level/gateway/gateway_destination
	name = "Gateway Destination"

//////////////////////
/// Snow Outpost   ///
//////////////////////
/datum/map_template/lateload/gateway/snow_outpost
	name = "Snow Outpost"
	desc = "Big snowy area with various outposts."
	mappath = 'maps/away_missions/140x140/snow_outpost.dmm'
	associated_map_datum = /datum/map_level/gateway/gateway_destination

////////////
/// Zoo? ///
////////////
/datum/map_template/lateload/gateway/zoo
	name = "Zoo"
	desc = "Gigantic space zoo"
	mappath = 'maps/away_missions/140x140/zoo.dmm'
	associated_map_datum = /datum/map_level/gateway/gateway_destination

///////////////////
/// Carp Farm   ///
///////////////////
/datum/map_template/lateload/gateway/carpfarm
	name = "Carp Farm"
	desc = "Asteroid base surrounded by carp"
	mappath = 'maps/away_missions/140x140/carpfarm.dmm'
	associated_map_datum = /datum/map_level/gateway/gateway_destination

///////////////////
/// Snow Field  ///
///////////////////
/datum/map_template/lateload/gateway/snowfield
	name = "Snow Field"
	desc = "An old base in middle of snowy wasteland"
	mappath = 'maps/away_missions/140x140/snowfield.dmm'
	associated_map_datum = /datum/map_level/gateway/gateway_destination

//////////////////////
/// Listening Post ///
//////////////////////
/datum/map_template/lateload/gateway/listeningpost
	name = "Listening Post"
	desc = "Asteroid-bound mercenary listening post"
	mappath = 'maps/away_missions/140x140/listeningpost.dmm'
	associated_map_datum = /datum/map_level/gateway/gateway_destination
