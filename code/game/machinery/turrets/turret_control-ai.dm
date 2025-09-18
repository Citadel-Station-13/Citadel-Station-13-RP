//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/machinery/turretid/on_silicon_control_alt_click(mob/living/silicon/user, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	lethal = !lethal
	actor.chat_feedback(
		SPAN_WARNING("You set [src] to <b>[lethal ? "lethal" : "stun"]</b>."),
		target = src,
	)
	actor.data[ACTOR_DATA_SILICON_CONTROL_LOG] = "turret-control [COORD(src)] [REF(src)] lethal [lethal ? "on" : "off"]"
	updateTurrets()
	return TRUE

/obj/machinery/turretid/on_silicon_control_ctrl_click(mob/living/silicon/user, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	enabled = !enabled
	actor.chat_feedback(
		SPAN_WARNING("You turn [src] <font color='[enabled ? "green" : "red"]'><b>[enabled ? "on" : "off"]</b></font>."),
		target = src,
	)
	actor.data[ACTOR_DATA_SILICON_CONTROL_LOG] = "turret-control [COORD(src)] [REF(src)] power [enabled ? "on" : "off"]"
	updateTurrets()
	return TRUE
