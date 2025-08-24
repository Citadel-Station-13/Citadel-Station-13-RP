//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/machinery/turretid/on_silicon_control_alt_click(mob/living/silicon/user, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	#warn lethals
	return TRUE

/obj/machinery/turretid/on_silicon_control_ctrl_click(mob/living/silicon/user, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	#warn toggle
	return TRUE

/obj/machinery/turretid/on_silicon_control_ctrl_shift_click(mob/living/silicon/user, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return FALSE

/obj/machinery/turretid/on_silicon_control_middle_click(mob/living/silicon/user, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	return FALSE
