//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/silicon/robot/proc/can_install_upgrade(obj/item/robot_upgrade/upgrade, force, datum/event_args/actor/actor, silent)

/mob/living/silicon/robot/proc/can_fit_upgrade(obj/item/robot_upgrade/upgrade, force, datum/event_args/actor/actor, silent)

/mob/living/silicon/robot/proc/user_install_upgrade(obj/item/robot_upgrade/upgrade, force, datum/event_args/actor/actor, silent)

	#warn this should be checked on attack chain

	if(actor)
		if(!force)
			if(!opened)
				actor.chat_feedback(
					SPAN_WARNING("[src] needs to have their cover opened for you to access their internals!"),
					target = src,
				)

	return install_upgrade(upgrade, force, actor, silent)

/mob/living/silicon/robot/proc/install_upgrade(obj/item/robot_upgrade/upgrade, force, datum/event_args/actor/actor, silent)


	upgrade.owner = src
	upgrade.on_install(src)


/mob/living/silicon/robot/proc/user_uninstall_upgrade(obj/item/robot_upgrade/upgrade, force, datum/event_args/actor/actor, silent)

/mob/living/silicon/robot/proc/uninstall_upgrade(obj/item/robot_upgrade/upgrade, force, datum/event_args/actor/actor, silent, atom/new_loc)

	upgrade.on_uninstall(src)
	upgrade.owner = null

#warn impl
