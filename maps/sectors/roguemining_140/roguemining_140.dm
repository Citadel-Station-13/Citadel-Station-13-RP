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
	traits = list(
		ZTRAIT_LEGACY_BELTER_ACTIVE,
	)

/datum/map/sector/roguemining_140/two
	id = "roguemining_140_2"
	name = "Roguemining - Allocation 2"
	levels = list(
		/datum/map_level/sector/roguemining_140/two,
	)

/datum/map_level/sector/roguemining_140/two
	id = "Roguemining2"
	name = "Roguemining - Allocation 2"
	absolute_path = "maps/sectors/roguemining_140/levels/roguemining_140_2.dmm"
	traits = list(
		ZTRAIT_LEGACY_BELTER_ACTIVE,
	)

/datum/map/sector/roguemining_140/three
	id = "roguemining_140_3"
	name = "Roguemining - Allocation 3"
	levels = list(
		/datum/map_level/sector/roguemining_140/three,
	)

/datum/map_level/sector/roguemining_140/three
	id = "Roguemining3"
	name = "Roguemining - Allocation 3"
	absolute_path = "maps/sectors/roguemining_140/levels/roguemining_140_3.dmm"
	traits = list(
		ZTRAIT_LEGACY_BELTER_ACTIVE,
	)

/datum/map/sector/roguemining_140/four
	id = "roguemining_140_4"
	name = "Roguemining - Allocation 4"
	levels = list(
		/datum/map_level/sector/roguemining_140/four,
	)

/datum/map_level/sector/roguemining_140/four
	id = "Roguemining4"
	name = "Roguemining - Allocation 4"
	absolute_path = "maps/sectors/roguemining_140/levels/roguemining_140_4.dmm"
	traits = list(
		ZTRAIT_LEGACY_BELTER_ACTIVE,
	)
