/obj/item/robot_upgrade/rename
	name = "robot reclassification board"
	desc = "Used to rename a cyborg."
	icon_state = "cyborg_upgrade1"
	item_state = "cyborg_upgrade"
	var/heldname = "default name"

/obj/item/robot_upgrade/rename/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	heldname = sanitizeSafe(input(user, "Enter new robot name", "Robot Reclassification", heldname), MAX_NAME_LEN)

// TODO: refactor cyborg namepicking
/obj/item/robot_upgrade/rename/being_installed(mob/living/silicon/robot/target)
	var/mob/living/silicon/robot/R = target
	R.notify_ai(ROBOT_NOTIFICATION_NEW_NAME, R.name, heldname)
	R.name = heldname
	R.custom_name = heldname
	R.real_name = heldname
	qdel(src)
