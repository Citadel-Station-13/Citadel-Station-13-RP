//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/machinery/light/on_silicon_control_alt_click(mob/living/silicon/user, datum/event_args/actor/actor, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	flicker(1)
	actor.data[ACTOR_DATA_SILICON_CONTROL_LOG] = "light [COORD(src)] [src] flickered"
	actor.chat_feedback(
		SPAN_NOTICE("You flicker the light."),
		target = src,
	)
	return TRUE
