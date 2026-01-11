//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Handles a click; this is a routed proc from either wearer or remote click.
 * * This is only for module usage, as its name implies. This is very important; when rig remote control
 *   is added, you are controlling a human, and clicking normally to interact with say, your hands,
 *   is not routed here.
 * @params
 * * clickchain
 * * clickchain_flags
 * * using_module - if set, route to a specific module. otherwise, route to active.
 *
 * @return clickchain flags
 */
/obj/item/rig/proc/handle_rig_module_click(datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/rig_module/using_module)
	if(!using_module)
		using_module = get_active_rig_module_click()
	if(!using_module)
		clickchain.chat_feedback(
			SPAN_WARNING("None of your hardsuit's modules are currently the active module."),
			target = src,
		)
		return clickchain_flags

	#warn impl
	// if(clickchain.performer != wearer)
	// 	if(!ai_can_move_suit(clickchain.performer, check_user_module = TRUE))
	// 		clickchain.chat_feedback(
	// 			SPAN_WARNING("The hardsuit rejects your input."),
	// 			target = src,
	// 		)
	// 		return NONE

	// //! legacy
	// clickchain.data[ACTOR_DATA_RIG_CLICK_LOG] = "[src]: [selected_module]"
	// selected_module.engage(clickchain.target)
	// clickchain.performer.setClickCooldownLegacy(wearer?.get_attack_speed_legacy() || 0.8 SECONDS)
	// //! end
	// return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING

/obj/item/rig/proc/set_active_rig_module_click(obj/item/rig_module/module)

/obj/item/rig/proc/get_active_rig_module_click()
	return rig_module_click_active
