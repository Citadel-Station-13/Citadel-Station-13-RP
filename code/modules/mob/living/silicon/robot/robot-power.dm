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
	return cell ? cell.use(joules) : 0

/**
 * Uses a certain amount of reserve power - usually from the cell.
 *
 * * This bypasses any internal power limit / balancing logic and directly hits our
 *   backplane's power source.
 *
 * @return amount used
 */
/mob/living/silicon/robot/proc/draw_checked_power(joules, reserve)
	if(!cell)
		return 0
	if(cell.charge - joules < reserve)
		return 0
	return cell.use(joules)
