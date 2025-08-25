//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/machinery/door/airlock/on_silicon_control_shift_click(mob/living/silicon/user, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	#warn open
	return TRUE

/obj/machinery/door/airlock/on_silicon_control_alt_click(mob/living/silicon/user, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	#warn electrify
	return TRUE

/obj/machinery/door/airlock/on_silicon_control_ctrl_click(mob/living/silicon/user, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	#warn bolt
	return TRUE

/obj/machinery/door/airlock/on_silicon_control_ctrl_shift_click(mob/living/silicon/user, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	// TODO: emergency access
	return FALSE

/obj/machinery/door/airlock/on_silicon_control_middle_click(mob/living/silicon/user, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	// TODO: flash the lights or something else?
	return FALSE
