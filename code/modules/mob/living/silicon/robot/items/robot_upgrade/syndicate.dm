/obj/item/robot_upgrade/syndicate
	name = "scrambled equipment module"
	desc = "Unlocks new and often deadly module specific items of a robot"
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/robot_upgrade/syndicate/action(var/mob/living/silicon/robot/R)
	if(..())
		return FALSE

	if(R.emag_items == 1)
		return FALSE

	R.emag_items = 1
	return TRUE
