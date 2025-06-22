//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/mob_modal
	/// key
	var/key
	/// our user
	var/mob/user
	/// interface ui key
	var/interface_key

/datum/mob_modal/New(mob/user, key)
	src.key = key
	src.user = user

	ui_interact(user)

/datum/mob_modal/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, interface_key)
		ui.open()

#warn impl
#warn ui status/state
