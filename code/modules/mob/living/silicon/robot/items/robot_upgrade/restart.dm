/obj/item/robot_upgrade/restart
	name = "robot emergency restart module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	icon_state = "cyborg_upgrade1"
	item_state = "cyborg_upgrade"

/obj/item/robot_upgrade/restart/can_install(mob/living/silicon/robot/target, robot_opinion, datum/event_args/actor/actor, silent)
	. = ..()

/obj/item/robot_upgrade/restart/being_installed(mob/living/silicon/robot/target)
	. = ..()

/obj/item/robot_upgrade/restart/action(var/mob/living/silicon/robot/R)
	if(R.health < 0)
		to_chat(usr, "You have to repair the robot before using this module!")
		return FALSE

	if(!R.key)
		for(var/mob/observer/dead/ghost in GLOB.player_list)
			if(ghost.mind && ghost.mind.current == R)
				ghost.transfer_client_to(R)

	R.set_stat(CONSCIOUS)
	dead_mob_list -= R
	living_mob_list |= R
	R.notify_ai(ROBOT_NOTIFICATION_NEW_UNIT)
	return TRUE

#warn swap
