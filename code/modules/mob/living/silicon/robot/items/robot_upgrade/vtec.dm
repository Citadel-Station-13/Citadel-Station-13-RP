/obj/item/robot_upgrade/vtec
	name = "robotic VTEC Module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"

/obj/item/robot_upgrade/vtec/ui_action_click(datum/action/action, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

/obj/item/robot_upgrade/vtec/proc/update_movespeed_modifier()
	owner.add_or_update_variable_movespeed_modifier(/datum/movespeed_modifier/mob_vtec_upgrade, TRUE, list(
	))


/obj/item/robot_upgrade/vtec/proc/remove_movespeed_modifier()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/mob_vtec_upgrade)

#warn movespeed modifier and button stuff
