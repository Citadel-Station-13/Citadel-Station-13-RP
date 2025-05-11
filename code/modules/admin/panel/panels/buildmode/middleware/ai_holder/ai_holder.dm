//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/buildmode_state/ai_holder

/datum/buildmode_middleware/ai_holder
	state_type = /datum/buildmode_state/ai_holder
	id = "ai_holder"
	ui_key = "ai_holder"
	#warn ui icon

/datum/buildmode_middleware/ai_holder/handle_click(client/user, datum/admins/holder, datum/buildmode_state/state, atom/click_target, list/click_params)
	. = ..()

/datum/buildmode_middleware/ai_holder/handle_topic(client/user, datum/admins/holder, datum/buildmode_state/state, action, list/params)
	. = ..()

#warn clickdrag? for simple 'move to' and 'attack target'

/datum/buildmode_middleware/ai_holder/proc/order_ai_move_to(datum/ai_holder/holder, turf/location, linger_duration = 30 SECONDS, stay_there_forever)

/datum/buildmode_middleware/ai_holder/proc/order_ai_attack(datum/ai_holder/holder, atom/target)
