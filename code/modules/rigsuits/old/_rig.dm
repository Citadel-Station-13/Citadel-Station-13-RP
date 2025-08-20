/obj/item/hardsuit
	name = "hardsuit control module"
	icon = 'icons/obj/rig_modules.dmi'
	desc = "A back-mounted hardsuit deployment and control mechanism."
	slot_flags = SLOT_BACK
	w_class = WEIGHT_CLASS_HUGE
	rad_flags = NONE
	item_action_name = "Toggle Heatsink"

	// These values are passed on to all component pieces.
	armor_type = /datum/armor/hardsuit
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = SPACE_SUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.2
	permeability_coefficient = 0.1
	integrity_flags = INTEGRITY_ACIDPROOF
	preserve_item = 1

//Boot animation screen objects
/atom/movable/screen/rig_booting
	screen_loc = "CENTER-7,CENTER-7"
	icon = 'icons/obj/rig_boot.dmi'
	icon_state = ""
	layer = HUD_LAYER_UNDER
	plane = FULLSCREEN_PLANE
	mouse_opacity = 0
	alpha = 20 //Animated up when loading

//Shows cell charge on screen, ideally.

var/atom/movable/screen/cells = null

#undef ONLY_DEPLOY
#undef ONLY_RETRACT
#undef SEAL_DELAY
