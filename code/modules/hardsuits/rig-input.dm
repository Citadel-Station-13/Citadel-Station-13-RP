//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Routed proc from either wearer or remote click.
 * @return clickchain flags
 */
/obj/item/hardsuit/proc/handle_hardsuit_module_click(datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/hardsuit_module/using_module)
	if(!using_module)
		using_module = selected_module
	if(!using_module)
		clickchain.chat_feedback(
			SPAN_WARNING("None of your hardsuit's modules are currently the active module."),
			target = src,
		)
		return NONE

	if(clickchain.performer != wearer)
		if(!ai_can_move_suit(clickchain.performer, check_user_module = TRUE))
			clickchain.chat_feedback(
				SPAN_WARNING("The hardsuit rejects your input."),
				target = src,
			)
			return NONE

	//! legacy
	clickchain.data[ACTOR_DATA_RIG_CLICK_LOG] = "[src]: [selected_module]"
	selected_module.engage(clickchain.target)
	clickchain.performer.setClickCooldownLegacy(wearer?.get_attack_speed_legacy() || 0.8 SECONDS)
	//! end
	return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
