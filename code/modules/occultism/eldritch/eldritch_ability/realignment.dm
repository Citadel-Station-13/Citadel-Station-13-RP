//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Rapidly realign your body, throwing off pain, stuns, and more.
 * Escalating cooldown as it's used more, but can be used in rapid succession after sufficient pause.
 */
/datum/prototype/eldritch_ability/patron/blade/realignment
	ability_type = /datum/ability/eldritch_ability/patron/blade/realignment
	name = "Realignment"
	desc = "Shake off pain and incapacitation to fight on."

/datum/ability/eldritch_ability/patron/blade/realignment
	name = "Realignment"
	desc = "Rapidly realign your senses, shaking off pain and incapacitation."
	#warn sprite

	/// default no cooldown
	cooldown = 0 SECONDS

	///


#warn impl


/datum/ability/eldritch_ability/patron/blade/realignment/proc/give_status_effect_to(mob/target)
	#warn impl
