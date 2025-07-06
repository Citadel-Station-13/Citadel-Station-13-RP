//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/mob/living/silicon/robot/proc/install_upgrade(obj/item/robot_upgrade/upgrade, force, datum/event_args/actor/actor, silent)
	if(actor)
		if(!force)
			if(!opened)
				actor.chat_feedback(
					SPAN_WARNING("[src] needs to have their cover opened for you to access their internals!"),
					target = src,
				)

	// else if(istype(W, /obj/item/robot_upgrade/))
	// 	if(U.action(src))
	// 		user.transfer_item_to_loc(U, src, INV_OP_FORCE)
	// 		to_chat(usr, "You apply the upgrade to [src]!")
	// 	else
	// 		to_chat(usr, "Upgrade error!")

	upgrade.owner = src
	upgrade.on_install(src)


/mob/living/silicon/robot/proc/uninstall_upgrade(obj/item/robot_upgrade/upgrade, force, datum/event_args/actor/actor, silent, atom/new_loc)

	upgrade.on_uninstall(src)
	upgrade.owner = null

#warn impl
