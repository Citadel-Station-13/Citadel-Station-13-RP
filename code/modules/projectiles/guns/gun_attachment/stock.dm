//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/obj/item/gun_attachment/stock
	abstract_type = /obj/item/gun_attachment/stock
	icon = 'icons/modules/projectiles/attachments/stock.dmi'
	attachment_type = GUN_ATTACHMENT_TYPE_STOCK
	attachment_slot = GUN_ATTACHMENT_SLOT_STOCK

	/**
	 * Increase the gun's weight class while enabled to..
	 */
	var/increase_gun_weight_class_to = WEIGHT_CLASS_BULKY

	/**
	 * Tracks if we're applied so we can never do our stuff twice.
	 */
	var/applied = FALSE

/obj/item/gun_attachment/stock/on_attach(obj/item/gun/gun)
	apply_stats_on_attach(gun)
	..()

/obj/item/gun_attachment/stock/on_detach(obj/item/gun/gun)
	remove_stats(gun)
	..()

/obj/item/gun_attachment/stock/proc/apply_stats_on_attach(obj/item/gun/gun)
	apply_stats(gun)

/obj/item/gun_attachment/stock/proc/apply_stats(obj/item/gun/gun)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(applied)
		return
	do_apply_stats(gun)

/obj/item/gun_attachment/stock/proc/do_apply_stats(obj/item/gun/gun)
	gun.set_weight_class(max(increase_gun_weight_class_to, gun.w_class))

/obj/item/gun_attachment/stock/proc/remove_stats(obj/item/gun/gun)
	SHOULD_NOT_OVERRIDE(TRUE)

	if(!applied)
		return
	do_remove_stats(gun)

/obj/item/gun_attachment/stock/proc/do_remove_stats(obj/item/gun/gun)
	gun.set_weight_class(initial(gun.w_class))

/**
 * A stock that can be toggled.
 */
/obj/item/gun_attachment/stock/collapsible
	name = "collapsible stock"
	desc = "A collapsible stock."
	attachment_action_name = "Toggle Stock"

	var/extended = FALSE
	/**
	 * Changes our icon_state to [base_icon_state][extended_state_append] when extended.
	 * * This will update our gun overlay. Gun overlay is '[icon_state]-gun'.
	 */
	var/extended_state_append = "-ext"

	var/extend_sfx = /datum/soundbyte/guns/ballistic/load_casing/shotgun
	var/extend_sfx_volume = 75
	var/extend_sfx_vary = TRUE

	/**
	 * * Defaults to [extend_sfx].
	 */
	var/collapse_sfx
	/**
	 * * Defaults to [extend_sfx_volume].
	 */
	var/collapse_sfx_volume
	/**
	 * * Defaults to [extend_sfx_vary].
	 */
	var/collapse_sfx_vary

	COOLDOWN_DECLARE(toggle)

/obj/item/gun_attachment/stock/collapsible/apply_stats_on_attach(obj/item/gun/gun)
	if(!extended)
		return
	..()

/obj/item/gun_attachment/stock/collapsible/update_icon_state()
	icon_state = "[base_icon_state][extended ? extended_state_append : ""]"
	return ..()

/obj/item/gun_attachment/stock/collapsible/ui_action_click(datum/action/action, datum/event_args/actor/actor)
	user_set_extended(!extended, actor)

/obj/item/gun_attachment/stock/collapsible/proc/user_set_extended(state, datum/event_args/actor/actor, silent, suppressed)
	if(!COOLDOWN_FINISHED(src, toggle))
		// throttle
		return

	set_extended(state, actor, silent, suppressed)

/**
 * @params
 * * state - the state to set; true for extended, false for collapsed
 * * user - the one performing the action; used for messages and such
 * * silent - no visible message
 * * suppressed - no extend/collapse sound
 */
/obj/item/gun_attachment/stock/collapsible/proc/set_extended(state, datum/event_args/actor/actor, silent, suppressed)
	if(extended == state)
		return
	extended = state
	update_icon()

	if(attached)
		if(extended)
			apply_stats(attached)
		else
			remove_stats(attached)

	if(!actor)
		// no toggle, no cooldown
		return

	COOLDOWN_START(src, toggle, 1 SECONDS)

	if(!silent)
		actor.visible_feedback(
			attached || src, // fallback to src if not on a gun
			range = MESSAGE_RANGE_INVENTORY_SOFT,
			visible = SPAN_WARNING("[actor.performer] [extended ? "extend" : "collapse"]s [attached ? "\the [src] on [attached]" : "\the [src]"]."),
			audible = SPAN_NOTICE("You hear something telescoping."),
			self = SPAN_NOTICE("You <b>[extended ? "extend" : "collapse"]</b> [attached ? "\the [src] on [attached]" : "\the [src]"]."),
		)
	else
		to_chat(user, SPAN_NOTICE("You <b>[extended ? "extend" : "collapse"]</b> [attached ? "\the [src] on [attached]" : "\the [src]"]."))

	if(!suppressed)
		if(extended)
			if(extend_sfx)
				playsound(extend_sfx, extend_sfx_volume, extend_sfx_vary)
		else
			if(collapse_sfx || extend_sfx)
				playsound(
					collapse_sfx || extend_sfx,
					collapse_sfx_volume || extend_sfx_volume,
					collapse_sfx_vary || extend_sfx_vary,
				)

/obj/item/gun_attachment/stock/collapsible/integrated
	name = /obj/item/gun_attachment/stock/collapsible::name + " (integrated)"
	desc = /obj/item/gun_attachment/stock/collapsible::desc + " This one is integrated with the gun, and cannot be removed."
	can_detach = FALSE

