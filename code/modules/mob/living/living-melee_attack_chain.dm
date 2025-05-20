//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/melee_attack_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	// todo: shouldn't be here, standardize sparring / attack accuracy and missing
	if(prob(80))
		clickchain.target_zone = ran_zone(clickchain.target_zone, 70)
	return ..()

/mob/living/default_unarmed_attack_style()
	return fetch_unarmed_style(/datum/melee_attack/unarmed)
