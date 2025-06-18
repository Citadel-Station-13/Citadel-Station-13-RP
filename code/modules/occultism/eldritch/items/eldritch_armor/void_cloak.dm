//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/action/item_action/eldritch_void_cloak_stealth
	name = "Toggle Occlusion"
	desc = "Toggle hiding your cloak from the common eye."
	#warn sprite

/**
 * void cloak: can be concealed.
 */
/obj/item/clothing/head/hood/eldritch_armor/void_cloak
	name = "cloak hood"
	desc = "A thick, protective hood."

/obj/item/clothing/head/hood/eldritch_armor/void_cloak/proc/set_occluded(state)

#warn run_examine
#warn examine; cold to the touch

/**
 * void cloak: can be concealed.
 */
/obj/item/clothing/suit/storage/hooded/eldritch_armor/void_cloak
	name = "heavy cloak"
	desc = "A heavy, protective cloak. Looking at it makes you feel uneasy, for some reason."
	hoodtype = /obj/item/clothing/head/hood/eldritch_armor

	var/occluded = TRUE

/obj/item/clothing/suit/storage/hooded/eldritch_armor/void_cloak/Initialize(mapload)
	. = ..()

#warn run_examine
#warn examine; cold to the touch

/obj/item/clothing/suit/storage/hooded/eldritch_armor/void_cloak/proc/set_occluded(state)

/obj/item/clothing/suit/storage/hooded/eldritch_armor/void_cloak/proc/toggle_stealth(datum/event_args/actor/actor)

#warn impl all

/obj/item/clothing/suit/storage/hooded/eldritch_armor/void_cloak/ui_action_click(datum/action/action, datum/event_args/actor/actor)
	if(istype(action, /datum/action/item_action/eldritch_void_cloak_stealth))
		toggle_stealth(actor)
	return ..()
