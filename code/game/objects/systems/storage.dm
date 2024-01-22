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

	//* Limits

	/// if set, limit to a certain volume
	var/max_combined_volume
	/// if set, allow only a certain amount of items
	var/max_items
	/// if set, max weight class we can hold
	var/max_single_weight_class
	/// if set, max combined weight class of all containing items we can hold
	var/max_combined_weight_class

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
	/// otherwise, using this is going to be GC failure hell from vis contents and rendering.
	var/atom/dangerously_redirect_contents_calls

	//* State Caches

	/// cached combined w class
	var/tmp/cached_combined_weight_class
	/// cached combined volume
	var/tmp/cached_combined_volume

	//* UIs *//
	
	/// lazy list of UIs open; mob ref = list(ui objects)
	var/list/ui_by_mob

/datum/object_system/storage/New()
	// we use typelists to detect if it's been init'd
	if(!is_typelist(insertion_whitelist_typecache))
		insertion_whitelist_typecache = cached_typecacheof(insertion_whitelist_typecache)
	if(!is_typelist(insertion_blacklist_typecache))
		insertion_blacklist_typecache = cached_typecacheof(insertion_blacklist_typecache)
	if(!is_typelist(insertion_allow_typecache))
		insertion_allow_typecache = cached_typecacheof(insertion_allow_typecache)
	rebuild_caches()

//* Access *//

/**
 * do not mutate returned list
 */
/datum/object_system/storage/proc/dangerously_accessible_items_immutable(random_access = TRUE)
	var/atom/redirection = real_contents_loc()
	if(random_access)
		if(limited_random_access_stack_amount)
			var/contents_length = length(redirection.contents)
			if(limited_random_access_stack_bottom_up)
				return redirection.contents.Copy(1, min(contents_length + 1, limited_random_access_stack_bottom_up + 1))
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
			if(limited_random_access_stack_bottom_up)
				return redirection.contents.Copy(1, min(contents_length + 1, limited_random_access_stack_bottom_up + 1))
			else
				return redirection.contents.Copy(max(1, contents_length - limited_random_access_stack_amount + 1), contents_length + 1)
	return redirection.contents.Copy()

/datum/object_system/storage/proc/recursively_return_inventory(list/returning = list())
	var/atom/redirection = real_contents_loc()
	for(var/obj/item/iterating in redirection)
		returning += iterating
		iterating.obj_storage?.recursively_return_inventory(returning)
	return returning

/**
 * iterate through what's considered inside
 */
/datum/object_system/storage/proc/contents()
	. = list()
	for(var/obj/item/inside in real_contents_loc())
		. += inside

/datum/object_system/storage/proc/accessible_by_mob(mob/user)
	#warn impl

//* Caches *//

/datum/object_system/storage/proc/rebuild_caches()
	cached_combined_volume = 0
	cached_combined_weight_class = 0
	for(var/obj/item/item in real_contents_loc())
		cached_combined_volume += item.get_weight_volume()
		cached_combined_weight_class += item.get_weight_class()
	
//* Checks *//

/datum/object_system/storage/proc/remaining_volume()
	return isnull(max_combined_volume)? INFINITY : (max_combined_volume - cached_combined_volume)

/datum/object_system/storage/proc/remaining_weight_class()
	return isnull(max_combined_weight_class)? INFINITY : (max_combined_weight_class - cached_combined_weight_class)

/datum/object_system/storage/proc/remaining_items()
	var/atom/indirection = real_contents_loc()
	return isnull(max_items)? INFINITY : (max_items - length(indirection.contents))

//* Hooks*//

/**
 * Called by our object when an item exits us
 */
/datum/object_system/storage/proc/on_item_exited(obj/item/exiting)
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
	if(isnull(types))
		src.insertion_whitelist_typecache = null
		return
	src.insertion_whitelist_typecache = cached_typecacheof(types)

/datum/object_system/storage/proc/set_insertion_blacklist(list/types)
	if(isnull(types))
		src.insertion_blacklist_typecache = null
		return
	src.insertion_blacklist_typecache = cached_typecacheof(types)

/datum/object_system/storage/proc/set_insertion_allow(list/types)
	if(isnull(types))
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
/datum/object_system/storage/proc/auto_handle_interacted_insertion(obj/item/inserting, datum/event_args/actor/actor)
	#warn impl

/datum/object_system/storage/proc/try_insert(obj/item/inserting, datum/event_args/actor/actor)
	#warn impl

/datum/object_system/storage/proc/insert(obj/item/inserting, datum/event_args/actor/actor)
	#warn impl

/**
 * handle moving an item in
 * 
 * we can assume this proc will do potentially literally anything with the item, so..
 */
/datum/object_system/storage/proc/physically_insert_entity(obj/item/inserting)
	inserting.forceMove(real_contents_loc())

//* Limits *//

/datum/object_system/storage/proc/check_insertion_limits(obj/item/candidate)
	if(!isnull(max_items))
		#warn impl
	if(!isnull(max_combined_volume) && (cached_combined_volume + candidate.get_weight_volume() > max_combined_volume))
		return FALSE
	var/their_weight_class = candidate.get_weight_class()
	if(!isnull(max_single_weight_class) && (their_weight_class > max_single_weight_class))
		return FALSE
	if(!isnull(max_combined_weight_class) && (cached_combined_weight_class + their_weight_class > max_combined_weight_class))
		return FALSE
	return TRUE

/datum/object_system/storage/proc/why_failed_insertion_limits(obj/item/candidate)
	if(!isnull(max_items))
		#warn impl
	if(!isnull(max_combined_volume) && (cached_combined_volume + candidate.get_weight_volume() > max_combined_volume))
		return "insufficient volume"
	var/their_weight_class = candidate.get_weight_class()
	if(!isnull(max_single_weight_class) && (their_weight_class > max_single_weight_class))
		return "too large"
	if(!isnull(max_combined_weight_class) && (cached_combined_weight_class + their_weight_class > max_combined_weight_class))
		return "insufficient space"
	return null

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

/datum/object_system/storage/proc/interacted_mass_storage_transfer(datum/event_args/actor/actor, datum/object_system/storage/to_storage)
	#warn impl

/datum/object_system/storage/proc/interacted_mass_pickup(datum/event_args/actor/actor, atom/from_loc)
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
 * drop everything at
 */
/datum/object_system/storage/proc/drop_everything_at(atom/where)
	for(var/obj/item/I in real_contents_loc())
		I.forceMove(where)

//* UI *//

/**
 * @return TRUE if we did something (to interrupt clickchain)
 */
/datum/object_system/storage/proc/auto_handle_open_interaction(datum/event_args/actor/actor)
	if(check_on_found_hooks(actor))
		return TRUE
	#warn impl

/datum/object_system/storage/proc/show(mob/viewer, force)
	#warn impl

/**
 * if user not specified, it is 'all'.
 */
/datum/object_system/storage/proc/hide(mob/viewer)
	if(isnull(viewer))
		for(var/mob/iterating as anything in ui_by_mob)
			hide(iterating)
		return
	#warn impl

/datum/object_system/storage/proc/refresh(mob/viewer, force)
	if(isnull(viewer))
		for(var/mob/iterating as anything in ui_by_mob)
			show(iterating, force)
		return
	show(viewer, force)

/**
 * Stack storage
 * 
 * Can handle both material and normal stacks.
 */
/datum/object_system/storage/stack

#warn scream


//? Lazy wrappers for init

/obj/proc/init_storage(path = /datum/object_system/storage)
	RETURN_TYPE(/datum/object_system/storage)
	ASSERT(isnull(obj_storage))
	obj_storage = new path(src)
	return obj_storage
