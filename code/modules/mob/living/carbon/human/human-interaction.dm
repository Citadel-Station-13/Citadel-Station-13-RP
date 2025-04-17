//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/carbon/human/clickchain_help_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(iscarbon(clickchain.performer))
		if(attempt_cpr_interaction(clickchain.performer))
			return . | CLICKCHAIN_DID_SOMETHING
	if(isliving(clickchain.performer))
		if(apply_pressure(clickchain.performer, clickchain.target_zone))
			return . | CLICKCHAIN_DID_SOMETHING
	if(iscarbon(clickchain.performer))
		var/help_shake_act_shieldcall_results = atom_shieldcall_handle_touch(
			clickchain,
			clickchain_flags,
			SHIELDCALL_CONTACT_FLAG_HARMFUL,
			SHIELDCALL_CONTACT_SPECIFIC_SHAKE_UP,
		)
		if(help_shake_act_shieldcall_results & SHIELDCALL_FLAGS_BLOCK_ATTACK)
			clickchain.performer.do_attack_animation(src)
			return . | CLICKCHAIN_DID_SOMETHING
		help_shake_act(clickchain.performer)
		return . | CLICKCHAIN_DID_SOMETHING

/mob/living/carbon/human/clickchain_disarm_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return

/mob/living/carbon/human/clickchain_grab_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return

/mob/living/carbon/human/clickchain_harm_interaction(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
