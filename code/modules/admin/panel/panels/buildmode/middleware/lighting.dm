//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/buildmode_state/lighting
	var/

/datum/buildmode_middleware/lighting
	state_type = /datum/buildmode_state/lighting

	var/const/light_mode_invis = "invis"
	var/const/light_mode_real = "real"

/datum/buildmode_middleware/lighting/handle_click(client/user, datum/admins/holder, datum/buildmode_state/state, atom/click_target, list/click_params)
	. = ..()

/datum/buildmode_middleware/lighting/handle_topic(client/user, datum/admins/holder, datum/buildmode_state/state, action, list/params)
	. = ..()

