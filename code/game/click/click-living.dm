//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/click_interaction_chain(datum/event_args/actor/clickchain/clickchain, clickchain_flags, obj/item/active_item)
	if(!canClick())
		return clickchain_flags
	//! legacy-ish; is there a better way to do this?
	if(istype(loc, /obj/vehicle))
		var/obj/vehicle/in_vehicle = loc
		if(in_vehicle.is_driver(src))
			return in_vehicle.handle_vehicle_click(clickchain, clickchain_flags)
	//! end
	if(!IS_CONSCIOUS(src))
		// only warn if they're trying to click Something
		if(active_item || clickchain.target)
			clickchain.chat_feedback(
				SPAN_WARNING("You can't do that while unconscious."),
			)
		return clickchain_flags | CLICKCHAIN_DO_NOT_PROPAGATE
	if(!CHECK_MOBILITY(src, MOBILITY_CAN_USE))
		// only warn if they're trying to click Something
		if(active_item || clickchain.target)
			clickchain.chat_feedback(
				SPAN_WARNING("You can't do that right now."),
			)
		return clickchain_flags | CLICKCHAIN_DO_NOT_PROPAGATE
	. = ..()

#warn impl
