/**
 * cursed as fuck
 *
 * load these sequentially for the number you want
 * you usually don't need more than 1-2 to make belt mining work
 * i think (?)
 */
/datum/map/sector/roguemining_140
	abstract_type = /datum/map/sector/roguemining_140
	width = 140
	height = 140

/datum/map_level/sector/roguemining_140

/datum/map/sector/roguemining_140/one
	id = "roguemining_140_1"
	name = "Roguemining - Allocation 1"
	levels = list(
		/datum/map_level/sector/roguemining_140/one,
	)

/datum/map_level/sector/roguemining_140/one
	id = "Roguemining1"
	name = "Roguemining - Allocation 1"
	absolute_path = "maps/sectors/roguemining_140/levels/roguemining_140_1.dmm"

// we only use one allocation now
