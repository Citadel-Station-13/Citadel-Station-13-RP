/**
 * cursed as fuck
 *
 * load these sequentially for the number you want
 * you usually don't need more than 1-2 to make belt mining work
 * i think (?)
 */
/datum/map/sector/roguemining_192
	abstract_type = /datum/map/sector/roguemining_192
	width = 192
	height = 192

/datum/map_level/sector/roguemining_192

/datum/map/sector/roguemining_192/one
	id = "roguemining_192_1"
	name = "Roguemining - Allocation 1"
	levels = list(
		/datum/map_level/sector/roguemining_192/one,
	)

/datum/map_level/sector/roguemining_192/one
	id = "Roguemining1"
	name = "Roguemining - Allocation 1"
	absolute_path = "maps/sectors/roguemining_192/levels/roguemining_192_1.dmm"

// we only use one allocation now
