// robot_upgrades.dm
// Contains various borg upgrades.

/obj/item/borg/upgrade
	name = "borg upgrade module."
	desc = "Protected by FRM."
	icon = 'icons/obj/module.dmi'
	icon_state = "cyborg_upgrade"
	///	Bitflags listing module compatibility. Used in the exosuit fabricator for creating sub-categories.
	var/list/module_flags = NONE
	var/locked = FALSE
	var/require_module = FALSE
	var/installed = FALSE

/obj/item/borg/upgrade/proc/action(var/mob/living/silicon/robot/R)
	if(R.stat == DEAD)
		to_chat(usr, SPAN_WARNING("The [src] will not function on a deceased robot."))
		return TRUE
	return FALSE


/obj/item/borg/upgrade/reset
	name = "robotic module reset board"
	desc = "Used to reset a cyborg's module. Destroys any other upgrades applied to the robot."
	icon_state = "cyborg_upgrade1"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/borg/upgrade/reset/action(var/mob/living/silicon/robot/R)
	if(..())
		return FALSE
	R.module_reset()
	return TRUE

/obj/item/borg/upgrade/rename
	name = "robot reclassification board"
	desc = "Used to rename a cyborg."
	icon_state = "cyborg_upgrade1"
	item_state = "cyborg_upgrade"
	var/heldname = "default name"

/obj/item/borg/upgrade/rename/attack_self(mob/user as mob)
	heldname = sanitizeSafe(input(user, "Enter new robot name", "Robot Reclassification", heldname), MAX_NAME_LEN)

/obj/item/borg/upgrade/rename/action(var/mob/living/silicon/robot/R)
	if(..())
		return FALSE
	R.notify_ai(ROBOT_NOTIFICATION_NEW_NAME, R.name, heldname)
	R.name = heldname
	R.custom_name = heldname
	R.real_name = heldname

	return TRUE

/obj/item/borg/upgrade/restart
	name = "robot emergency restart module"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	icon_state = "cyborg_upgrade1"
	item_state = "cyborg_upgrade"


/obj/item/borg/upgrade/restart/action(var/mob/living/silicon/robot/R)
	if(R.health < 0)
		to_chat(usr, "You have to repair the robot before using this module!")
		return FALSE

	if(!R.key)
		for(var/mob/observer/dead/ghost in GLOB.player_list)
			if(ghost.mind && ghost.mind.current == R)
				R.key = ghost.key

	R.set_stat(CONSCIOUS)
	dead_mob_list -= R
	living_mob_list |= R
	R.notify_ai(ROBOT_NOTIFICATION_NEW_UNIT)
	return TRUE


/obj/item/borg/upgrade/vtec
	name = "robotic VTEC Module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/borg/upgrade/vtec/action(var/mob/living/silicon/robot/R)
	if(..())
		return FALSE

	if(R.speed == -1)
		return FALSE

	R.speed--
	return TRUE


/obj/item/borg/upgrade/tasercooler
	name = "robotic Rapid Taser Cooling Module"
	desc = "Used to cool a mounted taser, increasing the potential current in it and thus its recharge rate."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	module_flags = BORG_MODULE_SECURITY
	require_module = TRUE


/obj/item/borg/upgrade/tasercooler/action(var/mob/living/silicon/robot/R)
	if(..())
		return FALSE

	if(!R.module || !(type in R.module.supported_upgrades))
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return FALSE

	var/obj/item/gun/energy/taser/mounted/cyborg/T = locate() in R.module
	if(!T)
		T = locate() in R.module.contents
	if(!T)
		T = locate() in R.module.modules
	if(!T)
		to_chat(usr, SPAN_WARNING("This robot has had its taser removed!"))
		return FALSE

	if(T.recharge_time <= 2)
		to_chat(R, "Maximum cooling achieved for this hardpoint!")
		to_chat(usr, "There's no room for another cooling unit!")
		return FALSE

	else
		T.recharge_time = max(2 , T.recharge_time - 4)

	return TRUE

/obj/item/borg/upgrade/jetpack
	name = "robot jetpack"
	desc = "A carbon dioxide jetpack suitable for low-gravity operations."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/borg/upgrade/jetpack/action(var/mob/living/silicon/robot/R)
	if(..())
		return FALSE

	var/obj/item/tank/jetpack/carbondioxide/T = locate() in R.module
	if(!T)
		T = locate() in R.module.contents
	if(!T)
		T = locate() in R.module.modules
	if(!T)
		R.module.modules += new/obj/item/tank/jetpack/carbondioxide(R.module)
		for(var/obj/item/tank/jetpack/carbondioxide in R.module.modules)
			R.internals = src
		return TRUE
	if(T)
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return FALSE

/obj/item/borg/upgrade/advhealth
	name = "advanced health analyzer module"
	desc = "A carbon dioxide jetpack suitable for low-gravity operations."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/borg/upgrade/advhealth/action(var/mob/living/silicon/robot/R)
	if(..())
		return FALSE

	var/obj/item/healthanalyzer/advanced/T = locate() in R.module
	if(!T)
		T = locate() in R.module.contents
	if(!T)
		T = locate() in R.module.modules
	if(!T)
		R.module.modules += new/obj/item/healthanalyzer/advanced(R.module)
		return TRUE
	if(T)
		to_chat(R, "Upgrade mounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no mounting point for the module!")
		return FALSE

/obj/item/borg/upgrade/syndicate
	name = "scrambled equipment module"
	desc = "Unlocks new and often deadly module specific items of a robot"
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"
	require_module = TRUE

/obj/item/borg/upgrade/syndicate/action(var/mob/living/silicon/robot/R)
	if(..())
		return FALSE

	if(R.emag_items == 1)
		return FALSE

	R.emag_items = 1
	return TRUE

/obj/item/borg/upgrade/language
	name = "adaptive translation module"
	desc = "Upgrades a cyborg's language processing unit with an adaptive translation module."
	icon_state = "cyborg_upgrade3"
	item_state = "cyborg_upgrade"

/obj/item/borg/upgrade/language/action(var/mob/living/silicon/robot/R)
	if(..())
		return FALSE

	R.create_translation_context(/datum/translation_context/variable/learning/silicons)

	return TRUE

//Robot resizing module, moved from robot/upgrades_vr - Papalus
/obj/item/borg/upgrade/sizeshift
	name = "robot size alteration module"
	desc = "Using technology similar to one used in sizeguns, allows cyborgs to adjust their own size as neccesary."
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"
	require_module = 1

/obj/item/borg/upgrade/sizeshift/action(var/mob/living/silicon/robot/R)
	if(..()) return FALSE

	if(/mob/living/proc/set_size in R.verbs)
		return FALSE

	add_verb(R, /mob/living/proc/set_size)
	return TRUE
