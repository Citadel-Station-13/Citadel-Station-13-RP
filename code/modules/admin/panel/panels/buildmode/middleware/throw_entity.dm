//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/buildmode_state/throw_entity
	#warn single / multi ?

/datum/buildmode_middleware/throw_entity
	state_type = /datum/buildmode_state/throw_entity
	id = "throw_entity"
	ui_key = "throw_entity"
	#warn ui icon

/datum/buildmode_middleware/throw_entity/handle_click(client/user, datum/admins/holder, datum/buildmode_state/state, atom/click_target, list/click_params)
	. = ..()

#warn clickdrag support?

/datum/buildmode_middleware/throw_entity/handle_topic(client/user, datum/admins/holder, datum/buildmode_state/state, action, list/params)
	. = ..()
