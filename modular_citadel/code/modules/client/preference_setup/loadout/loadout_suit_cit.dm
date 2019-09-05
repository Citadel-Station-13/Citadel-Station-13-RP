// Just colorable cloak for now.

/datum/gear/suit/roles/poncho/cloak/custom
	display_name = "cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/custom

/datum/gear/suit/roles/poncho/cloak/custom/New()
	..()
	gear_tweaks = list(GLOB.gear_tweak_free_color_choice)
