//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/ai_holder/dynamic
	/// how toxic we are towards teammates who 'accidentally' FF
	/// this is non-linear.
	/// 0 is 'we usually don't care'
	/// 1 is 'point blank them now'
	var/retaliate_friendly_fire_toxicity = 0

/datum/ai_holder/dynamic/imprint_personality(datum/ai_personality/personality)
	. = ..()
	retaliate_friendly_fire_toxicity = 0.5 ** (-personality.friendly_aggression / 200)

/datum/ai_holder/dynamic/proc/shot_retaliate(resultant_damage, angle, atom/attacker)

/datum/ai_holder/dynamic/proc/melee_retaliate(resultant_damage, turf/origin, atom/attacker)

/datum/ai_holder/dynamic/proc/shot_by_unseen(resultant_damage, angle, atom/attacker)

/datum/ai_holder/dynamic/proc/melee_by_unseen(resultant_damage, turf/origin, atom/attacker)

#warn uhhh
