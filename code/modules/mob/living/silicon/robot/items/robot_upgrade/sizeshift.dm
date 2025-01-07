/obj/item/robot_upgrade/sizeshift
	name = "robot size alteration module"
	desc = "Using technology similar to one used in size guns, allows cyborgs to adjust their own size as necessary."
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"
	require_module = 1

/obj/item/robot_upgrade/sizeshift/action(var/mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(/mob/living/proc/set_size in R.verbs)
		return FALSE

	add_verb(R, /mob/living/proc/set_size)
	return TRUE
