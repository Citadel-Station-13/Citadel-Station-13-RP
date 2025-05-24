//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/carbon/human/melee_attack_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	// todo: shouldn't be here, standardize sparring / attack accuracy and missing
	if(clickchain.target_zone != BP_TORSO && prob(15))
		clickchain_flags |= CLICKCHAIN_ATTACK_MISSED
	return ..()

/mob/living/carbon/human/default_unarmed_attack_style()
	return get_unarmed_attack() || ..()
