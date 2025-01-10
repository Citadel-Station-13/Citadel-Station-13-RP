// robot_upgrades.dm
// Contains various borg upgrades.

/obj/item/robot_upgrade
	name = "borg upgrade module."
	desc = "Protected by FRM."
	icon = 'icons/obj/module.dmi'
	icon_state = "cyborg_upgrade"
	///	Bitflags listing module compatibility. Used in the exosuit fabricator for creating sub-categories.
	var/list/module_flags = NONE
	var/locked = FALSE
	var/require_module = FALSE
	var/installed = FALSE

/obj/item/robot_upgrade/proc/action(var/mob/living/silicon/robot/R)
	if(R.stat == DEAD)
		to_chat(usr, SPAN_WARNING("The [src] will not function on a deceased robot."))
		return TRUE
	return FALSE
