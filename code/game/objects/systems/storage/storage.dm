//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * storage systems
 *
 * stores /item's
 */
/datum/object_system/storage

	//* Access *//

	/// if set, limit allowable random access to first n items
	var/limited_random_access_stack_amount
	/// if set, limit allowable random access goes from bottom up, not top down
	/// * top down is from end of contents list, bottom up is from start of contents list
	var/limited_random_access_stack_bottom_first = FALSE

	//* Actions *//

	/// the action we have for mode switching gathering
	var/datum/action/storage_gather_mode/action_mode_switch

	//* Carry Weight *//

	/// do we propagate weight?
	/// use the setter, do not change this manually.
	var/weight_propagation = TRUE
	/// carry weight in us prior to mitigation
	var/weight_cached = 0
	/// carry weight mitigation, static. applied after multiplicative
	var/weight_subtract = 0
	/// carry weight mitigation, multiplicative.
	var/weight_multiply = 1

	//* Deconstruction & Integrity *//

	/// on deconstruct(method), drop on these method flags
	var/drop_on_deconstruction_methods = ALL
	/// locks don't work if atom is broken
	var/lock_nullified_by_atom_break = FALSE

	//* Defense *//

	/// pass EMPs in
	var/pass_emp_inside = TRUE
	/// pass EMPs in but weaken them
	var/pass_emp_weaken = TRUE

	//* Economy *//

	/// allow selling stuff in worth intrinsic
	var/use_worth_containing = TRUE

	//* Filters *//

	/// protected var because we want to cache.
	/// set to a list of typepaths to initialize it at New().
	/// * things in this list are the only things that can fit in us
	/// * overruled by blacklist
	/// * Never, ever edit this list directly.
	VAR_PROTECTED/list/insertion_whitelist_typecache
	/// protected var because we want to cache.
	/// set to a list of typepaths to initialize it at New().
	/// * things in this list can never fit in us, even if in whitelist
	/// * Never, ever edit this list directly.
	VAR_PROTECTED/list/insertion_blacklist_typecache
	/// protected var because we want to cache.
	/// set to a list of typepaths to initialize it at New().
	/// * in whitelist mode, things in this list can also be put in
	/// * in blacklist mode, things in this list can always be put in regardless
	/// * overrules both whitelist and blacklist
	/// * Never, ever edit this list directly.
	/// this is so overriding things can be easier.
	VAR_PROTECTED/list/insertion_allow_typecache

	//* Interaction *//

	/// insert proposition: 'on', 'in', etc
	var/insert_preposition = "in"

	/// allow quick empty at all
	var/allow_quick_empty = FALSE
	/// allow quick empty via clickdrag
	var/allow_quick_empty_via_clickdrag = TRUE
	/// allow quick empty via attack self
	var/allow_quick_empty_via_attack_self = TRUE

	/// allow inbound mass transfers
	var/allow_inbound_mass_transfer = TRUE
	/// allow outbound mass transfer
	var/allow_outbound_mass_transfer = TRUE
	/// allow clickdrag to initiate mass transfer
	var/allow_clickdrag_mass_transfer = TRUE

	/// allow mass gather at all
	var/allow_mass_gather = FALSE
	/// allow mass gather via click
	var/allow_mass_gather_via_click = TRUE
	/// allow switching mass gathering mode
	var/allow_mass_gather_mode_switch = TRUE
	/// mass gather mode
	var/mass_gather_mode = STORAGE_QUICK_GATHER_COLLECT_ALL

	/// allow opening when clicking from other hand
	var/allow_open_via_offhand_click = TRUE
	/// allow opening via alt click
	var/allow_open_via_alt_click = TRUE
	/// allow opening via context menu click
	var/allow_open_via_context_click = TRUE
	/// allow opening when clicking from hand if this is equipped
	var/allow_open_via_equipped_click = TRUE
	/// allow opening via clickdrag to self
	var/allow_open_via_clickdrag_to_self = TRUE

	/// ghosts can always see inside
	var/always_allow_observer_view = TRUE

	//* Limits *//

	/// if set, limit to a certain volume
	var/max_combined_volume
	/// if set, allow only a certain amount of items
	var/max_items
	/// if set, max weight class we can hold
	var/max_single_weight_class
	/// if set, max combined weight class of all containing items we can hold
	var/max_combined_weight_class
	/// disallow nesting storage items of same or bigger weight class
	var/disallow_equal_weight_class_storage_nesting = TRUE

	//* Locking *//

	/// locked storage can't be accessed, unless show() is called with force
	/// however, you can continue viewing even if it's locked.
	/// use set_locked() to modify.
	var/locked = FALSE

	//* Mass Operations *//

	/// mutex to prevent mass operation spam
	var/mass_operation_interaction_mutex = FALSE

	//* Redirection *//

	/// When set, we treat this as the real parent object.
	/// **Warning**: This is an advanced feature.
	/// It is your responsibility to understand what that means in context of storage, not ours.
	///
	/// The storage backend this was inspired from used to have a real / virtual system,
	/// where not all storage components were 'real' and could link to a 'concrete'
	/// storage component where items are actually stored, so remote storages work.
	///
	/// That, however, is too complex and awful, so, we just have a single redirection var now
	/// if you mess it up, it is not my fault. ~silicons
	///
	/// * If you use this, you should probably set [use_worth_containing] to FALSE if it isn't logically in here.
	/// * If you don't, double (or even infinite) selling can happen.
	///
	/// todo: this literally doesn't work due to no Reachability hooks. please implement this properly later via reachability signal hooks.
	var/atom/movable/storage_indirection/indirection

	//* Radiation *//
	/// pass clean radiation calls inside?
	var/pass_clean_radiation_inside = FALSE

	//* Rendering *//

	/// update icon on item change
	var/update_icon_on_item_change = FALSE

	//* State Caches *//

	/// cached combined w class
	var/tmp/cached_combined_weight_class
	/// cached combined volume
	var/tmp/cached_combined_volume

	//* Sound Effects *//

	/// open / access sound passed into playsound
	var/sfx_open = "rustle"
	/// removal sound passed into playsoud
	var/sfx_remove = "rustle"
	/// insert sound passed into playsound
	var/sfx_insert = "rustle"

	//* UIs *//

	/// lazy list of UIs open; mob ref = list(ui objects)
	var/list/ui_by_mob
	/// stack stuff by number; defaults to types, please override the requisite proc to implement yours.
	var/ui_numerical_mode = FALSE
	/// ui force slot mode.
	var/ui_force_slot_mode = FALSE
	/// show minimum number of slots necessary, expand as needed
	/// currently only works for slot mode
	var/ui_expand_when_needed = FALSE
	/// ui update queued?
	//  todo: this is only needed because redirection is halfassed.
	var/ui_refresh_queued = FALSE

/datum/object_system/storage/New(obj/parent)
	src.parent = parent
	// we use typelists to detect if it's been init'd
	if(!is_typelist(insertion_whitelist_typecache))
		insertion_whitelist_typecache = cached_typecacheof(insertion_whitelist_typecache)
	if(!is_typelist(insertion_blacklist_typecache))
		insertion_blacklist_typecache = cached_typecacheof(insertion_blacklist_typecache)
	if(!is_typelist(insertion_allow_typecache))
		insertion_allow_typecache = cached_typecacheof(insertion_allow_typecache)

/datum/object_system/storage/Destroy()
	hide()
	QDEL_NULL(action_mode_switch)
	QDEL_NULL(indirection)
	return ..()

//* Access *//

/**
 * do not mutate returned list
 */
/datum/object_system/storage/proc/dangerously_accessible_items_immutable(random_access = TRUE)
	var/atom/redirection = real_contents_loc()
	if(random_access)
		if(limited_random_access_stack_amount)
			var/contents_length = length(redirection.contents)
			if(limited_random_access_stack_bottom_first)
				return redirection.contents.Copy(1, min(contents_length + 1, limited_random_access_stack_bottom_first + 1))
			else
				return redirection.contents.Copy(max(1, contents_length - limited_random_access_stack_amount + 1), contents_length + 1)
	return redirection.contents

/**
 * you may mutate returned list
 */
/datum/object_system/storage/proc/accessible_items(random_access = TRUE)
	var/atom/redirection = real_contents_loc()
	if(random_access)
		if(limited_random_access_stack_amount)
			var/contents_length = length(redirection.contents)
			if(limited_random_access_stack_bottom_first)
				return redirection.contents.Copy(1, min(contents_length + 1, limited_random_access_stack_bottom_first + 1))
			else
				return redirection.contents.Copy(max(1, contents_length - limited_random_access_stack_amount + 1), contents_length + 1)
	return redirection.contents.Copy()

/**
 * Recursively return all inventory in this or nested storage (without indirection)
 */
/datum/object_system/storage/proc/recursively_return_contents(list/returning = list())
	var/atom/redirection = real_contents_loc()
	for(var/obj/item/iterating in redirection)
		returning += iterating
		iterating.obj_storage?.recursively_return_contents(returning)
	return returning

/**
 * iterate through what's considered inside
 *
 * this is a mutable / copy of a list, so you're free to mess with it.
 */
/datum/object_system/storage/proc/contents()
	. = list()
	for(var/obj/item/inside in real_contents_loc())
		. += inside

/datum/object_system/storage/proc/accessible_by_mob(mob/user)
	if(IsAdminGhost(user) || (isobserver(user) && always_allow_observer_view))
		return TRUE
	return user.CheapReachability(parent)

/datum/object_system/storage/proc/top_entity_in_contents()
	RETURN_TYPE(/atom/movable)
	var/atom/indirection = real_contents_loc()
	var/amt = length(indirection.contents)
	return amt? indirection.contents[amt] : null

//* Buttons *//

/datum/object_system/storage/proc/ensure_buttons()
	if(!allow_mass_gather || !allow_mass_gather_mode_switch)
		return
	if(!isnull(action_mode_switch))
		return
	action_mode_switch = new(src)
	action_mode_switch.button_additional_only = TRUE

/datum/object_system/storage/proc/grant_buttons(mob/wearer)
	ensure_buttons()
	if(allow_mass_gather && allow_mass_gather_mode_switch)
		action_mode_switch.grant(wearer.inventory.actions)

/datum/object_system/storage/proc/revoke_buttons(mob/wearer)
	action_mode_switch?.revoke(wearer.inventory.actions)

/datum/object_system/storage/ui_action_click(datum/action/action, datum/event_args/actor/actor)
	switch_gathering_modes(actor.performer)

//* Caches *//

/datum/object_system/storage/proc/rebuild_caches()
	cached_combined_volume = 0
	cached_combined_weight_class = 0
	var/old_weight = weight_cached
	weight_cached = 0
	for(var/obj/item/item in real_contents_loc())
		cached_combined_volume += item.get_weight_volume()
		cached_combined_weight_class += item.get_weight_class()
		weight_cached += item.get_weight()
	update_containing_weight(weight_cached - old_weight)

/**
 * rebuild full state, used when shit explodes, vv use only. this is not totally
 * idempotent due to on_enter_storage() not being 100% idempotent, so, this is a debug proc.
 */
/datum/object_system/storage/proc/dangerously_kind_of_rebuild_state()
	// incase it wasn't clear enough: **DO NOT USE THIS UNLESS YOU ARE AN ADMIN TRYING TO FIX SOMETHING WITH SDQL.**
	PRIVATE_PROC(TRUE)
	for(var/obj/item/item in real_contents_loc())
		// assert variables
		physically_insert_item(item, no_move = TRUE)
	// rebuild the caches we just fucked up
	rebuild_caches()

//* Checks *//

/datum/object_system/storage/proc/remaining_volume()
	return isnull(max_combined_volume)? INFINITY : (max_combined_volume - cached_combined_volume)

/datum/object_system/storage/proc/remaining_weight_class()
	return isnull(max_combined_weight_class)? INFINITY : (max_combined_weight_class - cached_combined_weight_class)

/datum/object_system/storage/proc/remaining_items()
	var/atom/indirection = real_contents_loc()
	return isnull(max_items)? INFINITY : (max_items - length(indirection.contents))

//* Carry Weight *//

/datum/object_system/storage/proc/get_containing_weight()
	return max(0, weight_cached * weight_multiply - weight_subtract)

/datum/object_system/storage/proc/update_containing_weight(change)
	if(!isitem(parent))
		return
	// todo: rewrite the weight system
	var/obj/item/item = parent
	item.update_weight()
	var/current = item.get_weight()
	item.propagate_weight(current - change, current)

/datum/object_system/storage/proc/set_weight_propagation(value)
	if(value == weight_propagation)
		return
	weight_propagation = value
	if(!weight_propagation)
		var/old_weight_cached = weight_cached
		weight_cached = 0
		update_containing_weight(-old_weight_cached)
	else
		rebuild_caches()

//* Hooks *//

/**
 * Hooked into obj/Moved().
 */
/datum/object_system/storage/proc/on_parent_moved(atom/old_loc, forced)
	reconsider_mob_viewable()

/datum/object_system/storage/proc/on_pickup(mob/user)
	grant_buttons(user)

/datum/object_system/storage/proc/on_dropped(mob/user)
	revoke_buttons(user)

/**
 * Called by our object when an item exits us
 */
/datum/object_system/storage/proc/on_item_exited(obj/item/exiting)
	if(!(exiting.item_flags & ITEM_IN_STORAGE))
		return
	physically_remove_item(exiting, no_move = TRUE, from_hook = TRUE)
	ui_queue_refresh()

/**
 * Called by our object when an item enters us
 */
/datum/object_system/storage/proc/on_item_entered(obj/item/entering)
	if(entering.item_flags & ITEM_IN_STORAGE)
		return
	physically_insert_item(entering, no_move = TRUE, from_hook = TRUE)
	ui_queue_refresh()

/datum/object_system/storage/proc/on_contents_weight_class_change(obj/item/item, old_weight_class, new_weight_class)
	cached_combined_weight_class += (new_weight_class - old_weight_class)
	if(isnull(item.weight_volume))
		on_contents_weight_volume_change(item, global.w_class_to_volume[old_weight_class], global.w_class_to_volume[new_weight_class])

/datum/object_system/storage/proc/on_contents_weight_volume_change(obj/item/item, old_weight_volume, new_weight_volume)
	cached_combined_volume += (new_weight_volume - old_weight_volume)

/datum/object_system/storage/proc/on_contents_weight_change(obj/item/item, old_weight, new_weight)
	weight_cached += (new_weight - old_weight)
	update_containing_weight(new_weight - old_weight)

/datum/object_system/storage/proc/on_contents_item_new(obj/item/item)
	if(item.item_flags & ITEM_IN_STORAGE) // somehow
		return
	physically_insert_item(item, no_move = TRUE)
	ui_queue_refresh()

//* Interaction *//

/**
 * returns TRUE if we should interrupt an open
 */
/datum/object_system/storage/proc/check_on_found_hooks(datum/event_args/actor/actor)
	for(var/obj/item/thing in real_contents_loc())
		if(thing.on_containing_storage_opening(actor, src))
			return TRUE
	return FALSE

//* Insertion & Removal *//

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
 *
 * we can assume this proc will do potentially literally anything with the item, so.
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
 *
 * we can assume this proc will do potentially literally anything with the item, so..
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

//* Limits *//

/**
 * generally a bad idea to call, tbh.
 *
 * uses max single weight class
 * uses combined volume
 *
 * can use type whitelist
 * if type_whitelist is FALSE, this just wipes all type whitelists.
 */
/datum/object_system/storage/proc/fit_to_contents(type_whitelist = FALSE, no_shrink = FALSE)
	var/scanned_max_single_weight_class = WEIGHT_CLASS_TINY
	var/scanned_max_combined_volume = 0

	if(!no_shrink)
		max_single_weight_class = scanned_max_single_weight_class
		max_combined_volume = scanned_max_combined_volume

	var/list/types = list()
	for(var/obj/item/item in real_contents_loc())
		if(type_whitelist)
			types |= item.type
		scanned_max_single_weight_class = max(max_single_weight_class, item.w_class)
		scanned_max_combined_volume += item.get_weight_volume()

	max_single_weight_class = max(max_single_weight_class, scanned_max_single_weight_class)
	max_combined_volume = max(max_combined_volume, scanned_max_combined_volume)

	set_insertion_whitelist(type_whitelist? types : null)
	set_insertion_blacklist(null)
	set_insertion_allow(null)

//* Locking *//

/**
 * @params
 * * accessing - the mob physically trying to reach in
 */
/datum/object_system/storage/proc/is_locked(mob/accessing)
	return locked && (!lock_nullified_by_atom_break || !(parent.atom_flags & ATOM_BROKEN))

/datum/object_system/storage/proc/set_locked(value)
	if(locked == value)
		return
	locked = value
	if(locked)
		hide()

//* Quickdraw *//

// todo: quickdraw

//* Redirection *//

/datum/object_system/storage/proc/real_contents_loc()
	return indirection || parent

//* Rendering - Object *//

/datum/object_system/storage/proc/update_icon()
	parent.update_icon()
	action_mode_switch?.button_additional_overlay = parent
	action_mode_switch?.update_buttons(TRUE)

//* Transfer *//

/datum/object_system/storage/proc/switch_gathering_modes(mob/user)
	switch(mass_gather_mode)
		if(STORAGE_QUICK_GATHER_COLLECT_ONE)
			mass_gather_mode = STORAGE_QUICK_GATHER_COLLECT_ALL
			to_chat(user, SPAN_NOTICE("[parent] is now collecting all items from a tile."))
		if(STORAGE_QUICK_GATHER_COLLECT_ALL)
			mass_gather_mode = STORAGE_QUICK_GATHER_COLLECT_SAME
			to_chat(user, SPAN_NOTICE("[parent] is now collecting all items of a given type from a tile."))
		if(STORAGE_QUICK_GATHER_COLLECT_SAME)
			mass_gather_mode = STORAGE_QUICK_GATHER_COLLECT_ONE
			to_chat(user, SPAN_NOTICE("[parent] is now collecting one item at a time."))

/**
 * Actor is mandatory.
 */
/datum/object_system/storage/proc/auto_handle_interacted_mass_transfer(datum/event_args/actor/actor, datum/object_system/storage/to_storage)
	if(to_storage == src)
		return FALSE
	if(is_locked(actor.performer))
		actor?.chat_feedback(
			msg = SPAN_WARNING("[parent] is locked."),
			target = parent,
		)
		return TRUE
	parent.add_fingerprint(actor.performer)
	interacted_mass_transfer(actor, to_storage)
	return TRUE

/**
 * Actor is mandatory.
 */
/datum/object_system/storage/proc/auto_handle_interacted_mass_pickup(datum/event_args/actor/actor, atom/from_where)
	if(is_locked(actor.performer))
		actor?.chat_feedback(
			msg = SPAN_WARNING("[parent] is locked."),
			target = parent,
		)
		return TRUE
	parent.add_fingerprint(actor.performer)
	interacted_mass_pickup(actor, from_where)
	return TRUE

/**
 * Actor is mandatory.
 */
/datum/object_system/storage/proc/auto_handle_interacted_mass_dumping(datum/event_args/actor/actor, atom/to_where)
	if(is_locked(actor.performer))
		actor?.chat_feedback(
			msg = SPAN_WARNING("[parent] is locked."),
			target = parent,
		)
		return TRUE
	parent.add_fingerprint(actor.performer)
	interacted_mass_dumping(actor, to_where)
	return TRUE

/**
 * Actor is mandatory.
 */
/datum/object_system/storage/proc/interacted_mass_transfer(datum/event_args/actor/actor, datum/object_system/storage/to_storage, silent, suppressed)
	if(mass_operation_interaction_mutex)
		return
	mass_operation_interaction_mutex = TRUE

	var/list/obj/item/transferring = list()
	for(var/obj/item/item in real_contents_loc())
		transferring += item

	if(!length(transferring))
		if(!silent)
			actor.chat_feedback(
				msg = "There's nothing to transfer out of [parent].",
				target = src,
			)
		mass_operation_interaction_mutex = FALSE
		return
	if(!silent)
		actor.chat_feedback(
			msg = "You start transferring the contents of [parent] to [to_storage.parent]",
			target = src,
		)
	if(!suppressed && sfx_insert)
		playsound(parent, sfx_insert, 50, TRUE, -4)

	var/list/rejections = list()
	while(do_after(actor.performer, 0.5 SECONDS, parent, NONE, MOBILITY_CAN_STORAGE | MOBILITY_CAN_PICKUP))
		if(!mass_storage_transfer_handler(transferring, to_storage, actor, rejections))
			break
		stoplag(1)

	if(!silent)
		if(!length(rejections))
			actor.chat_feedback(
				msg = "You finish transferring everything out from [parent].",
				target = src,
			)
		else
			actor.chat_feedback(
				msg = "You fail to transfer some things out of [parent].",
				target = src,
			)

	ui_queue_refresh()
	mass_operation_interaction_mutex = FALSE

/**
 * Actor is mandatory.
 */
/datum/object_system/storage/proc/interacted_mass_pickup(datum/event_args/actor/actor, atom/from_loc, silent, suppressed)
	if(mass_operation_interaction_mutex)
		return
	mass_operation_interaction_mutex = TRUE

	var/list/transferring
	switch(mass_gather_mode)
		if(STORAGE_QUICK_GATHER_COLLECT_ONE)
			if(!isitem(from_loc))
				return
			try_insert(from_loc, actor)
			mass_operation_interaction_mutex = FALSE
			return
		if(STORAGE_QUICK_GATHER_COLLECT_ALL)
			transferring = list()
			from_loc = get_turf(from_loc)
			for(var/obj/item/item in from_loc)
				transferring += item
		if(STORAGE_QUICK_GATHER_COLLECT_SAME)
			transferring = list()
			from_loc = get_turf(from_loc)
			for(var/obj/item/item in from_loc)
				if(item.type != from_loc.type)
					continue
				transferring += item

	if(!length(transferring))
		mass_operation_interaction_mutex = FALSE
		return
	if(!silent)
		actor.chat_feedback(
			msg = "You start gathering things from [from_loc] with [parent].",
			target = src,
		)
	if(!suppressed && sfx_insert)
		playsound(parent, sfx_insert, 50, TRUE, -4)

	var/list/rejections = list()
	while(do_after(actor.performer, 0.5 SECONDS, parent, NONE, MOBILITY_CAN_STORAGE | MOBILITY_CAN_PICKUP))
		if(!mass_storage_pickup_handler(transferring, from_loc, actor, rejections))
			break
		stoplag(1)

	ui_queue_refresh()
	mass_operation_interaction_mutex = FALSE

/**
 * Actor is mandatory.
 */
/datum/object_system/storage/proc/interacted_mass_dumping(datum/event_args/actor/actor, atom/to_loc, silent, suppressed)
	if(mass_operation_interaction_mutex)
		return
	mass_operation_interaction_mutex = TRUE

	var/list/obj/item/transferring = mass_dumping_query()

	if(!length(transferring))
		if(!silent)
			actor.chat_feedback(
				msg = "There's nothing to dump out of [parent].",
				target = src,
			)
		mass_operation_interaction_mutex = FALSE
		return
	if(!silent)
		actor.chat_feedback(
			msg = "You start dumping out the contents of [parent].",
			target = src,
		)
	if(!suppressed && sfx_insert)
		playsound(parent, sfx_remove, 50, TRUE, -4)

	var/list/rejections = list()
	while(do_after(actor.performer, 0.5 SECONDS, parent, NONE, MOBILITY_CAN_STORAGE | MOBILITY_CAN_PICKUP))
		var/keep_going = mass_storage_dumping_handler(transferring, to_loc, actor, rejections)
		if(!keep_going)
			break

	if(!silent)
		if(length(rejections))
			actor.chat_feedback(
				msg = "You fail to dump some things out of [parent].",
				target = src,
			)
		else if(!length(transferring))
			actor.chat_feedback(
				msg = "You finish dumping everything out of [parent].",
				target = src,
			)

	ui_queue_refresh()
	mass_operation_interaction_mutex = FALSE

/**
 * handles mass storage transfers
 *
 * this will CHECK_TICK.
 *
 * progressbar should be initialized with goal value being the total item count.
 *
 * @params
 * * things - things to transfer
 * * to_storage - destination storage
 * * progress - (optional) progressbar to update
 * * actor - (optional) person doing it
 * * rejections_out - (optional) rejected items
 * * trigger_on_found - trigger on found?
 *
 * This proc does not update / refresh UIs, please do that manually when using this proc.
 *
 * @return TRUE if not done, FALSE if done.
 */
/datum/object_system/storage/proc/mass_storage_transfer_handler(list/obj/item/things, datum/object_system/storage/to_storage, datum/event_args/actor/actor, list/obj/item/rejections_out = list(), trigger_on_found = TRUE)
	if(to_storage == src)
		return FALSE
	var/atom/indirection_from = real_contents_loc()
	var/atom/indirection_to = to_storage.real_contents_loc()
	var/i = length(things)
	. = TRUE
	while(i > 0)
		// stop if overtaxed
		if(TICK_CHECK)
			break
		var/obj/item/transferring = things[i]
		// make sure they're still there
		if(transferring.loc != indirection_from)
			i--
			continue
		// handle on open hooks if needed
		if(trigger_on_found && actor?.performer.active_storage != src && transferring.on_containing_storage_opening(actor, src))
			. = FALSE
			break
		// see if receiver can accept it
		if(!to_storage.can_be_inserted(transferring, actor, TRUE))
			rejections_out += transferring
			i--
			continue
		// see if we can remove it
		if(!can_be_removed(transferring, indirection_to, actor, TRUE))
			rejections_out += transferring
			i--
			continue
		// transfer; the on enter/exit hooks will handle the rest (awful but whatever!)
		if(transferring == remove(transferring, indirection_to, actor, TRUE, TRUE))
			// but only go down if we got rid of the real item
			i--
	things.Cut(i + 1, length(things) + 1)
	return . && length(things)

/**
 * handles mass item pickups
 *
 * this will CHECK_TICK
 *
 * progressbar should be initialized with goal value being the total item count.
 *
 * @params
 * * things - things to transfer
 * * from_loc - source loc
 * * progress - (optional) progressbar to update
 * * actor - (optional) person doing it
 * * rejections_out - (optional) list to add rejected items to
 *
 * This proc does not update / refresh UIs, please do that manually when using this proc.
 *
 * @return TRUE if not done, FALSE if done
 */
/datum/object_system/storage/proc/mass_storage_pickup_handler(list/obj/item/things, atom/from_loc, datum/event_args/actor/actor, list/rejections_out = list())
	var/i
	. = TRUE
	for(i in length(things) to 1 step -1)
		// stop if overtaxed
		if(TICK_CHECK)
			break
		var/obj/item/transferring = things[i]
		// make sure they're still there
		if(transferring.loc != from_loc)
			continue
		// see if it can be picked up
		if(!transferring.should_allow_pickup(actor, TRUE))
			rejections_out += transferring
			continue
		// see if we can accept it
		if(!try_insert(transferring, actor, TRUE, TRUE, TRUE))
			rejections_out += transferring
			continue
	things.Cut(i, length(things) + 1)
	return . && length(things)

/**
 * handles mass item dumps
 *
 * this will CHECK_TICK
 *
 * progressbar should be initialized with goal value being the total item count.
 *
 * @params
 * * things - things to transfer
 * * to_loc - where to transfer
 * * progress - (optional) progressbar to update
 * * actor - (optional) person doing it
 * * rejections_out - (optional) list to add rejected items to
 * * trigger_on_found - trigger on found?
 *
 * This proc does not update / refresh UIs, please do that manually when using this proc.
 *
 * @return TRUE if not done, FALSE if done
 */
/datum/object_system/storage/proc/mass_storage_dumping_handler(list/obj/item/things, atom/to_loc, datum/event_args/actor/actor, list/rejections_out = list(), trigger_on_found = TRUE)
	var/atom/indirection = real_contents_loc()
	var/i = length(things)
	. = TRUE
	while(i > 0)
		// stop if overtaxed
		if(TICK_CHECK)
			break
		var/obj/item/transferring = things[i]
		// make sure they're still there
		if(transferring.loc != indirection)
			i--
			continue
		// handle on open hooks if needed
		if(trigger_on_found && actor?.performer.active_storage != src && transferring.on_containing_storage_opening(actor, src))
			. = FALSE
			break
		// see if we can remove it
		var/obj/item/removed = try_remove(transferring, to_loc, actor, TRUE, TRUE, TRUE)
		if(isnull(removed))
			// failed
			rejections_out += transferring
			i--
			continue
		// succeeded
		if(removed == transferring)
			// but only go down if we got rid of the real item
			i--
	things.Cut(i + 1, length(things) + 1)
	return . && length(things)

/**
 * what to drop
 */
/datum/object_system/storage/proc/mass_dumping_query()
	var/atom/indirection = real_contents_loc()
	// holy shit do a copy please
	return indirection.contents.Copy()

/**
 * drop everything at
 */
/datum/object_system/storage/proc/drop_everything_at(atom/where)
	for(var/obj/item/I in real_contents_loc())
		I.forceMove(where)

//* UI *//

/**
 * @return TRUE if we did something (to interrupt clickchain)
 */
/datum/object_system/storage/proc/auto_handle_interacted_open(datum/event_args/actor/actor, force, suppressed)
	if(!force && is_locked(actor.performer))
		actor.chat_feedback(
			msg = SPAN_WARNING("[parent] is locked."),
			target = parent,
		)
		return TRUE
	if(check_on_found_hooks(actor))
		return TRUE
	if(!suppressed && !isnull(actor) && sfx_open)
		// todo: variable sound
		playsound(actor.performer, sfx_open, 50, 1, -5)
	// todo: jiggle animation
	show(actor.initiator)
	return TRUE

/datum/object_system/storage/proc/show(mob/viewer)
	if(viewer.active_storage == src)
		refresh_ui(viewer)
		return TRUE

	viewer.active_storage?.hide(viewer)
	viewer.active_storage = src

	create_ui(viewer)

	parent.object_storage_opened(viewer)

/**
 * if user not specified, it is 'all'.
 */
/datum/object_system/storage/proc/hide(mob/viewer)
	if(isnull(viewer))
		for(var/mob/iterating as anything in ui_by_mob)
			hide(iterating)
		return

	if(viewer.active_storage != src)
		stack_trace("viewer didn't have active storage set right, wtf?")
	else
		viewer.active_storage = null

	cleanup_ui(viewer)

	parent.object_storage_closed(viewer)

/datum/object_system/storage/proc/refresh(mob/viewer)
	ui_refresh_queued = FALSE
	if(isnull(viewer))
		for(var/mob/iterating as anything in ui_by_mob)
			refresh_ui(iterating)
		return
	refresh_ui(viewer)


/datum/object_system/storage/proc/reconsider_mob_viewable(mob/user)
	if(isnull(user))
		for(var/mob/viewer as anything in ui_by_mob)
			reconsider_mob_viewable(viewer)
		return
	if(accessible_by_mob(user))
		return
	hide(user)

//? Action

/datum/action/storage_gather_mode
	name = "Switch Gather Mode"

/datum/action/storage_gather_mode/pre_render_hook()
	if(istype(target, /datum/object_system/storage))
		var/datum/object_system/storage/storage_datum = target
		var/obj/storage_target = storage_datum.parent
		var/image/generated = new
		generated.appearance = storage_target
		generated.layer = FLOAT_LAYER
		generated.plane = FLOAT_PLANE
		button_additional_overlay = generated
	return ..()

//? Hooks

/obj/proc/object_storage_opened(mob/user)
	return

/obj/proc/object_storage_closed(mob/user)
	return

//? Wrapper for init

/**
 * Use this to init, not new()!
 */
/obj/proc/init_storage(path = /datum/object_system/storage, indirected = FALSE)
	RETURN_TYPE(/datum/object_system/storage)
	ASSERT(isnull(obj_storage))
	obj_storage = new path(src)
	if(!indirected)
		// get all items inside / registered
		for(var/obj/item/item in contents)
			obj_storage.on_item_entered(item)
	else
		obj_storage.indirect(src)
	return obj_storage
