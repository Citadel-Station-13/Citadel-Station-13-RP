//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/combo_set/melee/intent_based/kinetic_gauntlets
	expected_combo_type = /datum/combo/melee/kinetic_gauntlets
	combos = list(
		/datum/combo/melee/intent_based/kinetic_gauntlets/slam,
		/datum/combo/melee/intent_based/kinetic_gauntlets/concuss,
		/datum/combo/melee/intent_based/kinetic_gauntlets/detonate,
	)

/datum/combo/melee/intent_based/kinetic_gauntlets
	abstract_type = /datum/combo/melee/intent_based/kinetic_gauntlets

/datum/combo/melee/intent_based/kinetic_gauntlets/slam
	name = "slam"
	desc = "Slam a target away."
	keys = list(
		INTENT_DISARM,
		INTENT_DISARM,
	)

/datum/combo/melee/intent_based/kinetic_gauntlets/concuss
	name = "concuss"
	desc = "Disrupt a target, making it harder for them to move and react."
	keys = list(
		INTENT_DISARM,
		INTENT_HARM,
	)

/datum/combo/melee/intent_based/kinetic_gauntlets/detonate
	name = "detonate"
	desc = "Detonate a kinetic mark on a target with full intensity, in lieu of any special effects."
	keys = list(
		INTENT_HARM,
		INTENT_HARM,
	)

#warn melee injection hooks
