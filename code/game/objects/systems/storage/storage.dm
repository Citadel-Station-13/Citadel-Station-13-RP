//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * storage systems
 *
 * stores /item's
 */
/datum/object_system/storage

	//* Access

	/// if set, limit allowable random access to first n items
	var/limited_random_access_stack_amount
	/// if set, limit allowable random access goes from bottom up, not top down
	/// * top down is from end of contents list, bottom up is from start of contents list
	var/limited_random_access_stack_bottom_first = FALSE

	//* Actions

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
	action_mode_switch.button_additional_overlay = parent

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

//* Filters *//

/datum/object_system/storage/proc/check_insertion_filters(obj/item/candidate)
	if(insertion_allow_typecache?[candidate.type])
		return TRUE
	if(!isnull(insertion_whitelist_typecache) && !insertion_whitelist_typecache?[candidate.type])
		return FALSE
	if(insertion_blacklist_typecache?[candidate.type])
		return FALSE
	return TRUE

/datum/object_system/storage/proc/set_insertion_whitelist(list/types)
	if(!length(types))
		src.insertion_whitelist_typecache = null
		return
	src.insertion_whitelist_typecache = cached_typecacheof(types)

/datum/object_system/storage/proc/set_insertion_blacklist(list/types)
	if(!length(types))
		src.insertion_blacklist_typecache = null
		return
	src.insertion_blacklist_typecache = cached_typecacheof(types)

/datum/object_system/storage/proc/set_insertion_allow(list/types)
	if(!length(types))
		src.insertion_allow_typecache = null
		return
	src.insertion_allow_typecache = cached_typecacheof(types)

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

/datum/object_system/storage/proc/try_insert(obj/item/inserting, datum/event_args/actor/actor, silent, suppressed, no_update)
	if(!can_be_inserted(inserting, actor, silent))
		return FALSE
	// point of no return
	if(actor && (inserting.worn_mob() == actor.performer && !actor.performer.temporarily_remove_from_inventory(inserting, user = actor.performer)))
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

/datum/object_system/storage/proc/check_insertion_limits(obj/item/candidate)
	var/atom/movable/indirection = real_contents_loc()
	if(!isnull(max_items) && length(indirection.contents) > max_items)
		return FALSE
	if(!isnull(max_combined_volume) && (cached_combined_volume + candidate.get_weight_volume() > max_combined_volume))
		return FALSE
	var/their_weight_class = candidate.get_weight_class()
	if(!isnull(max_single_weight_class) && (their_weight_class > max_single_weight_class))
		return FALSE
	if(!isnull(max_combined_weight_class) && (cached_combined_weight_class + their_weight_class > max_combined_weight_class))
		return FALSE
	if(candidate.obj_storage && (candidate.w_class >= parent.w_class) && disallow_equal_weight_class_storage_nesting)
		return FALSE
	return TRUE

/datum/object_system/storage/proc/why_failed_insertion_limits(obj/item/candidate)
	var/atom/movable/indirection = real_contents_loc()
	if(!isnull(max_items) && length(indirection.contents) > max_items)
		return "too many items"
	if(!isnull(max_combined_volume) && (cached_combined_volume + candidate.get_weight_volume() > max_combined_volume))
		return "insufficient volume"
	var/their_weight_class = candidate.get_weight_class()
	if(!isnull(max_single_weight_class) && (their_weight_class > max_single_weight_class))
		return "too large"
	if(!isnull(max_combined_weight_class) && (cached_combined_weight_class + their_weight_class > max_combined_weight_class))
		return "insufficient space"
	if(candidate.obj_storage && (candidate.w_class >= parent.w_class) && disallow_equal_weight_class_storage_nesting)
		return "can't nest storage"
	return null

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
/*
/datum/component/storage/proc/on_alt_click(datum/source, mob/user)
	if(!isliving(user) || !user.CanReach(parent))
		return
	if(check_locked(source, user, TRUE))
		return TRUE

	var/atom/A = parent
	if(!quickdraw)
		A.add_fingerprint(user)
		user_show_to_mob(user, trigger_on_found = TRUE)
		if(rustle_sound)
			playsound(A, "rustle", 50, 1, -5)
		return TRUE

	if(user.can_hold_items() && !user.incapacitated())
		var/obj/item/I = locate() in real_location()
		if(!I)
			return
		A.add_fingerprint(user)
		remove_from_storage(I, get_turf(user))
		if(!user.put_in_hands(I))
			user.visible_message("<span class='warning'>[user] fumbles with the [parent], letting [I] fall on the floor.</span>", \
								"<span class='notice'>You fumble with [parent], letting [I] fall on the floor.</span>")
			return TRUE
		user.visible_message("<span class='warning'>[user] draws [I] from [parent]!</span>", "<span class='notice'>You draw [I] from [parent].</span>")
		return TRUE
*/

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

/**
 * Hooked into obj/Moved().
 */
/datum/object_system/storage/proc/on_parent_moved(atom/old_loc, forced)
	reconsider_mob_viewable()

/datum/object_system/storage/proc/refresh(mob/viewer)
	ui_refresh_queued = FALSE
	if(isnull(viewer))
		for(var/mob/iterating as anything in ui_by_mob)
			refresh_ui(iterating)
		return
	refresh_ui(viewer)

/**
 * Do not modify the returned appearances; they might be real instances!
 *
 * @return list(/datum/storage_numerical_display instance, ...)
 */
/datum/object_system/storage/proc/render_numerical_display(list/obj/item/for_items)
	RETURN_TYPE(/list)
	. = list()
	var/list/types = list()
	for(var/obj/item/iterating in (for_items || real_contents_loc()))
		var/datum/storage_numerical_display/collation
		if(isnull(types[iterating.type]))
			collation = new
			collation.rendered_object = iterating
			collation.amount = 0
			. += collation
			types[iterating.type] = collation
		collation = types[iterating.type]
		++collation.amount
	tim_sort(., /proc/cmp_storage_numerical_displays_name_asc)

/datum/object_system/storage/proc/reconsider_mob_viewable(mob/user)
	if(isnull(user))
		for(var/mob/viewer as anything in ui_by_mob)
			reconsider_mob_viewable(viewer)
		return
	if(accessible_by_mob(user))
		return
	hide(user)

/datum/object_system/storage/proc/ui_queue_refresh()
	if(ui_refresh_queued)
		return
	ui_refresh_queued = TRUE
	addtimer(CALLBACK(src, PROC_REF(refresh)), 0)

/datum/object_system/storage/proc/cleanup_ui(mob/user)
	var/list/objects = ui_by_mob[user]
	user.client?.screen -= objects
	QDEL_LIST(objects)
	ui_by_mob -= user

/**
 * we assume that the display style didn't change.
 */
/datum/object_system/storage/proc/refresh_ui(mob/user)
	// for now, we just do a full redraw.
	cleanup_ui(user)
	create_ui(user)

/datum/object_system/storage/proc/create_ui(mob/user)
	var/uses_volumetric_ui = uses_volumetric_ui()
	var/list/atom/movable/screen/storage/objects
	if(uses_volumetric_ui)
		objects += create_ui_volumetric_mode(user)
	else
		objects += create_ui_slot_mode(user)
	LAZYINITLIST(ui_by_mob)
	ui_by_mob[user] = objects
	user.client?.screen += objects

/**
 * this should not rely on uses_numerical_ui()
 */
/datum/object_system/storage/proc/uses_volumetric_ui()
	return max_combined_volume && !ui_numerical_mode && !ui_force_slot_mode

/**
 * this should not rely on uses_volumetric_ui()
 */
/datum/object_system/storage/proc/uses_numerical_ui()
	return ui_numerical_mode

/datum/object_system/storage/proc/create_ui_slot_mode(mob/user)
	. = list()
	var/atom/movable/screen/storage/closer/closer = new
	. += closer
	var/atom/movable/screen/storage/panel/slot/boxes/boxes = new
	. += boxes
	// todo: clientless support is awful here
	var/list/decoded_view = decode_view_size(user.client?.view || world.view)
	var/view_x = decoded_view[1]
	// clamp to max items if needed
	var/rendering_width = STORAGE_UI_TILES_FOR_SCREEN_VIEW_X(view_x)
	if(max_items)
		rendering_width = min(max_items, rendering_width)
	// see if we need to process numerical display
	var/list/datum/storage_numerical_display/numerical_rendered = uses_numerical_ui()? render_numerical_display() : null
	// process indirection
	var/atom/indirection = real_contents_loc()
	// if we have expand when needed, only show 1 more than the actual amount.
	if(ui_expand_when_needed)
		rendering_width = min(rendering_width, (isnull(numerical_rendered)? length(indirection.contents) : length(numerical_rendered)) + 1)
	// compute count and rows
	var/item_count = isnull(numerical_rendered)? length(indirection.contents) : length(numerical_rendered)
	var/rows_needed = ROUND_UP(item_count / rendering_width) || 1
	// prepare iteration
	var/current_row = 1
	var/current_column = 1
	// render boxes
	boxes.screen_loc = "LEFT+[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X],BOTTOM+[STORAGE_UI_START_TILE_Y]:[STORAGE_UI_START_PIXEL_Y] to \
		LEFT+[STORAGE_UI_START_TILE_X + rendering_width - 1]:[STORAGE_UI_START_PIXEL_X],BOTTOM+[STORAGE_UI_START_TILE_Y + rows_needed - 1]:[STORAGE_UI_START_PIXEL_Y]"
	// render closer
	closer.screen_loc = "LEFT+[STORAGE_UI_START_TILE_X + rendering_width]:[STORAGE_UI_START_PIXEL_X],BOTTOM+[STORAGE_UI_START_TILE_Y]:[STORAGE_UI_START_PIXEL_Y]"
	// render items
	if(islist(numerical_rendered))
		for(var/datum/storage_numerical_display/display as anything in numerical_rendered)
			var/atom/movable/screen/storage/item/slot/renderer = new(null, display.rendered_object)
			. += renderer
			// render amount
			display.rendered_object.maptext = MAPTEXT("[display.amount]")
			// position
			renderer.screen_loc = "LEFT+[STORAGE_UI_START_TILE_X + current_column - 1]:[STORAGE_UI_START_PIXEL_X],\
				BOTTOM+[STORAGE_UI_START_TILE_Y + current_row - 1]:[STORAGE_UI_START_PIXEL_Y]"
			// advance
			++current_column
			if(current_column > rendering_width)
				current_column = 1
				++current_row
				if(current_row > STORAGE_UI_MAX_ROWS)
					break
	else
		for(var/obj/item/item in indirection)
			var/atom/movable/screen/storage/item/slot/renderer = new(null, item)
			. += renderer
			// position
			renderer.screen_loc = "LEFT+[STORAGE_UI_START_TILE_X + current_column - 1]:[STORAGE_UI_START_PIXEL_X],\
				BOTTOM+[STORAGE_UI_START_TILE_Y + current_row - 1]:[STORAGE_UI_START_PIXEL_Y]"
			// advance
			++current_column
			if(current_column > rendering_width)
				current_column = 1
				++current_row
				if(current_row > STORAGE_UI_MAX_ROWS)
					break

/datum/object_system/storage/proc/create_ui_volumetric_mode(mob/user)
	// guard against divide-by-0's
	if(!max_combined_volume)
		return create_ui_slot_mode(user)
	. = list()

	//? resolve view and rendering
	// todo: clientless support is awful here

	// resolve view
	var/list/decoded_view = decode_view_size(user.client?.view || world.view)
	var/view_x = decoded_view[1]
	// setup initial width
	var/rendering_width = STORAGE_UI_TILES_FOR_SCREEN_VIEW_X(view_x)
	var/rendering_width_in_pixels = rendering_width * 32
	// effective max scales up if we're overrunning
	var/effective_max_volume = max(max_combined_volume, cached_combined_volume)
	// scale down width to volume
	rendering_width_in_pixels = min(rendering_width_in_pixels, effective_max_volume * VOLUMETRIC_STORAGE_STANDARD_PIXEL_RATIO)

	//? resolve items

	// resolve indirection
	var/atom/indirection = real_contents_loc()

	//? prepare iteration

	// max x used in all rows, including padding.
	var/maximum_used_width = 0
	// current consumed x of row
	var/iteration_used_width = 0
	// current consumed item padding of row
	var/iteration_used_padding = 0
	// current row
	var/current_row = 1
	// safety
	var/safety = VOLUMETRIC_STORAGE_MAX_ITEMS
	// iterate and render
	for(var/obj/item/item in indirection)
		// check safety
		safety--
		if(safety <= 0)
			to_chat(user, SPAN_WARNING("Some items in this storage have been truncated for performance reasons."))
			break

		// check row
		if(iteration_used_width >= rendering_width_in_pixels)
			// check if we're out of rows
			if(current_row >= STORAGE_UI_MAX_ROWS)
				to_chat(user, SPAN_WARNING("Some items in this storage have been truncated for performance reasons."))
				break
			// make another row
			current_row++
			// register to maximum used width
			// we add the edge padding for both edges, but remove the last item's padding.
			maximum_used_width = max(maximum_used_width, iteration_used_width + iteration_used_padding + VOLUMETRIC_STORAGE_EDGE_PADDING * 2 - VOLUMETRIC_STORAGE_ITEM_PADDING)
			// reset vars
			iteration_used_padding = 0
			iteration_used_width = 0

		// render the item
		var/atom/movable/screen/storage/item/volumetric/renderer = new(null, item)
		// scale it as necessary, to nearest multiple of 2
		var/used_pixels = max(VOLUMETRIC_STORAGE_MINIMUM_PIXELS_PER_ITEM, CEILING(rendering_width_in_pixels * (item.get_weight_volume() / effective_max_volume), 2))
		// emit to renderer
		renderer.set_pixel_width(used_pixels)
		// set screen loc
		renderer.screen_loc = "LEFT+[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X + (iteration_used_width + iteration_used_padding + VOLUMETRIC_STORAGE_EDGE_PADDING) + (used_pixels - VOLUMETRIC_STORAGE_BOX_ICON_SIZE) * 0.5],\
			BOTTOM+[STORAGE_UI_START_TILE_Y + current_row - 1]:[STORAGE_UI_START_PIXEL_Y]"
		// add to emitted screen list
		. += renderer
		// add to iteration tracking
		iteration_used_width += used_pixels
		iteration_used_padding += VOLUMETRIC_STORAGE_ITEM_PADDING
	// register to maximum used width
	// we add the edge padding for both edges, but remove the last item's padding.
	maximum_used_width = max(maximum_used_width, iteration_used_width + iteration_used_padding + VOLUMETRIC_STORAGE_EDGE_PADDING * 2 - VOLUMETRIC_STORAGE_ITEM_PADDING)

	// now that everything's set up, we can render everything based on the solved sizes.
	// middle size; we also keep in account padding so there's a smooth expansion instead of a sudden expansion at the end.
	var/middle_width = max(maximum_used_width, rendering_width_in_pixels + iteration_used_padding)
	// i hate byond i hate byond i hate byond i hate byond; this is because things break if we don't extend by 2 pixels
	// at a time for left/right as we use a dumb transform matrix and screen loc to shift, instead of a scale and shift matrix
	middle_width = CEILING(middle_width, 2)
	// todo: instead of this crap we should instead have the translation matrix do the shift
	var/middle_shift = round(middle_width * 0.5 - VOLUMETRIC_STORAGE_BOX_ICON_SIZE * 0.5)
	// render left
	var/atom/movable/screen/storage/panel/volumetric/left/p_left = new
	. += p_left
	p_left.screen_loc = "LEFT+[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X - VOLUMETRIC_STORAGE_BOX_BORDER_SIZE],\
		BOTTOM+[STORAGE_UI_START_TILE_Y]:[STORAGE_UI_START_PIXEL_Y] to \
		LEFT+[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X - VOLUMETRIC_STORAGE_BOX_BORDER_SIZE],\
		BOTTOM+[STORAGE_UI_START_TILE_Y + current_row - 1]:[STORAGE_UI_START_PIXEL_Y]"
	// render middle
	var/atom/movable/screen/storage/panel/volumetric/middle/p_box = new
	. += p_box
	p_box.set_pixel_width(middle_width)
	p_box.screen_loc = "LEFT+[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X + middle_shift],\
		BOTTOM+[STORAGE_UI_START_TILE_Y]:[STORAGE_UI_START_PIXEL_Y] to \
		LEFT+[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X + middle_shift],\
		BOTTOM+[STORAGE_UI_START_TILE_Y + current_row - 1]:[STORAGE_UI_START_PIXEL_Y]"
	// render closer on bottom
	var/atom/movable/screen/storage/closer/closer = new
	. += closer
	closer.screen_loc = "LEFT+[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X + middle_width],\
		BOTTOM+[STORAGE_UI_START_TILE_Y]:[STORAGE_UI_START_PIXEL_Y]"
	// render right sides above closer
	if(current_row > 1)
		var/atom/movable/screen/storage/panel/volumetric/right/p_right = new
		. += p_right
		p_right.screen_loc = "LEFT+[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X + middle_width - WORLD_ICON_SIZE + VOLUMETRIC_STORAGE_BOX_BORDER_SIZE],\
			BOTTOM+[STORAGE_UI_START_TILE_Y + 1]:[STORAGE_UI_START_PIXEL_Y] to \
			LEFT+[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X + middle_width - WORLD_ICON_SIZE + VOLUMETRIC_STORAGE_BOX_BORDER_SIZE],\
			BOTTOM+[STORAGE_UI_START_TILE_Y + current_row - 1]:[STORAGE_UI_START_PIXEL_Y]"

//* Indirection *//

/**
 * **USE AT YOUR OWN PERIL**
 */
/datum/object_system/storage/proc/indirect(atom/where)
	ASSERT(isnull(indirection))
	indirection = new(where, src)

/**
 * remove indirection by obliterating contents
 */
/datum/object_system/storage/proc/destructively_remove_indirection()
	QDEL_NULL(indirection)

/**
 * remove indirection by moving contents
 */
/datum/object_system/storage/proc/relocate_remove_indirection(atom/where_to)
	ASSERT(!isnull(where_to) && where_to != indirection)
	for(var/atom/movable/AM as anything in indirection)
		AM.forceMove(where_to)
	QDEL_NULL(indirection)

/**
 * move indirection somewhere else
 */
/datum/object_system/storage/proc/move_indirection_to(atom/where_to)
	indirection.forceMove(where_to)

//? Numerical Display Helper

//? Action

/datum/action/storage_gather_mode
	name = "Switch Gather Mode"

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

//? Indirection Holder

/atom/movable/storage_indirection
	atom_flags = ATOM_ABSTRACT

	/// owner
	var/datum/object_system/storage/parent

/atom/movable/storage_indirection/Initialize(mapload, datum/object_system/storage/parent)
	src.parent = parent
	return ..()

/atom/movable/storage_indirection/Destroy()
	if(src.parent.indirection == src)
		src.parent.indirection = null
	src.parent = null
	return ..()

/atom/movable/storage_indirection/CanReachIn(atom/movable/mover, atom/target, obj/item/tool, list/cache)
	return TRUE

/atom/movable/storage_indirection/CanReachOut(atom/movable/mover, atom/target, obj/item/tool, list/cache)
	return TRUE

/atom/movable/storage_indirection/Exited(atom/movable/AM, atom/newLoc)
	. = ..()
	if(isitem(AM))
		parent.on_item_exited(AM)

/atom/movable/storage_indirection/Entered(atom/movable/AM, atom/oldLoc)
	. = ..()
	if(isitem(AM))
		parent.on_item_entered(AM)

/atom/movable/storage_indirection/on_contents_weight_class_change(obj/item/item, old_weight_class, new_weight_class)
	parent.on_contents_weight_class_change(item, old_weight_class, new_weight_class)

/atom/movable/storage_indirection/on_contents_weight_volume_change(obj/item/item, old_weight_volume, new_weight_volume)
	parent.on_contents_weight_volume_change(item, old_weight_volume, new_weight_volume)

/atom/movable/storage_indirection/on_contents_weight_change(obj/item/item, old_weight, new_weight)
	parent.on_contents_weight_change(item, old_weight, new_weight)

/atom/movable/storage_indirection/on_contents_item_new(obj/item/item)
	parent.on_contents_item_new(item)
