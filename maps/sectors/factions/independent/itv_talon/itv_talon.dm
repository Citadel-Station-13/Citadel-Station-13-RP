/**
 * The return of the king.
 */
/datum/map/sector/itv_talon
	name = "ITV Talon"

/datum/map_level/sector/itv_talon
	abstract_type = /datum/map_level/sector/itv_talon

/datum/map_level/sector/itv_talon/deck_1
	link_above_id = /datum/map_level/sector/itv_talon/deck_2::id

/datum/map_level/sector/itv_talon/deck_2
	link_below_id = /datum/map_level/sector/itv_talon/deck_1::id

#warn impl


// // Talon offmap spawn stuff
// /datum/map_template/triumph_lateload/offmap/talon1
// 	name = "Offmap Ship - Talon Z1"
// 	desc = "Offmap spawn ship, the Talon."
// 	map_path = "maps/map_levels/140x140/talon/talon1.dmm"
// 	associated_map_datum = /datum/map_level/triumph_lateload/talon1

// /datum/map_template/triumph_lateload/offmap/talon2
// 	name = "Offmap Ship - Talon Z2"
// 	desc = "Offmap spawn ship, the Talon."
// 	map_path = "maps/map_levels/140x140/talon/talon2.dmm"
// 	associated_map_datum = /datum/map_level/triumph_lateload/talon2

// /datum/map_level/triumph_lateload/talon1
// 	name = "Talon Deck One"
// 	flags = LEGACY_LEVEL_PLAYER
// 	z = Z_LEVEL_TALON1

// /datum/map_level/triumph_lateload/talon2
// 	name = "Talon Deck Two"
// 	flags = LEGACY_LEVEL_PLAYER
// 	z = Z_LEVEL_TALON2
#warn map
