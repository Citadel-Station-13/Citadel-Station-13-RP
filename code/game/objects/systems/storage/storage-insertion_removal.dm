//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * todo: refactor?
 *
 * @return TRUE / FALSE; if true, caller should stop clickchain.
 */
/datum/object_system/storage/proc/auto_handle_interacted_insertion(obj/item/inserting, datum/event_args/actor/actor, silent, suppressed)
	if(!actor.performer.is_holding(inserting))
		// something probably yanked it, don't bother
		return FALSE
	if(is_locked(actor.performer))
		actor.chat_feedback(
			msg = SPAN_WARNING("[parent] is locked."),
			target = parent,
		)
		return TRUE
	if(!actor.performer.Reachability(indirection || parent))
		return TRUE
	if(!try_insert(inserting, actor, silent, suppressed))
		return TRUE
	// sound
	// todo: put this in interacted_insert()..?
	if(!suppressed && !isnull(actor))
		if(sfx_insert)
			// todo: variable sound
			playsound(actor.performer, sfx_insert, 50, 1, -5)
		actor.visible_feedback(
			target = parent,
			range = MESSAGE_RANGE_INVENTORY_SOFT,
			visible = "[actor.performer] puts [inserting] into [parent].",
			visible_self = "You put [inserting] into [parent]",
		)
	return TRUE

/**
 * Called by inventory procs; skips some checks of interacted insertion.
 *
 * todo: refactor?
 *
 * @return TRUE on success, FALSE on failure.
 */
/datum/object_system/storage/proc/auto_handle_inventory_insertion(obj/item/inserting, datum/event_args/actor/actor, silent, suppressed)
	if(is_locked(actor.performer))
		actor.chat_feedback(
			msg = SPAN_WARNING("[parent] is locked."),
			target = parent,
		)
		return TRUE
	if(!actor.performer.Reachability(indirection || parent))
		return TRUE
	if(!try_insert(inserting, actor, silent, suppressed))
		return TRUE
	// sound
	// todo: put this in interacted_insert()..?
	if(!suppressed && !isnull(actor))
		if(sfx_insert)
			// todo: variable sound
			playsound(actor.performer, sfx_insert, 50, 1, -5)
		actor.visible_feedback(
			target = parent,
			range = MESSAGE_RANGE_INVENTORY_SOFT,
			visible = "[actor.performer] puts [inserting] into [parent].",
			visible_self = "You put [inserting] into [parent]",
		)
	return TRUE

/datum/object_system/storage/proc/try_insert(obj/item/inserting, datum/event_args/actor/actor, silent, suppressed, no_update)
	if(!can_be_inserted(inserting, actor, silent))
		return FALSE
	// point of no return
	if(actor && (inserting.get_worn_mob() == actor.performer && !actor.performer.temporarily_remove_from_inventory(inserting, user = actor.performer)))
		if(!silent)
			actor?.chat_feedback(
				msg = SPAN_WARNING("[inserting] is stuck to your hand / body!"),
				target = parent,
			)
		return FALSE
	// point of no return (real)
	return insert(inserting, actor, suppressed, no_update)

/datum/object_system/storage/proc/can_be_inserted(obj/item/inserting, datum/event_args/actor/actor, silent)
	if(!check_insertion_filters(inserting))
		if(!silent)
			actor?.chat_feedback(
				msg = SPAN_WARNING("[parent] can't hold [inserting]!"),
				target = parent,
			)
		return FALSE
	var/why_insufficient_space = why_failed_insertion_limits(inserting)
	if(why_insufficient_space)
		if(!silent)
			actor?.chat_feedback(
				msg = SPAN_WARNING("[parent] can't fit [inserting]! ([why_insufficient_space])"),
				target = parent,
			)
		return FALSE
	return TRUE

/**
 * inserts something
 *
 * @params
 * * inserting - thing being inserted
 * * actor - who's inserting it
 * * suppressed - suppress sounds
 * * no_update - do not update uis
 * * no_move - much more than not moving; basically makes an abstract contents operation without otherwise doing normal logic. use with care.
 */
/datum/object_system/storage/proc/insert(obj/item/inserting, datum/event_args/actor/actor, suppressed, no_update, no_move)
	physically_insert_item(inserting, no_move)

	if(!no_update)
		if(update_icon_on_item_change)
			update_icon()
		refresh()

	return TRUE

/**
 * handle moving an item in
 * we can assume this proc will do potentially literally anything with the item, so.
 *
 * @return inserted item or null (null doesn't mean insert failed; for example stacks can be merged in)
 */
/datum/object_system/storage/proc/physically_insert_item(obj/item/inserting, no_move, from_hook)
	inserting.item_flags |= ITEM_IN_STORAGE
	if(!no_move)
		inserting.forceMove(real_contents_loc())
	inserting.vis_flags |= VIS_INHERIT_LAYER | VIS_INHERIT_PLANE
	inserting.reset_pixel_offsets()
	inserting.on_enter_storage(src)
	if(weight_propagation)
		var/inserting_weight = inserting.get_weight()
		if(inserting_weight)
			weight_cached += inserting_weight
			update_containing_weight(inserting_weight)
	cached_combined_volume += inserting.get_weight_volume()
	cached_combined_weight_class += inserting.get_weight_class()
	return inserting

/**
 * @return TRUE / FALSE
 */
/datum/object_system/storage/proc/auto_handle_interacted_removal(obj/item/removing, datum/event_args/actor/actor, silent, suppressed, put_in_hands)
	if(is_locked(actor.performer))
		actor.chat_feedback(
			msg = SPAN_WARNING("[parent] is locked."),
			target = parent,
		)
		return TRUE
	if(!actor.performer.Reachability(parent))
		return TRUE
	if(!try_remove(removing, actor.performer, actor, silent, suppressed))
		return TRUE
	if(put_in_hands)
		actor.performer.put_in_hands_or_drop(removing)
	else
		removing.forceMove(actor.performer.drop_location())
	// todo: put this in interacted_insert()..?
	if(!suppressed && !isnull(actor))
		if(sfx_remove)
			// todo: variable sound
			playsound(actor.performer, sfx_remove, 50, 1, -5)
		actor.visible_feedback(
			target = parent,
			range = MESSAGE_RANGE_INVENTORY_SOFT,
			visible = "[actor.performer] takes [removing] out of [parent].",
			visible_self = "You take [removing] out of [parent]",
		)
	return TRUE

/**
 * try to remove item from self
 *
 * @return item removed; not necessarily the item passed in.
 */
/datum/object_system/storage/proc/try_remove(obj/item/removing, atom/to_where, datum/event_args/actor/actor, silent, suppressed, no_update)
	return remove(removing, to_where, actor, suppressed, no_update)

/datum/object_system/storage/proc/can_be_removed(obj/item/removing, atom/to_where, datum/event_args/actor/actor, silent)
	return TRUE

/**
 * remove item from self
 *
 * @return item removed; not necessarily the item passed in.
 */
/datum/object_system/storage/proc/remove(obj/item/removing, atom/to_where, datum/event_args/actor/actor, suppressed, no_update, no_move)
	. = physically_remove_item(removing, to_where, no_move)
	if(isnull(.))
		return

	if(!no_update)
		if(update_icon_on_item_change)
			update_icon()
		refresh()

/**
 * handle moving an item out
 * we can assume this proc will do potentially literally anything with the item, so..
 *
 * @return moved item
 */
/datum/object_system/storage/proc/physically_remove_item(obj/item/removing, atom/to_where, no_move, from_hook)
	removing.item_flags &= ~ITEM_IN_STORAGE
	if(!no_move)
		if(to_where == null)
			removing.moveToNullspace()
		else
			removing.forceMove(to_where)
	removing.vis_flags = (removing.vis_flags & ~(VIS_INHERIT_LAYER | VIS_INHERIT_LAYER)) | (initial(removing.vis_flags) & (VIS_INHERIT_LAYER | VIS_INHERIT_PLANE))
	removing.on_exit_storage(src)
	// we might have set maptext in render_numerical_display
	removing.maptext = null
	if(weight_propagation)
		var/removing_weight = removing.get_weight()
		if(removing_weight)
			weight_cached -= removing_weight
			update_containing_weight(-removing_weight)
	cached_combined_volume -= removing.get_weight_volume()
	cached_combined_weight_class -= removing.get_weight_class()
	return removing
