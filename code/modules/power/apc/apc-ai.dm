//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/machinery/power/apc/on_silicon_control_ctrl_click(mob/living/silicon/user, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	toggle_breaker()
	actor.data[ACTOR_DATA_SILICON_CONTROL_LOG] = "apc [COORD(src)] [REF(src)] breaker [operating ? "on" : "off"]"
	actor.chat_feedback(
		SPAN_WARNING("You toggle [src]'s breaker <b>[operating ? "on" : "off"]</b>"),
		target = src,
	)
	return TRUE
