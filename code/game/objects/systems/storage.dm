//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

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

	/// carry weight in us prior to mitigation
	var/weight_cached = 0
	#warn hook
	/// carry weight mitigation, static. applied after multiplicative
	var/weight_subtract = 0
	/// carry weight mitigation, multiplicative.
	var/weight_multiply = 1
	#warn hook weight calcs

	//* Deconstruction & Integrity

	/// on deconstruct(method), drop on these method flags
	var/drop_on_deconstruction_methods = ALL
	/// locks don't work if atom is broken
	var/lock_nullified_by_atom_break = FALSE

	//* Defense

	/// pass EMPs in
	var/pass_emp_inside = TRUE
	/// pass EMPs in but weaken them
	var/pass_emp_weaken = TRUE

	//* Filters

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

	//* Interaction

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
	#warn impl action
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

	//* Limits

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

	//* Locking

	/// locked storage can't be accessed, unless show() is called with force
	/// however, you can continue viewing even if it's locked.
	/// use set_locked() to modify.
	var/locked = FALSE

	//* Redirection

	/// When set, we treat this as the real parent object.
	/// **Warning**: This is an advanced feature.
	/// All this does is make us scan a different atom's contents.
	/// It is your responsibility to understand what that means in context of storage, not ours.
	///
	/// The storage backend this was inspired from used to have a real / virtual system,
	/// where not all storage components were 'real' and could link to a 'concrete'
	/// storage component where items are actually stored, so remote storages work.
	///
	/// That, however, is too complex and awful, so, we just have a single redirection var now
	/// if you mess it up, it is not my fault. ~silicons
	///
	/// todo: this needs a setter so we can properly use comsigs to hook the redirected-to object's Exited()
	/// todo: we should also hook the thing's Destroy, etc etc.
	/// todo: this literally doesn't work due to no Reachability hooks. please implement this properly later via reachability signal hooks.
	/// otherwise, using this is going to be GC failure hell from vis contents and rendering.
	var/atom/dangerously_redirect_contents_calls

	//* Rendering

	/// update icon on item change
	var/update_icon_on_item_change = FALSE

	//* State Caches

	/// cached combined w class
	var/tmp/cached_combined_weight_class
	/// cached combined volume
	var/tmp/cached_combined_volume

	//* Sound Effects

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

/datum/object_system/storage/New()
	// we use typelists to detect if it's been init'd
	if(!is_typelist(insertion_whitelist_typecache))
		insertion_whitelist_typecache = cached_typecacheof(insertion_whitelist_typecache)
	if(!is_typelist(insertion_blacklist_typecache))
		insertion_blacklist_typecache = cached_typecacheof(insertion_blacklist_typecache)
	if(!is_typelist(insertion_allow_typecache))
		insertion_allow_typecache = cached_typecacheof(insertion_allow_typecache)
	rebuild_caches()

/datum/object_system/storage/Destroy()
	hide()
	QDEL_NULL(action_mode_switch)
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

//* Caches *//

/datum/object_system/storage/proc/rebuild_caches()
	cached_combined_volume = 0
	cached_combined_weight_class = 0
	weight_cached = 0
	for(var/obj/item/item in real_contents_loc())
		cached_combined_volume += item.get_weight_volume()
		cached_combined_weight_class += item.get_weight_class()
		weight_cached += item.get_weight()
	#warn propagate weight

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

//* Hooks *//

/**
 * Called by our object when an item exits us
 */
/datum/object_system/storage/proc/on_item_exited(obj/item/exiting)
	#warn impl

/**
 * Called by our object when an item enters us
 */
/datum/object_system/storage/proc/on_item_entered(obj/item/entering)
	#warn impl

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
	if(is_locked(actor))
		actor.chat_feedback(
			msg = SPAN_WARNING("[parent] is locked."),
			target = parent,
		)
		return TRUE
	if(!try_insert(inserting, actor, silent, suppressed))
		return
	if(!suppressed && !isnull(actor) && sfx_remove)
		// todo: variable sound
		playsound(actor.performer, sfx_remove, 50, 1, -5)


/datum/object_system/storage/proc/try_insert(obj/item/inserting, datum/event_args/actor/actor, silent, suppressed, no_update)
	if(!can_be_inserted(inserting, actor, silent))
		return FALSE
	// point of no return
	if(inserting.worn_mob() == actor?.performer && !actor.performer.temporarily_remove_from_inventory(inserting, user = actor.performer))
		if(!silent)
			actor?.chat_feedback(
				msg = SPAN_WARNING("[inserting] is stuck to your hand / body!"),
				target = parent,
			)
		return FALSE
	// point of no return (real)
	#warn impl

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

/datum/object_system/storage/proc/insert(obj/item/inserting, datum/event_args/actor/actor, suppressed, no_update)
	#warn impl
	physically_insert_item(inserting)

	if(!no_update)
		if(update_icon_on_item_change)
			update_icon()
		refresh()

/**
 * handle moving an item in
 *
 * we can assume this proc will do potentially literally anything with the item, so..
 */
/datum/object_system/storage/proc/physically_insert_item(obj/item/inserting)
	inserting.forceMove(real_contents_loc())
	inserting.vis_flags |= VIS_INHERIT_LAYER | VIS_INHERIT_PLANE
	inserting.item_flags |= ITEM_IN_STORAGE
	inserting.on_enter_storage(src)

/**
 * @return TRUE / FALSE
 */
/datum/object_system/storage/proc/auto_handle_interacted_removal(obj/item/removing, datum/event_args/actor/actor, silent, suppressed, put_in_hands)
	if(is_locked(actor))
		actor.chat_feedback(
			msg = SPAN_WARNING("[parent] is locked."),
			target = parent,
		)
		return TRUE
	if(!try_remove(removing, actor.performer, actor, silent, suppressed))
		return
	if(put_in_hands)
		actor.performer.put_in_hands_or_drop(removing)
	else
		removing.forceMove(actor.performer.drop_location())
	if(!suppressed && !isnull(actor) && sfx_remove)
		// todo: variable sound
		playsound(actor.performer, sfx_remove, 50, 1, -5)

/datum/object_system/storage/proc/try_remove(obj/item/removing, atom/to_where, datum/event_args/actor/actor, silent, suppressed, no_update)
	if(!can_be_removed(removing, to_where, actor, silent))
		return FALSE
	#warn impl

/datum/object_system/storage/proc/can_be_removed(obj/item/removing, atom/to_where, datum/event_args/actor/actor, silent)
	return TRUE

/**
 * remove item from self
 */
/datum/object_system/storage/proc/remove(obj/item/removing, atom/to_where, datum/event_args/actor/actor, suppressed, no_update)
	#warn impl

	physically_remove_item(removing, to_where)

	if(!no_update)
		if(update_icon_on_item_change)
			update_icon()
		refresh()

/**
 * handle moving an item out
 *
 * we can assume this proc will do potentially literally anything with the item, so..
 */
/datum/object_system/storage/proc/physically_remove_item(obj/item/removing, atom/to_where)
	removing.forceMove(to_where)
	removing.vis_flags = (removing.vis_flags & ~(VIS_INHERIT_LAYER | VIS_INHERIT_LAYER)) | (initial(removing.vis_flags) & (VIS_INHERIT_LAYER | VIS_INHERIT_PLANE))
	removing.item_flags &= ~ITEM_IN_STORAGE
	removing.on_exit_storage(src)
	// we might have set maptext in render_numerical_display
	removing.maptext = null

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
 */
/datum/object_system/storage/proc/fit_to_contents(type_whitelist = FALSE)
	max_single_weight_class = WEIGHT_CLASS_TINY
	max_combined_volume = 0
	var/list/types = list()
	for(var/obj/item/item in real_contents_loc())
		if(type_whitelist)
			types |= item.type
		max_single_weight_class = max(max_single_weight_class, item.w_class)
		max_combined_volume += item.get_weight_volume()
	set_insertion_whitelist(types)
	set_insertion_blacklist(null)
	set_insertion_allow(null)

//* Locking *//

/datum/object_system/storage/proc/is_locked(datum/event_args/actor/actor)
	return locked && (!lock_nullified_by_atom_break || !(parent.atom_flags & ATOM_BROKEN))

/datum/object_system/storage/proc/set_locked(value)
	if(locked == value)
		return
	locked = value
	if(locked)
		hide()

//* Redirection *//

/datum/object_system/storage/proc/real_contents_loc()
	return dangerously_redirect_contents_calls || parent

//* Rendering - Object *//

/datum/object_system/storage/proc/update_icon()
	parent.update_icon()
	dangerously_redirect_contents_calls?.update_icon()

//* Transfer *//

/datum/object_system/storage/proc/auto_handle_interacted_mass_transfer(datum/event_args/actor/actor, datum/object_system/storage/to_storage)
	if(is_locked(actor))
		actor.chat_feedback(
			msg = SPAN_WARNING("[parent] is locked."),
			target = parent,
		)
		return TRUE
	interacted_mass_transfer(actor, to_storage)
	return TRUE

/datum/object_system/storage/proc/auto_handle_interacted_mass_pickup(datum/event_args/actor/actor, atom/from_where)
	if(is_locked(actor))
		actor.chat_feedback(
			msg = SPAN_WARNING("[parent] is locked."),
			target = parent,
		)
		return TRUE
	interacted_mass_pickup(actor, from_where)
	return TRUE

/datum/object_system/storage/proc/auto_handle_interacted_mass_dumping(datum/event_args/actor/actor, atom/to_where)
	if(is_locked(actor))
		actor.chat_feedback(
			msg = SPAN_WARNING("[parent] is locked."),
			target = parent,
		)
		return TRUE
	interacted_mass_dumping(actor, to_where)
	return TRUE

/datum/object_system/storage/proc/interacted_mass_transfer(datum/event_args/actor/actor, datum/object_storage/storage/to_storage)
	#warn impl

/datum/object_system/storage/proc/interacted_mass_pickup(datum/event_args/actor/actor, atom/from_loc)
	var/list/to_pickup
	switch(mass_gather_mode)
		if(STORAGE_QUICK_GATHER_COLLECT_ONE)
			if(!isitem(from_loc))
				return
			try_insert(from_loc, actor)
			return
		if(STORAGE_QUICK_GATHER_COLLECT_ALL)
			to_pickup = list()
			for(var/obj/item/item in from_loc)
				to_pickup += item
		if(STORAGE_QUICK_GATHER_COLLECT_SAME)
			to_pickup = list()
			for(var/obj/item/item in from_loc)
				if(item.type != from_loc.type)
					continue
				to_pickup += item

	#warn impl

/datum/object_system/storage/proc/interacted_mass_dumping(datum/event_args/actor/actor, atom/to_loc)
	#warn impl

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
 *
 * @return TRUE if not done, FALSE if done.
 */
/datum/object_system/storage/proc/mass_storage_transfer_handler(list/obj/item/things, datum/object_system/storage/to_storage, datum/progressbar/progress, datum/event_args/actor/actor)
	#warn impl

/**
 * handles mass item pickups
 *
 * this will CHECK_TICK
 *
 * progressbar should be initialized with goal value being the total item count.
 *
 * @params
 * * things - things to transfer
 * * from_storage - source storage
 * * progress - (optional) progressbar to update
 * * actor - (optional) person doing it
 * * rejections - (optional) list to add rejected items to
 *
 * @return TRUE if not done, FALSE if done
 */
/datum/object_system/storage/proc/mass_storage_pickup_handler(list/obj/item/things, atom/from_loc, datum/progressbar/progress, datum/event_args/actor/actor, list/rejections_out)
	#warn impl

/**
 * handles mass item dumps
 *
 * this will CHECK_TICK
 *
 * progressbar should be initialized with goal value being the total item count.
 *
 * @params
 * * things - things to transfer
 * * from_storage - source storage
 * * progress - (optional) progressbar to update
 * * actor - (optional) person doing it
 * * rejections - (optional) list to add rejected items to
 *
 * @return TRUE if not done, FALSE if done
 */
/datum/object_system/storage/proc/mass_storage_dumping_handler(list/obj/item/things, atom/to_loc, datum/progressbar/progress, datum/event_args/actor/actor, trigger_on_found = TRUE)
	#warn impl

/**
 * what to drop
 */
/datum/object_system/storage/proc/mass_dumping_query()
	var/atom/indirection = real_contents_loc()
	return indirection.contents

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
	if(is_locked(actor))
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
	#warn check, force, etc
	show(actor.initiator)
	return TRUE

/datum/object_system/storage/proc/show(mob/viewer)
	if(viewer.active_storage == src)
		refresh_ui(viewer)
		return TRUE
	viewer.active_storage?.hide(viewer)
	viewer.active_storage = src
	RegisterSignal(viewer, COMSIG_MOVABLE_MOVED, PROC_REF(on_viewer_moved))
	create_ui(viewer)

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
	UnregisterSignal(viewer, COMSIG_MOVABLE_MOVED)

	cleanup_ui(viewer)

/**
 * Hooked into obj/Moved().
 */
/datum/object_system/storage/proc/on_parent_moved(atom/old_loc, forced)
	reconsider_mob_viewable()

/**
 * Comsig hooked into anything viewing us
 */
/datum/object_system/storage/proc/on_viewer_moved(datum/source, atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	reconsider_mob_viewable(source)

/datum/object_system/storage/proc/refresh(mob/viewer)
	if(isnull(viewer))
		for(var/mob/iterating as anything in ui_by_mob)
			show(iterating)
		return
	show(viewer)

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

/datum/object_system/storage/proc/cleanup_ui(mob/user)
	var/list/objects = ui_by_mob[user]
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
	var/uses_volumetric_ui = max_combined_volume && !ui_numerical_mode
	var/list/atom/movable/screen/storage/objects
	if(uses_volumetric_ui)
		objects += create_ui_volumetric_mode(user)
	else
		objects += create_ui_slot_mode(user)
	LAZYINITLIST(ui_by_mob)
	ui_by_mob[user] = objects
	user.client?.screen += objects

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
	var/rendering_width = min(max_items, STORAGE_UI_TILES_FOR_SCREEN_VIEW_X(view_x))
	// see if we need to process numerical display
	var/list/datum/storage_numerical_display/numerical_rendered = ui_numerical_mode && render_numerical_display()
	// process indirection
	var/atom/indirection = real_contents_loc()
	// compute count and rows
	var/item_count = isnull(numerical_rendered)? length(indirection.contents) : length(numerical_rendered)
	var/rows_needed = ceil(item_count / rendering_width)
	// prepare iteration
	var/current_row = 1
	var/current_column = 1
	// render boxes
	boxes.screen_loc = "[STORAGE_UI_START_TILE_X]:[STORAGE_UI_START_PIXEL_X],[STORAGE_UI_START_TILE_Y]:[STORAGE_UI_START_PIXEL_Y] to \
		[STORAGE_UI_START_TILE_X + rendering_width - 1]:[STORAGE_UI_START_PIXEL_X],[STORAGE_UI_START_TILE_Y + rows_needed - 1]:[STORAGE_UI_START_PIXEL_Y]"
	// render closer
	closer.screen_loc = "[STORAGE_UI_START_TILE_X + rendering_width]:[STORAGE_UI_START_PIXEL_X],[STORAGE_UI_START_TILE_Y]:[STORAGE_UI_START_PIXEL_Y]"
	// render items
	if(islist(numerical_rendered))
		for(var/datum/storage_numerical_display/display as anything in render_numerical_display())
			var/atom/movable/screen/storage/item/slot/renderer = new(null, display.rendered_object)
			. += renderer
			// render amount
			renderer.maptext = MAPTEXT("[display.amount]")
			// position
			renderer.screen_loc = "[STORAGE_UI_START_TILE_X + current_column - 1]:[STORAGE_UI_START_PIXEL_X],\
				[STORAGE_UI_START_TILE_Y + current_row - 1]:[STORAGE_UI_START_PIXEL_Y]"
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
			renderer.screen_loc = "[STORAGE_UI_START_TILE_X + current_column - 1]:[STORAGE_UI_START_PIXEL_X],\
				[STORAGE_UI_START_TILE_Y + current_row - 1]:[STORAGE_UI_START_PIXEL_Y]"
			// advance
			++current_column
			if(current_column > rendering_width)
				current_column = 1
				++current_row
				if(current_row > STORAGE_UI_MAX_ROWS)
					break

/datum/object_system/storage/proc/create_ui_volumetric_mode(mob/user)
	// guard against divide-by-0's
	if(!max_combined_volume || !cached_combined_volume)
		return create_ui_slot_mode(user)
	. = list()

	var/atom/movable/screen/storage/panel/volumetric/left = new
	. += left
	var/atom/movable/screen/storage/panel/volumetric/middle = new
	. += middle
	var/atom/movable/screen/storage/closer/closer = new
	. += closer
	// todo: clientless support is awful here
	var/list/decoded_view = decode_view_size(user.client?.view || world.view)
	var/view_x = decoded_view[1]
	var/rendering_width = STORAGE_UI_TILES_FOR_SCREEN_VIEW_X(view_x)
	#warn impl

/*

#define STORAGE_UI_START_TILE_X 4
#define STORAGE_UI_START_TILE_Y 2
#define STORAGE_UI_START_PIXEL_X 16
#define STORAGE_UI_START_PIXEL_Y 16
#define STORAGE_UI_TILES_FOR_SCREEN_VIEW_X(X) max(4, X - 8)
#define STORAGE_UI_MAX_ROWS 3

/// Size of volumetric box icon
#define VOLUMETRIC_STORAGE_BOX_ICON_SIZE 32
/// Size of EACH left/right border icon for volumetric boxes
#define VOLUMETRIC_STORAGE_BOX_BORDER_SIZE 1
/// Minimum pixels an item must have in volumetric scaled storage UI
#define VOLUMETRIC_STORAGE_MINIMUM_PIXELS_PER_ITEM 16
/// Maximum number of objects that will be allowed to be displayed using the volumetric display system. Arbitrary number to prevent server lockups.
#define VOLUMETRIC_STORAGE_MAX_ITEMS 128
/// How much padding to give between items
#define VOLUMETRIC_STORAGE_ITEM_PADDING 4
/// How much padding to give to edges
#define VOLUMETRIC_STORAGE_EDGE_PADDING 1
/// Standard pixel width ratio for volumetric storage; 1 volume converts into this many pixels.
#define VOLUMETRIC_STORAGE_STANDARD_PIXEL_RATIO 8

*/

/**
 * Stack storage
 *
 * Can handle both material and normal stacks.
 *
 * Uses max_items and only max_items for 'total combined'.
 */
/datum/object_system/storage/stack
	ui_numerical_mode = TRUE

	var/cached_combined_stack_amount = 0

/datum/object_system/storage/stack/rebuild_caches()
	. = ..()
	cached_combined_stack_amount = 0
	for(var/obj/item/stack/stack in real_contents_loc())
		cached_combined_volume += stack.amount

/datum/object_system/storage/stack/why_failed_insertion_limits(obj/item/candidate)
	if(!istype(candidate, /obj/item/stack))
		return "not a stack"
	if(cached_combined_stack_amount >= max_items)
		return "too many sheets"
	return null

/datum/object_system/storage/stack/check_insertion_limits(obj/item/candidate)
	return cached_combined_stack_amount < max_items

/datum/object_system/storage/stack/physically_insert_item(obj/item/inserting)
	#warn impl - split stack if necessary

/*
/datum/component/storage/concrete/stack/_insert_physical_item(obj/item/I, override = FALSE)
	if(!istype(I, /obj/item/stack))
		if(override)
			return ..()
		return FALSE
	var/atom/real_location = real_location()
	var/obj/item/stack/S = I
	var/can_insert = min(S.amount, remaining_space())
	if(!can_insert)
		return FALSE
	for(var/i in real_location)				//combine.
		if(QDELETED(I))
			return
		var/obj/item/stack/_S = i
		if(!istype(_S))
			continue
		if(_S.merge_type == S.merge_type)
			_S.add(can_insert)
			S.use(can_insert, TRUE)
			return TRUE
	I = S.split_stack(null, can_insert)
	return ..()
*/

/datum/object_system/storage/stack/physically_remove_item(obj/item/removing, atom/to_where)
	#warn impl - we make a new stack and swap

/*
/datum/component/storage/concrete/stack/remove_from_storage(obj/item/I, atom/new_location)
	var/atom/real_location = real_location()
	var/obj/item/stack/S = I
	if(!istype(S))
		return ..()
	if(S.amount > S.max_amount)
		var/overrun = S.amount - S.max_amount
		S.amount = S.max_amount
		var/obj/item/stack/temp = new S.type(real_location, overrun)
		handle_item_insertion(temp)
	return ..(S, new_location)
*/

/datum/object_system/storage/stack/render_numerical_display(list/obj/item/for_items)
	var/list/not_stack = list()
	. = list()
	var/list/types = list()
	for(var/obj/item/item in real_contents_loc())
		if(!istype(item, /obj/item/stack))
			not_stack += item
			continue
		var/obj/item/stack/stack = item
		var/datum/storage_numerical_display/display
		if(isnull(types[stack.type]))
			display = new /datum/storage_numerical_display(stack)
			types[stack.type] = display
			. += display
		else
			display = types[stack.type]
		display.amount += stack.amount
	return . + ..(not_stack)

/datum/object_system/storage/stock_parts
	ui_numerical_mode = TRUE

/datum/object_system/storage/stock_parts/mass_dumping_query()
	var/lowest_rating = INFINITY
	var/list/current_lowest = list()
	for(var/obj/item/item in real_contents_loc())
		var/rating = item.rped_rating()
		if(rating > lowest_rating)
			continue
		else if(rating == lowest_rating)
			current_lowest += item
		else
			current_lowest.len = 0
			current_lowest += item
			lowest_rating = rating
	if(lowest_rating != INFINITY)
		return current_lowest
	return ..()

//? Numerical Display Helper

/datum/storage_numerical_display
	var/obj/item/rendered_object
	var/amount

/datum/storage_numerical_display/New(obj/item/sample, amount = 0)
	src.rendered_object = sample
	src.amount = amount

/proc/cmp_storage_numerical_displays_name_asc(datum/storage_numerical_display/A, datum/storage_numerical_display/B)
	return sorttext(B.rendered_object.name, A.rendered_object.name) || sorttext(B.rendered_object.type, A.rendered_object.type)

//? Action

/datum/action/storage_gather_mode
	#warn impl all

//? Storage Screens

/atom/movable/screen/storage
	name = "storage"
	appearance_flags = APPEARANCE_UI | KEEP_TOGETHER
	plane = STORAGE_PLANE
	icon = 'icons/screen/hud/common/storage.dmi'

/atom/movable/screen/storage/closer
	name = "close"
	icon_state = "close"
	layer = STORAGE_LAYER_CONTAINER

/atom/movable/screen/storage/closer/Click()
	usr.active_storage?.hide(usr)

/atom/movable/screen/storage/item
	layer = STORAGE_LAYER_ITEM_INACTIVE
	var/obj/item/item

/atom/movable/screen/storage/item/New(newloc, obj/item/from_item)
	item = from_item
	bind(from_item)
	return ..()

/atom/movable/screen/storage/item/Destroy()
	item = null
	return ..()

/atom/movable/screen/storage/item/MouseEntered(location, control, params)
	. = ..()
	layer = STORAGE_LAYER_ITEM_ACTIVE

/atom/movable/screen/storage/item/MouseExited(location, control, params)
	. = ..()
	layer = STORAGE_LAYER_ITEM_INACTIVE

/atom/movable/screen/storage/item/proc/item_mouse_enter(mob/user)
	layer = STORAGE_LAYER_ITEM_ACTIVE

/atom/movable/screen/storage/item/proc/item_mouse_exit(mob/user)
	layer = STORAGE_LAYER_ITEM_INACTIVE

/atom/movable/screen/storage/item/MouseDrop(atom/over_object, src_location, over_location, src_control, over_control, params)
	return item.MouseDrop(arglist(args))

/atom/movable/screen/storage/item/Click(location, control, params)
	return item.Click(arglist(args))

/atom/movable/screen/storage/item/DblClick(location, control, params)
	return item.DblClick(arglist(args))

/atom/movable/screen/storage/item/proc/bind(obj/item/item)
	vis_contents += item
	name = item.name
	desc = item.desc
	RegisterSignal(item, COMSIG_ITEM_MOUSE_ENTERED, PROC_REF(item_mouse_enter))
	RegisterSignal(item, COMSIG_ITEM_MOUSE_EXITED, PROC_REF(item_mouse_exit))

/atom/movable/screen/storage/panel
	layer = STORAGE_LAYER_CONTAINER

/atom/movable/screen/storage/panel/Click()
	var/obj/item/held = usr.get_active_held_item()
	if(isnull(held))
		return
	usr.active_storage?.auto_handle_interacted_insertion(held)

/atom/movable/screen/storage/item/slot
	icon_state = "nothing"
	mouse_opacity = MOUSE_OPACITY_OPAQUE

/atom/movable/screen/storage/panel/slot

/atom/movable/screen/storage/panel/slot/boxes
	icon_state = "block"

/atom/movable/screen/storage/item/volumetric
	icon_state = "nothing"

/**
 * we are centered.
 */
/atom/movable/screen/storage/item/volumetric/proc/set_pixel_width(width)
	overlays.len = 0
	var/image/left = image(icon, icon_state = "stored_left", pixel_x = ((width / 2) - VOLUMETRIC_STORAGE_BOX_BORDER_SIZE - (WORLD_ICON_SIZE - VOLUMETRIC_STORAGE_BOX_BORDER_SIZE)))
	var/image/right = image(icon, icon_state = "stored_right", pixel_x = -((width / 2) - VOLUMETRIC_STORAGE_BOX_BORDER_SIZE - (WORLD_ICON_SIZE - VOLUMETRIC_STORAGE_BOX_BORDER_SIZE)))
	var/image/middle = image(icon, icon_state = "stored_middle")
	middle.transform = matrix((pixels - (VOLUMETRIC_STORAGE_BOX_BORDER_SIZE * 2)) / VOLUMETRIC_STORAGE_BOX_ICON_SIZE, 0, 0, 0, 1, 0)
	overlays = list(left, middle, right)

/atom/movable/screen/storage/panel/volumetric

/atom/movable/screen/storage/panel/volumetric/left
	icon_state = "storage_left"

/atom/movable/screen/storage/panel/volumetric/middle
	icon_state = "storage_middle"

/atom/movable/screen/storage/panel/volumetric/right
	icon_state = "storage_right"

//? Lazy wrappers for init

/obj/proc/init_storage(path = /datum/object_system/storage)
	RETURN_TYPE(/datum/object_system/storage)
	ASSERT(isnull(obj_storage))
	obj_storage = new path(src)
	// get all items inside / registered
	for(var/obj/item/item in contents)
		obj_storage.on_item_entered(item)
	return obj_storage
