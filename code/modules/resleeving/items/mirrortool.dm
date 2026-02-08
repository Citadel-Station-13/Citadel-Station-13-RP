/obj/item/mirrortool
	name = "mirror tool"
	desc = "A tool for the installation and removal of Mirrors. The tool has a set of barbs for removing Mirrors from a body, and a slot for depositing it directly into a resleeving console."
	icon = 'icons/obj/mirror.dmi'
	icon_state = "mirrortool"
	base_icon_state = "mirrortool"
	item_state = "healthanalyzer"
	slot_flags = SLOT_BELT
	throw_force = 3
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 5
	throw_range = 10
	materials_base = list(MAT_STEEL = 200)
	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	item_flags = ITEM_NO_BLUDGEON | ITEM_ENCUMBERS_WHILE_HELD

	var/obj/item/organ/internal/mirror/inserted_mirror

/obj/item/mirrortool/Destroy()
	QDEL_NULL(inserted_mirror)
	return ..()

/obj/item/mirrortool/drop_products(method, atom/where)
	. = ..()
	inserted_mirror?.forceMove(where)

/obj/item/mirrortool/Exited(atom/movable/AM, atom/newLoc)
	..()
	if(AM == inserted_mirror)
		inserted_mirror = null
		ui_update_mirror()

/obj/item/mirrortool/update_icon_state()
	icon_state = inserted_mirror ? "mirrortool_loaded" : "mirrortool"
	return ..()

/obj/item/mirrortool/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(istype(using, /obj/item/organ/internal/mirror))
		if(inserted_mirror)
			clickchain.chat_feedback(
				SPAN_WARNING("[src] already has a mirror inside it."),
				target = src,
			)
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		var/obj/item/organ/internal/mirror/mirror = using
		if(!clickchain.performer.attempt_insert_item_for_installation(mirror, src))
			return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
		clickchain.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_INVENTORY_SOFT,
			visible = SPAN_NOTICE("[clickchain.performer] inserts [mirror] into [src]."),
		)
		if(!user_insert_mirror(mirror, clickchain))
			clickchain.performer.put_in_hands_or_drop(mirror)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

/obj/item/mirrortool/using_as_item(atom/target, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(istype(target, /obj/item/organ/internal/mirror))
		var/obj/item/organ/internal/mirror/mirror = target
		if(inserted_mirror)
			clickchain.chat_feedback(
				SPAN_WARNING("[src] already has an inserted mirror."),
				target = src,
			)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(mirror.inv_inside)
			if(!mirror.inv_inside.owner.transfer_item_to_loc(mirror, src))
				clickchain.chat_feedback(
					SPAN_WARNING("[src] is stuck to [mirror.inv_inside.owner == clickchain.performer ? "your" : "[mirror.inv_inside.owner]'s"] hands."),
					target = src,
				)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		else
			mirror.forceMove(src)
		if(!user_insert_mirror(mirror, clickchain))
			mirror.forceMove(drop_location())
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	else if(ismob(target))
		var/mob/casted_mob = target
		if(casted_mob.resleeving_supports_mirrors())
			clickchain.visible_feedback(
				target = target,
				range = MESSAGE_RANGE_COMBAT_LOUD,
				visible = SPAN_WARNING("[clickchain.performer] aligns [src] with [target]'s spine..."),
			)
			if(!do_after(clickchain.performer, 3 SECONDS, target))
				return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
			if(!inserted_mirror)
				user_yank_mirror_from_mob(target, clickchain)
				return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
			else
				user_inject_mirror_into_mob(target, clickchain)
				return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
		else
			clickchain.visible_feedback(
				target = target,
				range = MESSAGE_RANGE_ITEM_HARD,
				visible = SPAN_WARNING("[clickchain.performer] briefly points [src] at [target]'s spine."),
				otherwise_self = SPAN_WARNING("[src] makes a beep as you pass it over [target]'s spine. They are not compatible with mirrors."),
			)
			return CLICKCHAIN_DO_NOT_PROPAGATE

/obj/item/mirrortool/on_attack_hand(datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(clickchain.initiator.is_holding_inactive(src))
		user_remove_mirror(clickchain)
		return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

/obj/item/mirrortool/proc/user_yank_mirror_from_mob(mob/target, datum/event_args/actor/actor, silent) as /obj/item/organ/internal/mirror
	if(inserted_mirror)
		actor.visible_feedback(
			target = target,
			range = MESSAGE_RANGE_COMBAT_LOUD,
			otherwise_self = SPAN_WARNING("[src] already has a mirror in it."),
			visible = SPAN_WARNING("[src] makes a beep and disengages."),
		)
		return FALSE
	if(!target.resleeving_get_mirror())
		actor.visible_feedback(
			target = target,
			range = MESSAGE_RANGE_COMBAT_LOUD,
			otherwise_self = SPAN_WARNING("[target] doesn't have a mirror."),
			visible = SPAN_WARNING("[src] makes a beep and disengages."),
		)
		return FALSE
	actor.visible_feedback(
		target = target,
		range = MESSAGE_RANGE_COMBAT_LOUD,
		visible = SPAN_WARNING("[actor.performer] starts extracting [target]'s mirror with [src]!"),
	)
	if(!do_after(actor.performer, IS_DEAD(target) ? 2.5 SECONDS : 7.5 SECONDS, target))
		return FALSE
	if(inserted_mirror)
		return FALSE
	var/obj/item/organ/internal/mirror/removed = target.resleeving_remove_mirror()
	if(!removed)
		return FALSE
	log_game("[actor.actor_log_string()] removed [key_name(target)]'s mirror with [src].")
	if(!insert_mirror(removed, actor))
		return FALSE
	actor.visible_feedback(
		target = target,
		range = MESSAGE_RANGE_COMBAT_LOUD,
		visible = SPAN_WARNING("[actor.performer] extracts [target]'s mirror with [src]!"),
	)
	return TRUE

/obj/item/mirrortool/proc/user_inject_mirror_into_mob(mob/target, datum/event_args/actor/actor, silent)
	if(!inserted_mirror)
		actor.visible_feedback(
			target = target,
			range = MESSAGE_RANGE_COMBAT_LOUD,
			otherwise_self = SPAN_WARNING("[src] doesn't have a mirror in it."),
			visible = SPAN_WARNING("[src] makes a beep and disengages."),
		)
		return FALSE
	if(target.resleeving_get_mirror())
		actor.visible_feedback(
			target = target,
			range = MESSAGE_RANGE_COMBAT_LOUD,
			otherwise_self = SPAN_WARNING("[target] already has a mirror."),
			visible = SPAN_WARNING("[src] makes a beep and disengages."),
		)
		return FALSE
	actor.visible_feedback(
		target = target,
		range = MESSAGE_RANGE_COMBAT_LOUD,
		visible = SPAN_WARNING("[actor.performer] starts injecting something with [src] into the base of [target]'s neck!"),
	)
	if(!do_after(actor.performer, IS_DEAD(target) ? 2.5 SECONDS : 7.5 SECONDS, target))
		return FALSE
	if(!inserted_mirror)
		return FALSE
	if(target.resleeving_get_mirror())
		return FALSE
	var/obj/item/organ/internal/mirror/inserting = remove_mirror(target, actor)
	if(!inserting)
		return FALSE
	var/mirror_descriptor
	if(!inserting.owner_mind_ref)
		mirror_descriptor = "mirror was empty"
	else if(target.resleeving_check_mind_belongs(inserting.owner_mind_ref.resolve()))
		mirror_descriptor = "mirror is mismatched"
	else
		mirror_descriptor = "mirror seems to match"
	if(!target.resleeving_insert_mirror(inserting))
		inserting.forceMove(drop_location())
		STACK_TRACE("mirror insert failed after PNR")
		return FALSE
	log_game("[actor.actor_log_string()] inserted a mirror into [key_name(target)] [src]; [mirror_descriptor].")
	actor.visible_feedback(
		target = target,
		range = MESSAGE_RANGE_COMBAT_LOUD,
		visible = SPAN_WARNING("[actor.performer] injects a mirror into the base of [target]'s neck!"),
	)
	return TRUE

/obj/item/mirrortool/proc/yank_mirror_from_mob(mob/target, datum/event_args/actor/actor, silent) as /obj/item/organ/internal/mirror
	if(inserted_mirror)
		return null
	var/obj/item/organ/internal/mirror/removed = target.resleeving_remove_mirror(src)
	if(!removed)
		return null
	insert_mirror(removed, actor)
	return removed

/obj/item/mirrortool/proc/inject_mirror_into_mob(mob/target, datum/event_args/actor/actor, silent)
	var/obj/item/organ/internal/mirror/inserting_mirror = inserted_mirror
	if(!target.resleeving_insert_mirror(inserting_mirror))
		return FALSE
	return TRUE

/obj/item/mirrortool/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "items/Mirrortool")
		ui.open()

/obj/item/mirrortool/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	switch(action)
		if("insert")
			var/obj/item/organ/internal/mirror/held_mirror = actor.performer.get_active_held_item()
			if(!held_mirror)
				actor.chat_feedback(SPAN_WARNING("You aren't holding a mirror in your active hand."), target = src)
				return TRUE
			user_insert_mirror(held_mirror, actor)
			return TRUE
		if("eject")
			if(!inserted_mirror)
				return TRUE
			user_remove_mirror(actor, actor.check_performer_reachability(src))
			return TRUE

/obj/item/mirrortool/ui_static_data(mob/user, datum/tgui/ui)
	. = ..()
	.["mirror"] = ui_serialize_mirror()

/obj/item/mirrortool/proc/ui_update_mirror()
	push_ui_data(data = list("mirror" = ui_serialize_mirror()))

/obj/item/mirrortool/proc/ui_serialize_mirror()
	return inserted_mirror ? inserted_mirror.ui_serialize() : null

/obj/item/mirrortool/context_menu_act(datum/event_args/actor/e_args, key)
	. = ..()
	if(.)
		return
	switch(key)
		if("eject-mirror")
			user_remove_mirror(e_args)
			return TRUE

/obj/item/mirrortool/context_menu_query(datum/event_args/actor/e_args)
	. = ..()
	if(inserted_mirror)
		.["eject-mirror"] = create_context_menu_tuple("eject mirror", image(src), 0, MOBILITY_CAN_USE, FALSE)

/obj/item/mirrortool/proc/user_remove_mirror(datum/event_args/actor/actor, put_in_hands = TRUE)
	if(!inserted_mirror)
		actor.chat_feedback(
			SPAN_WARNING("[src] doesn't have a mirror inserted."),
			target = src,
		)
		return TRUE
	var/obj/item/organ/internal/mirror/removed = remove_mirror(src, actor)
	if(put_in_hands)
		actor.performer.put_in_hands_or_drop(removed)
	else
		removed.forceMove(drop_location())
	return TRUE

/obj/item/mirrortool/proc/remove_mirror(atom/new_loc, datum/event_args/actor/actor) as /obj/item/organ/internal/mirror
	if(!inserted_mirror)
		return null
	var/obj/item/organ/internal/mirror/old_mirror = inserted_mirror
	inserted_mirror = null
	if(old_mirror.loc == src && new_loc)
		old_mirror.forceMove(new_loc)
	on_mirror_removed(old_mirror)
	return old_mirror

/obj/item/mirrortool/proc/on_mirror_removed(obj/item/organ/internal/mirror/mirror)
	ui_update_mirror()
	update_icon()

/obj/item/mirrortool/proc/user_insert_mirror(obj/item/organ/internal/mirror/mirror, datum/event_args/actor/actor)
	if(inserted_mirror)
		actor.chat_feedback(
			SPAN_WARNING("[src] already has a mirror."),
			target = src,
		)
		return FALSE
	if(!insert_mirror(mirror, actor))
		return FALSE
	actor.chat_feedback(
		SPAN_NOTICE("You insert [mirror] into [src]."),
		target = src,
	)
	return TRUE

/obj/item/mirrortool/proc/insert_mirror(obj/item/organ/internal/mirror/mirror, datum/event_args/actor/actor)
	if(inserted_mirror)
		return FALSE
	if(mirror.loc != src)
		mirror.forceMove(src)
	inserted_mirror = mirror
	on_mirror_inserted(mirror)
	return TRUE

/obj/item/mirrortool/proc/on_mirror_inserted(obj/item/organ/internal/mirror/mirror)
	ui_update_mirror()
	update_icon()
