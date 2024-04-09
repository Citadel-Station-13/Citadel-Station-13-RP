//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/ai_holder/dynamic

/**
 * is another entity in our faction?
 * this is not casted to ai_holder because players and un-controlled entities
 * do not have ai holders.
 *
 * @return AI_DYNAMIC_FACTION_CHECK_X - only GOOD, UNKNOWN, ENEMY values.
 */
/datum/ai_holder/dynamic/proc/is_in_faction(atom/movable/entity)
	#warn impl
	return AI_DYNAMIC_FACTION_CHECK_UNKNOWN

/**
 * is another entity in our faction and in good standing?
 * this is not casted to ai_holder because players and un-controlled entities
 * do not have ai holders.
 *
 * this is for automatic retaliation if someone is unnaturally good at
 * friendly firing us (aka someone's trying to teamkill)
 *
 * todo; impl
 */
/datum/ai_holder/dynamic/proc/check_faction_standing(atom/movable/entity)
	var/are_they_in_faction = is_in_faction(entity)
	return are_they_in_faction
