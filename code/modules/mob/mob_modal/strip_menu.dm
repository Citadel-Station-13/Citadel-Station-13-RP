//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/mob_modal/strip_menu
	interface_key = "mob/StripMenuModal"

	/// target mob
	var/mob/target

/datum/mob_modal/strip_menu/New(mob/user, key, mob/target)
	src.target = target
	return ..()

#warn impl

/datum/mob_modal/strip_menu/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()

	var/list/assembled_slots = list()
	var/list/assembled_items = list()


	.["items"] = assembled_items
	.["slots"] = assembled_slots

/datum/mob_modal/strip_menu/ui_data(mob/user, datum/tgui/ui)
	. = ..()



/datum/mob_modal/strip_menu/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return

	switch(action)
		if("strip")
		if("dress")

#warn ui status/state




