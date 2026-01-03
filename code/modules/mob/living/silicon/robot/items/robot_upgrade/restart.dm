/obj/item/robot_upgrade/restart
	name = "robot emergency restart module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	icon_state = "cyborg_upgrade1"
	item_state = "cyborg_upgrade"

/obj/item/robot_upgrade/restart/can_install(mob/living/silicon/robot/target, robot_opinion, datum/event_args/actor/actor, silent)
	if(target.health < 0)
		if(!silent)
			actor?.chat_feedback(
				SPAN_WARNING("You have to repair [target] before using an emergency restart module."),
				target = target,
			)
		return FALSE
	if(target.stat != DEAD)
		if(!silent)
			// ok this is a bit morbid but it's funny.
			actor?.chat_feedback(
				SPAN_WARNING("[target] is operational; only fully disabled cyborgs may be restarted."),
				target = target,
			)
		return FALSE
	return TRUE

/obj/item/robot_upgrade/restart/being_installed(mob/living/silicon/robot/target)
	// TODO: standardize revival.
	target.revive(TRUE, FALSE, FALSE)
	if(!target.ckey)
		for(var/mob/observer/dead/ghost in GLOB.player_list)
			if(ghost.mind?.current == target)
				ghost.transfer_client_to(target)
	target.notify_ai(ROBOT_NOTIFICATION_NEW_UNIT)
	qdel(src)
