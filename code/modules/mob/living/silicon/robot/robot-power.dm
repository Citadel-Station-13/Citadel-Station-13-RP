//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Uses a certain amount of reserve power - usually from the cell.
 *
 * * This bypasses any internal power limit / balancing logic and directly hits our
 *   backplane's power source.
 *
 * @return amount used
 */
/mob/living/silicon/robot/proc/draw_power(joules)
	return cell ? cell.use(DYNAMIC_J_TO_CELL_UNITS(joules)) : 0

/**
 * Uses a certain amount of reserve power - usually from the cell.
 *
 * * This bypasses any internal power limit / balancing logic and directly hits our
 *   backplane's power source.
 * * Reserve is in units, not joules.
 *
 * @return amount used
 */
/mob/living/silicon/robot/proc/draw_checked_power(joules, reserve_units)
	if(!cell)
		return 0
	var/units = DYNAMIC_J_TO_CELL_UNITS(joules)
	if(cell.charge - units < reserve_units)
		return 0
	return cell.use(units)

/mob/living/silicon/robot/proc/accepts_cell(obj/item/cell/cell, datum/event_args/actor/actor, silent)
	return cell.cell_type ? (cell.cell_type & cell_accept) : cell_accept_nonstandard
