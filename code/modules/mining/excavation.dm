//! excavation API


#warn impl

/**
 * checks what parts of the excavation framework in the mining module we support
 * returns flags, e.g. MINE_CAN_EXCAVATE
 */
/atom/proc/mine_functionality()
	return NONE

/atom/proc/mine_excavate(depth = EXCAVATION_DEPTH_DEFAULT, hardness = EXCAVATION_HARDNESS_DEFAULT, flags = NONE)

/atom/proc/mine_weaken(hardness = EXCAVATION_HARDNESS_DEFAULT, strength = EXCAVATION_WEAKEN_DEFAULT)

/atom/proc/mine_get_hardness()
	return EXCAVATION_HARDNESS_DEFAULT
