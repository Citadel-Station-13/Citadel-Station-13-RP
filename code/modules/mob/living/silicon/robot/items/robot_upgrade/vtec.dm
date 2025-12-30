/**
 * this item is slated for removal as borgs get more upgrades
 *
 * full speed increase upgrades are bad design, sorry.
 */
/obj/item/robot_upgrade/vtec
	name = "robotic VTEC Module"
	desc = "Used to kick in a robot's VTEC systems, increasing their speed."
	icon_state = "cyborg_upgrade2"
	item_state = "cyborg_upgrade"

	var/current_power_level = 0
	var/current_tps_boost = 1

	var/list/possible_tps_boosts = list(
		1,
		1.75,
		2.5,
	)

	upgrade_actions = list(
		/datum/action/robot_upgrade_action/vtec,
	)

/obj/item/robot_upgrade/vtec/proc/set_power_level(level)
	src.current_power_level = clamp(level, 0, length(possible_tps_boosts))
	src.current_tps_boost = length(possible_tps_boosts) ? possible_tps_boosts[src.current_power_level] : 0
	update_movespeed_modifier()

/obj/item/robot_upgrade/vtec/on_install(mob/living/silicon/robot/target)
	..()
	set_power_level(current_power_level)

/obj/item/robot_upgrade/vtec/on_uninstall(mob/living/silicon/robot/target)
	..()
	remove_movespeed_modifier()

/obj/item/robot_upgrade/vtec/proc/user_toggle_tps_boost(datum/event_args/actor/actor)
	set_power_level(current_power_level >= length(possible_tps_boosts) ? 0 : current_power_level + 1)
	for(var/datum/action/action in upgrade_actions)
		action.update_buttons()

/obj/item/robot_upgrade/vtec/proc/update_movespeed_modifier()
	owner.update_movespeed_modifier(/datum/movespeed_modifier/mob_vtec_upgrade, TRUE, list(
		MOVESPEED_PARAM_MOD_TILES_PER_SECOND = current_tps_boost,
	))

/obj/item/robot_upgrade/vtec/proc/remove_movespeed_modifier()
	owner.remove_movespeed_modifier(/datum/movespeed_modifier/mob_vtec_upgrade)

/datum/action/robot_upgrade_action/vtec
	button_icon = 'icons/screen/actions/generic.dmi'
	button_icon_state = "chevron-1"

	var/vtec_chevron_icon_state_base = "chevron-"
	var/vtec_chevron_icon_states = 3

/datum/action/robot_upgrade_action/vtec/pre_render_hook()
	. = ..()
	var/obj/item/robot_upgrade/vtec/casted_target = target
	button_icon_state = "[vtec_chevron_icon_state_base]\
	[ceil((casted_target.current_power_level / length(casted_target.possible_tps_boosts)) * vtec_chevron_icon_states)]"

/datum/action/robot_upgrade_action/vtec/invoke_target(obj/item/robot_upgrade/vtec/target, datum/event_args/actor/actor)
	target.user_toggle_tps_boost(actor)
	return ..()
