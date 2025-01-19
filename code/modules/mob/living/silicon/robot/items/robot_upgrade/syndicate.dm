/obj/item/robot_upgrade/syndicate
	name = "scrambled equipment module"
	desc = "Unlocks new and often deadly module specific items of a robot"
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"

/obj/item/robot_upgrade/syndicate/can_install(mob/living/silicon/robot/target, robot_opinion, datum/event_args/actor/actor, silent)
	. = ..()
	if(!.)
		return
	if(target.get_emag_item_state())
		if(!silent)
			actor?.chat_feedback(
				SPAN_WARNING("[target] already has scrambled equipment enabled."),
				target = src,
			)
		return FALSE

/obj/item/robot_upgrade/syndicate/being_installed(mob/living/silicon/robot/target)
	target.set_emag_item_state(TRUE)
	qdel(src)
