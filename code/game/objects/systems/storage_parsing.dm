

// External storage-related logic:
// /mob/proc/ClickOn() in /_onclick/click.dm - clicking items in storages
// /mob/living/Move() in /modules/mob/living/living.dm - hiding storage boxes on mob movement

/datum/component/storage
	var/silent = FALSE								//whether this makes a message when things are put in.
	var/rustle_sound = TRUE							//play rustle sound on interact.
	var/quickdraw = FALSE							//altclick interact
	var/datum/action/item_action/storage_gather_mode/modeswitch_action

	//Screen variables: Do not mess with these vars unless you know what you're doing. They're not defines so storage that isn't in the same location can be supported in the future.
	var/screen_max_columns = 7							//These two determine maximum screen sizes.
	var/screen_max_rows = INFINITY
	var/screen_pixel_x = 16								//These two are pixel values for screen loc of boxes and closer
	var/screen_pixel_y = 16
	var/screen_start_x = 4								//These two are where the storage starts being rendered, screen_loc wise.
	var/screen_start_y = 2
	//End

/datum/component/storage/Initialize(datum/component/storage/concrete/master)
	update_actions()

/datum/component/storage/proc/update_actions()
	QDEL_NULL(modeswitch_action)
	if(!isitem(parent) || !allow_quick_gather)
		return
	var/obj/item/I = parent
	modeswitch_action = new(I)
	RegisterSignal(modeswitch_action, COMSIG_ACTION_TRIGGER, .proc/action_trigger)
	if(I.obj_flags & IN_INVENTORY)
		var/mob/M = I.loc
		if(!istype(M))
			return
		modeswitch_action.Grant(M)

/datum/component/storage/proc/canreach_react(datum/source, list/next)
	var/datum/component/storage/concrete/master = master()
	if(!master)
		return
	. = COMPONENT_BLOCK_REACH
	next += master.parent
	for(var/i in master.slaves)
		var/datum/component/storage/slave = i
		next += slave.parent

/datum/component/storage/proc/attack_self(datum/source, mob/M)
	if(check_locked(source, M, TRUE))
		return FALSE
	if((M.get_active_held_item() == parent) && allow_quick_empty)
		quick_empty(M)

/datum/component/storage/proc/preattack_intercept(datum/source, obj/O, mob/M, params)
	if(!isitem(O) || !click_gather || SEND_SIGNAL(O, COMSIG_CONTAINS_STORAGE))
		return FALSE
	. = COMPONENT_NO_ATTACK
	if(check_locked(source, M, TRUE))
		return FALSE
	var/atom/A = parent
	var/obj/item/I = O
	if(collection_mode == COLLECT_ONE)
		if(can_be_inserted(I, null, M))
			handle_item_insertion(I, null, M)
			A.do_squish()
		return
	if(!isturf(I.loc))
		return
	var/list/things = I.loc.contents.Copy()
	if(collection_mode == COLLECT_SAME)
		things = typecache_filter_list(things, typecacheof(I.type))
	var/len = length(things)
	if(!len)
		to_chat(M, "<span class='notice'>You failed to pick up anything with [parent].</span>")
		return
	var/datum/progressbar/progress = new(M, len, I.loc)
	var/list/rejections = list()
	while(do_after(M, 10, TRUE, parent, FALSE, CALLBACK(src, .proc/handle_mass_pickup, things, I.loc, rejections, progress)))
		stoplag(1)
	qdel(progress)
	to_chat(M, "<span class='notice'>You put everything you could [insert_preposition] [parent].</span>")
	A.do_squish(1.4, 0.4)

/datum/component/storage/proc/handle_mass_item_insertion(list/things, datum/component/storage/src_object, mob/user, datum/progressbar/progress)
	var/atom/source_real_location = src_object.real_location()
	for(var/obj/item/I in things)
		things -= I
		if(I.loc != source_real_location)
			continue
		if(user.active_storage != src_object)
			if(I.on_found(user))
				break
		if(can_be_inserted(I,FALSE,user))
			handle_item_insertion(I, TRUE, user)
		if (TICK_CHECK)
			progress.update(progress.goal - things.len)
			return TRUE

	progress.update(progress.goal - things.len)
	return FALSE

/datum/component/storage/proc/handle_mass_pickup(list/things, atom/thing_loc, list/rejections, datum/progressbar/progress)
	var/atom/real_location = real_location()
	for(var/obj/item/I in things)
		things -= I
		if(I.loc != thing_loc)
			continue
		if(I.type in rejections) // To limit bag spamming: any given type only complains once
			continue
		if(!can_be_inserted(I, stop_messages = TRUE))	// Note can_be_inserted still makes noise when the answer is no
			if(real_location.contents.len >= max_items)
				break
			rejections += I.type	// therefore full bags are still a little spammy
			continue

		handle_item_insertion(I, TRUE)	//The TRUE stops the "You put the [parent] into [S]" insertion message from being displayed.

		if (TICK_CHECK)
			progress.update(progress.goal - things.len)
			return TRUE

	progress.update(progress.goal - things.len)
	return FALSE

/datum/component/storage/proc/quick_empty(mob/M)
	var/atom/A = parent
	if(!M.canUseStorage() || !A.Adjacent(M) || M.incapacitated())
		return
	if(check_locked(null, M, TRUE))
		return FALSE
	A.add_fingerprint(M)
	to_chat(M, "<span class='notice'>You start dumping out [parent].</span>")
	var/turf/T = get_turf(A)
	var/list/things = contents()
	var/datum/progressbar/progress = new(M, length(things), T)
	while (do_after(M, 10, TRUE, T, FALSE, CALLBACK(src, .proc/mass_remove_from_storage, T, things, progress, TRUE, M)))
		stoplag(1)
	qdel(progress)
	A.do_squish(0.8, 1.2)

/datum/component/storage/proc/mass_remove_from_storage(atom/target, list/things, datum/progressbar/progress, trigger_on_found = TRUE, mob/user)
	var/atom/real_location = real_location()
	for(var/obj/item/I in things)
		things -= I
		if(I.loc != real_location)
			continue
		if(trigger_on_found && user && (user.active_storage != src) && I.on_found(user))
			return FALSE
		remove_from_storage(I, target)
		if(TICK_CHECK)
			progress.update(progress.goal - length(things))
			return TRUE
	progress.update(progress.goal - length(things))
	return FALSE

/datum/component/storage/proc/do_quick_empty(atom/_target)
	if(!_target)
		_target = get_turf(parent)
	if(usr)
		ui_hide(usr)
	var/list/contents = contents()
	var/atom/real_location = real_location()
	for(var/obj/item/I in contents)
		if(I.loc != real_location)
			continue
		remove_from_storage(I, _target)
	return TRUE
			
//Resets something that is being removed from storage.
/datum/component/storage/proc/_removal_reset(atom/movable/thing)
	if(!istype(thing))
		return FALSE
	var/datum/component/storage/concrete/master = master()
	if(!istype(master))
		return FALSE
	return master._removal_reset(thing)

/datum/component/storage/proc/_remove_and_refresh(datum/source, atom/movable/thing)
	_removal_reset(thing)		// THIS NEEDS TO HAPPEN AFTER SO LAYERING DOESN'T BREAK!
	refresh_mob_views()

//Call this proc to handle the removal of an item from the storage item. The item will be moved to the new_location target, if that is null it's being deleted
/datum/component/storage/proc/remove_from_storage(atom/movable/AM, atom/new_location)
	if(!istype(AM))
		return FALSE
	var/datum/component/storage/concrete/master = master()
	if(!istype(master))
		return FALSE
	return master.remove_from_storage(AM, new_location)

//Tries to dump content
/datum/component/storage/proc/dump_content_at(atom/dest_object, mob/M)
	var/atom/A = parent
	var/atom/dump_destination = dest_object.get_dumping_location()
	if(A.Adjacent(M) && dump_destination && M.Adjacent(dump_destination))
		if(check_locked(null, M, TRUE))
			return FALSE
		if(dump_destination.storage_contents_dump_act(src, M))
			playsound(A, "rustle", 50, 1, -5)
			A.do_squish(0.8, 1.2)
			return TRUE
	return FALSE

//This proc is called when you want to place an item into the storage item.
/datum/component/storage/proc/attackby(datum/source, obj/item/I, mob/M, params)
	if(istype(I, /obj/item/hand_labeler))
		var/obj/item/hand_labeler/labeler = I
		if(labeler.mode)
			return FALSE
	. = TRUE //no afterattack
	if(iscyborg(M))
		return
	if(!can_be_inserted(I, FALSE, M))
		var/atom/real_location = real_location()
		if(real_location.contents.len >= max_items) //don't use items on the backpack if they don't fit
			return TRUE
		return FALSE
	handle_item_insertion(I, FALSE, M)
	var/atom/A = parent
	A.do_squish()

/datum/component/storage/proc/mousedrop_onto(datum/source, atom/over_object, mob/M)
	SIGNAL_HANDLER

	set waitfor = FALSE
	. = COMPONENT_NO_MOUSEDROP
	if(!ismob(M))
		return
	if(!over_object)
		return
	if(ismecha(M.loc)) // stops inventory actions in a mech
		return
	if(M.incapacitated() || !M.canUseStorage())
		return
	var/atom/A = parent
	A.add_fingerprint(M)
	// this must come before the screen objects only block, dunno why it wasn't before
	if(over_object == M)
		user_show_to_mob(M, trigger_on_found = TRUE)
	if(isrevenant(M))
		INVOKE_ASYNC(GLOBAL_PROC, .proc/RevenantThrow, over_object, M, source)
		return
	if(!istype(over_object, /atom/movable/screen))
		INVOKE_ASYNC(src, .proc/dump_content_at, over_object, M)
		return
	if(A.loc != M)
		return
	playsound(A, "rustle", 50, TRUE, -5)
	A.do_jiggle()
	if(istype(over_object, /atom/movable/screen/inventory/hand))
		var/atom/movable/screen/inventory/hand/H = over_object
		M.putItemFromInventoryInHandIfPossible(A, H.held_index)
		return
	A.add_fingerprint(M)

/datum/component/storage/proc/user_show_to_mob(mob/M, force = FALSE, trigger_on_found = FALSE)
	var/atom/A = parent
	if(!istype(M))
		return FALSE
	A.add_fingerprint(M)
	if(!force && (check_locked(null, M) || !M.CanReach(parent, view_only = TRUE)))
		return FALSE
	if(trigger_on_found)
		if(check_on_found(M))
			return
	ui_show(M)
w
/datum/component/storage/proc/mousedrop_receive(datum/source, atom/movable/O, mob/M)
	if(isitem(O))
		var/obj/item/I = O
		if(iscarbon(M) || isdrone(M))
			var/mob/living/L = M
			if(!L.incapacitated() && I == L.get_active_held_item())
				if(!SEND_SIGNAL(I, COMSIG_CONTAINS_STORAGE) && can_be_inserted(I, FALSE))	//If it has storage it should be trying to dump, not insert.
					handle_item_insertion(I, FALSE, L)
					var/atom/A = parent
					A.do_squish()

//This proc return 1 if the item can be picked up and 0 if it can't.
//Set the stop_messages to stop it from printing messages
/datum/component/storage/proc/can_be_inserted(obj/item/I, stop_messages = FALSE, mob/M)
	if(!istype(I) || (I.item_flags & ABSTRACT))
		return FALSE //Not an item
	if(I == parent)
		return FALSE	//no paradoxes for you
	var/atom/real_location = real_location()
	var/atom/host = parent
	if(real_location == I.loc)
		return FALSE //Means the item is already in the storage item
	if(check_locked(null, M, !stop_messages))
		if(M && !stop_messages)
			host.add_fingerprint(M)
		return FALSE
	/////////////////
	if(isitem(host))
		var/obj/item/IP = host
		var/datum/component/storage/STR_I = I.GetComponent(/datum/component/storage)
		if((I.w_class >= IP.w_class) && STR_I && !allow_big_nesting)
			if(!stop_messages)
				to_chat(M, "<span class='warning'>[IP] cannot hold [I] as it's a storage item of the same size!</span>")
			return FALSE //To prevent the stacking of same sized storage items.
	if(HAS_TRAIT(I, TRAIT_NODROP)) //SHOULD be handled in unEquip, but better safe than sorry.
		to_chat(M, "<span class='warning'>\the [I] is stuck to your hand, you can't put it in \the [host]!</span>")
		return FALSE
	var/datum/component/storage/concrete/master = master()
	if(!istype(master))
		return FALSE
	return master.slave_can_insert_object(src, I, stop_messages, M)

//This proc handles items being inserted. It does not perform any checks of whether an item can or can't be inserted. That's done by can_be_inserted()
//The stop_warning parameter will stop the insertion message from being displayed. It is intended for cases where you are inserting multiple items at once,
//such as when picking up all the items on a tile with one click.
/datum/component/storage/proc/handle_item_insertion(obj/item/I, prevent_warning = FALSE, mob/M, datum/component/storage/remote)
	var/atom/parent = src.parent
	var/datum/component/storage/concrete/master = master()
	if(!istype(master))
		return FALSE
	if(silent)
		prevent_warning = TRUE
	if(M)
		parent.add_fingerprint(M)
	. = master.handle_item_insertion_from_slave(src, I, prevent_warning, M)

/datum/component/storage/proc/mob_item_insertion_feedback(mob/user, mob/M, obj/item/I, override = FALSE)
	if(silent && !override)
		return
	if(rustle_sound)
		playsound(parent, "rustle", 50, 1, -5)
	to_chat(user, "<span class='notice'>You put [I] [insert_preposition]to [parent].</span>")
	for(var/mob/viewing in fov_viewers(world.view, user)-M)
		if(in_range(M, viewing)) //If someone is standing close enough, they can tell what it is...
			viewing.show_message("<span class='notice'>[M] puts [I] [insert_preposition]to [parent].</span>", MSG_VISUAL)
		else if(I && I.w_class >= 3) //Otherwise they can only see large or normal items from a distance...
			viewing.show_message("<span class='notice'>[M] puts [I] [insert_preposition]to [parent].</span>", MSG_VISUAL)

/datum/component/storage/proc/signal_insertion_attempt(datum/source, obj/item/I, mob/M, silent = FALSE, force = FALSE)
	if((!force && !can_be_inserted(I, TRUE, M)) || (I == parent))
		return FALSE
	return handle_item_insertion(I, silent, M)

/datum/component/storage/proc/signal_can_insert(datum/source, obj/item/I, mob/M, silent = FALSE)
	return can_be_inserted(I, silent, M)

/datum/component/storage/proc/show_to_ghost(datum/source, mob/dead/observer/M)
	return user_show_to_mob(M, TRUE)

/datum/component/storage/proc/signal_show_attempt(datum/source, mob/showto, force = FALSE, trigger_on_found = TRUE)
	return user_show_to_mob(showto, force, trigger_on_found = trigger_on_found)

/datum/component/storage/proc/on_check()
	return TRUE

/datum/component/storage/proc/check_locked(datum/source, mob/user, message = FALSE)
	. = locked
	if(message && . && user)
		to_chat(user, "<span class='warning'>[parent] seems to be locked!</span>")

/datum/component/storage/proc/signal_take_type(datum/source, type, atom/destination, amount = INFINITY, check_adjacent = FALSE, force = FALSE, mob/user, list/inserted)
	if(!force)
		if(check_adjacent)
			if(!user || !user.CanReach(destination) || !user.CanReach(parent))
				return FALSE
	var/list/taking = typecache_filter_list(contents(), typecacheof(type))
	if(taking.len > amount)
		taking.len = amount
	if(inserted)			//duplicated code for performance, don't bother checking retval/checking for list every item.
		for(var/i in taking)
			if(remove_from_storage(i, destination))
				inserted |= i
	else
		for(var/i in taking)
			remove_from_storage(i, destination)
	return TRUE

/datum/component/storage/proc/signal_fill_type(datum/source, type, amount = 20, force = FALSE)
	var/atom/real_location = real_location()
	if(!force)
		amount = min(remaining_space_items(), amount)
	for(var/i in 1 to amount)
		handle_item_insertion(new type(real_location), TRUE)
		CHECK_TICK
	return TRUE

/datum/component/storage/proc/on_attack_hand(datum/source, mob/user)
	var/atom/A = parent
	if(!attack_hand_interact)
		return
	if(user.active_storage == src && A.loc == user) //if you're already looking inside the storage item
		user.active_storage.close(user)
		close(user)
		. = COMPONENT_NO_ATTACK_HAND
		return

	if(rustle_sound)
		playsound(A, "rustle", 50, 1, -5)

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.l_store == A && !H.get_active_held_item())	//Prevents opening if it's in a pocket.
			. = COMPONENT_NO_ATTACK_HAND
			H.put_in_hands(A)
			H.l_store = null
			return
		if(H.r_store == A && !H.get_active_held_item())
			. = COMPONENT_NO_ATTACK_HAND
			H.put_in_hands(A)
			H.r_store = null
			return

	if(A.loc == user)
		. = COMPONENT_NO_ATTACK_HAND
		if(!check_locked(source, user, TRUE))
			user_show_to_mob(user, trigger_on_found = TRUE)
			A.do_jiggle()

/datum/component/storage/proc/signal_on_pickup(datum/source, mob/user)
	var/atom/A = parent
	update_actions()
	for(var/mob/M in range(1, A))
		if(M.active_storage == src)
			close(M)

/datum/component/storage/proc/signal_take_obj(datum/source, atom/movable/AM, new_loc, force = FALSE)
	if(!(AM in real_location()))
		return FALSE
	return remove_from_storage(AM, new_loc)

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

/datum/component/storage/proc/action_trigger(datum/action/source, obj/target)
	gather_mode_switch(source.owner)
	return COMPONENT_ACTION_BLOCK_TRIGGER

/datum/component/storage/proc/gather_mode_switch(mob/user)
	collection_mode = (collection_mode+1)%3
	switch(collection_mode)
		if(COLLECT_SAME)
			to_chat(user, "[parent] now picks up all items of a single type at once.")
		if(COLLECT_EVERYTHING)
			to_chat(user, "[parent] now picks up all items in a tile at once.")
		if(COLLECT_ONE)
			to_chat(user, "[parent] now picks up one item at a time.")

/**
  * Generates a list of numbered_display datums for the numerical display system.
  */
/datum/component/storage/proc/_process_numerical_display()
	. = list()
	for(var/obj/item/I in accessible_items())
		if(QDELETED(I))
			continue
		if(!.[I.type])
			.[I.type] = new /datum/numbered_display(I, 1, src)
		else
			var/datum/numbered_display/ND = .[I.type]
			ND.number++
	. = sortTim(., /proc/cmp_numbered_displays_name_asc, associative = TRUE)

/**
  * Orients all objects in legacy mode, and returns the objects to show to the user.
  */
/datum/component/storage/proc/orient2hud_legacy(mob/user, maxcolumns)
	. = list()
	var/list/accessible_contents = accessible_items()
	var/adjusted_contents = length(accessible_contents)
	var/atom/movable/screen/storage/close/ui_close
	var/atom/movable/screen/storage/boxes/ui_boxes

	//Numbered contents display
	var/list/datum/numbered_display/numbered_contents
	if(display_numerical_stacking)
		numbered_contents = _process_numerical_display()
		adjusted_contents = numbered_contents.len

	var/columns = clamp(max_items, 1, maxcolumns ? maxcolumns : screen_max_columns)
	var/rows = clamp(CEILING(adjusted_contents / columns, 1), 1, screen_max_rows)

	// First, boxes.
	ui_boxes = get_ui_boxes()
	ui_boxes.screen_loc = "[screen_start_x]:[screen_pixel_x],[screen_start_y]:[screen_pixel_y] to [screen_start_x+columns-1]:[screen_pixel_x],[screen_start_y+rows-1]:[screen_pixel_y]"
	. += ui_boxes
	// Then, closer.
	ui_close = get_ui_close()
	ui_close.screen_loc = "[screen_start_x + columns]:[screen_pixel_x],[screen_start_y]:[screen_pixel_y]"
	. += ui_close
	// Then orient the actual items.
	var/cx = screen_start_x
	var/cy = screen_start_y
	if(islist(numbered_contents))
		for(var/type in numbered_contents)
			var/datum/numbered_display/ND = numbered_contents[type]
			ND.sample_object.mouse_opacity = MOUSE_OPACITY_OPAQUE
			ND.sample_object.screen_loc = "[cx]:[screen_pixel_x],[cy]:[screen_pixel_y]"
			ND.sample_object.maptext = "<font color='white'>[(ND.number > 1)? "[ND.number]" : ""]</font>"
			ND.sample_object.layer = ABOVE_HUD_LAYER
			ND.sample_object.plane = ABOVE_HUD_PLANE
			. += ND.sample_object
			cx++
			if(cx - screen_start_x >= columns)
				cx = screen_start_x
				cy++
				if(cy - screen_start_y >= rows)
					break
	else
		for(var/obj/O in accessible_items())
			if(QDELETED(O))
				continue
			var/atom/movable/screen/storage/item_holder/D = new(null, src, O)
			D.mouse_opacity = MOUSE_OPACITY_OPAQUE //This is here so storage items that spawn with contents correctly have the "click around item to equip"
			D.screen_loc = "[cx]:[screen_pixel_x],[cy]:[screen_pixel_y]"
			O.maptext = ""
			O.layer = ABOVE_HUD_LAYER
			O.plane = ABOVE_HUD_PLANE
			. += D
			cx++
			if(cx - screen_start_x >= columns)
				cx = screen_start_x
				cy++
				if(cy - screen_start_y >= rows)
					break

/**
  * Orients all objects in .. volumetric mode. Does not support numerical display!
  */
/datum/component/storage/proc/orient2hud_volumetric(mob/user, maxcolumns)
	. = list()
	var/atom/movable/screen/storage/left/ui_left
	var/atom/movable/screen/storage/continuous/ui_continuous
	var/atom/movable/screen/storage/close/ui_close

	// Generate ui_item_blocks for missing ones and render+orient.
	var/list/atom/contents = accessible_items()
	// our volume
	var/our_volume = get_max_volume()
	var/horizontal_pixels = (maxcolumns * world.icon_size) - (VOLUMETRIC_STORAGE_EDGE_PADDING * 2)
	var/max_horizontal_pixels = horizontal_pixels * screen_max_rows
	// sigh loopmania time
	var/used = 0
	// define outside for performance
	var/volume
	var/list/volume_by_item = list()
	var/list/percentage_by_item = list()
	for(var/obj/item/I in contents)
		if(QDELETED(I))
			continue
		volume = I.get_w_volume()
		used += volume
		volume_by_item[I] = volume
		percentage_by_item[I] = volume / get_max_volume()
	var/padding_pixels = ((length(percentage_by_item) - 1) * VOLUMETRIC_STORAGE_ITEM_PADDING) + VOLUMETRIC_STORAGE_EDGE_PADDING * 2
	var/min_pixels = (MINIMUM_PIXELS_PER_ITEM * length(percentage_by_item)) + padding_pixels
	// do the check for fallback for when someone has too much gamer gear
	if((min_pixels) > (max_horizontal_pixels + 4))	// 4 pixel grace zone
		to_chat(user, "<span class='warning'>[parent] was showed to you in legacy mode due to your items overrunning the three row limit! Consider not carrying too much or bugging a maintainer to raise this limit!</span>")
		return orient2hud_legacy(user, maxcolumns)
	// after this point we are sure we can somehow fit all items into our max number of rows.

	// determine rows
	var/rows = clamp(CEILING(min_pixels / horizontal_pixels, 1), 1, screen_max_rows)

	var/overrun = FALSE
	if(used > our_volume)
		// congratulations we are now in overrun mode. everything will be crammed to minimum storage pixels.
		to_chat(user, "<span class='warning'>[parent] rendered in overrun mode due to more items inside than the maximum volume supports.</span>")
		overrun = TRUE

	// how much we are using
	var/using_horizontal_pixels = horizontal_pixels * rows

	// item padding
	using_horizontal_pixels -= padding_pixels

	// define outside for marginal performance boost
	var/obj/item/I
	// start at this pixel from screen_start_x.
	var/current_pixel = VOLUMETRIC_STORAGE_EDGE_PADDING
	var/first = TRUE
	var/row = 1

	for(var/i in percentage_by_item)
		I = i
		var/percent = percentage_by_item[I]
		var/atom/movable/screen/storage/volumetric_box/center/B = new /atom/movable/screen/storage/volumetric_box/center(null, src, I)
		var/pixels_to_use = overrun? MINIMUM_PIXELS_PER_ITEM : max(using_horizontal_pixels * percent, MINIMUM_PIXELS_PER_ITEM)
		var/addrow = FALSE
		if(CEILING(pixels_to_use, 1) >= FLOOR(horizontal_pixels - current_pixel - VOLUMETRIC_STORAGE_EDGE_PADDING, 1))
			pixels_to_use = horizontal_pixels - current_pixel - VOLUMETRIC_STORAGE_EDGE_PADDING
			addrow = TRUE

		// now that we have pixels_to_use, place our thing and add it to the returned list.
		B.screen_loc = "[screen_start_x]:[round(current_pixel + (pixels_to_use * 0.5) + (first? 0 : VOLUMETRIC_STORAGE_ITEM_PADDING), 1)],[screen_start_y+row-1]:[screen_pixel_y]"
		// add the used pixels to pixel after we place the object
		current_pixel += pixels_to_use + (first? 0 : VOLUMETRIC_STORAGE_ITEM_PADDING)
		first = FALSE		//apply padding to everything after this

		// set various things
		B.set_pixel_size(pixels_to_use)
		B.name = I.name

		// finally add our things.
		. += B.on_screen_objects()

		// go up a row if needed
		if(addrow)
			row++
			first = TRUE		//first in the row, don't apply between-item padding.
			current_pixel = VOLUMETRIC_STORAGE_EDGE_PADDING

	// Then, continuous section.
	ui_continuous = get_ui_continuous()
	ui_continuous.screen_loc = "[screen_start_x]:[screen_pixel_x],[screen_start_y]:[screen_pixel_y] to [screen_start_x+maxcolumns-1]:[screen_pixel_x],[screen_start_y+rows-1]:[screen_pixel_y]"
	. += ui_continuous
	// Then, left.
	ui_left = get_ui_left()
	ui_left.screen_loc = "[screen_start_x]:[screen_pixel_x - 2],[screen_start_y]:[screen_pixel_y] to [screen_start_x]:[screen_pixel_x - 2],[screen_start_y+rows-1]:[screen_pixel_y]"
	. += ui_left
	// Then, closer, which is also our right element.
	ui_close = get_ui_close()
	ui_close.screen_loc = "[screen_start_x + maxcolumns]:[screen_pixel_x],[screen_start_y]:[screen_pixel_y] to [screen_start_x + maxcolumns]:[screen_pixel_x],[screen_start_y+rows-1]:[screen_pixel_y]"
	. += ui_close

/**
  * Shows our UI to a mob.
  */
/datum/component/storage/proc/ui_show(mob/M)
	if(!M.client)
		return FALSE
	if(ui_by_mob[M] || LAZYFIND(is_using, M))
		// something went horribly wrong
		// hide first
		ui_hide(M)
	var/list/cview = getviewsize(M.client.view)
	// in tiles
	var/maxallowedscreensize = cview[1]-8
	// we got screen size, register signal
	RegisterSignal(M, COMSIG_MOB_CLIENT_LOGOUT, .proc/on_logout, override = TRUE)
	RegisterSignal(M, COMSIG_PARENT_QDELETING, .proc/on_logout, override = TRUE)
	if(M.active_storage != src)
		if(M.active_storage)
			M.active_storage.ui_hide(M)
		M.active_storage = src
	LAZYOR(is_using, M)
	if(!M.client?.prefs?.no_tetris_storage && volumetric_ui())
		//new volumetric ui bay-style
		var/list/objects = orient2hud_volumetric(M, maxallowedscreensize)
		M.client.screen |= objects
		ui_by_mob[M] = objects
	else
		//old ui
		var/list/objects = orient2hud_legacy(M, maxallowedscreensize)
		M.client.screen |= objects
		ui_by_mob[M] = objects
	return TRUE

/**
  * Hides our UI from a mob
  */
/datum/component/storage/proc/ui_hide(mob/M)
	if(!M.client)
		return TRUE
	UnregisterSignal(M, list(COMSIG_PARENT_QDELETING, COMSIG_MOB_CLIENT_LOGOUT))
	M.client.screen -= ui_by_mob[M]
	var/list/objects = ui_by_mob[M]
	QDEL_LIST(objects)
	if(M.active_storage == src)
		M.active_storage = null
	LAZYREMOVE(is_using, M)
	return TRUE

/**
  * Returns TRUE if we are using volumetric UI instead of box UI
  */
/datum/component/storage/proc/volumetric_ui()
	var/atom/real_location = real_location()
	return (storage_flags & STORAGE_LIMIT_VOLUME) && (length(real_location.contents) <= MAXIMUM_VOLUMETRIC_ITEMS) && !display_numerical_stacking

/**
  * Gets our ui_boxes, making it if it doesn't exist.
  */
/datum/component/storage/proc/get_ui_boxes()
	return new /atom/movable/screen/storage/boxes(null, src)

/**
  * Gets our ui_left, making it if it doesn't exist.
  */
/datum/component/storage/proc/get_ui_left()
	return new /atom/movable/screen/storage/left(null, src)

/**
  * Gets our ui_close, making it if it doesn't exist.
  */
/datum/component/storage/proc/get_ui_close()
	return new /atom/movable/screen/storage/close(null, src)

/**
  * Gets our ui_continuous, making it if it doesn't exist.
  */
/datum/component/storage/proc/get_ui_continuous()
	return new /atom/movable/screen/storage/continuous(null, src)


// External storage-related logic:
// /mob/proc/ClickOn() in /_onclick/click.dm - clicking items in storages
// /mob/living/Move() in /modules/mob/living/living.dm - hiding storage boxes on mob movement

/datum/component/storage/concrete
	can_transfer = TRUE
	
/datum/component/storage/concrete/Initialize()
	. = ..()
	RegisterSignal(parent, COMSIG_ATOM_CONTENTS_DEL, .proc/on_contents_del)

/datum/component/storage/concrete/Destroy()
	var/atom/real_location = real_location()
	for(var/atom/_A in real_location)
		_A.mouse_opacity = initial(_A.mouse_opacity)
	if(drop_all_on_destroy)
		do_quick_empty()
	for(var/i in slaves)
		var/datum/component/storage/slave = i
		slave.change_master(null)
	QDEL_LIST(_contents_limbo)
	_user_limbo = null
	return ..()

/datum/component/storage/concrete/PreTransfer()
	if(is_using)
		_user_limbo = is_using.Copy()
		close_all()
	if(transfer_contents_on_component_transfer)
		_contents_limbo = list()
		for(var/atom/movable/AM in parent)
			_contents_limbo += AM
			AM.moveToNullspace()

/datum/component/storage/concrete/PostTransfer()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	if(transfer_contents_on_component_transfer)
		for(var/i in _contents_limbo)
			var/atom/movable/AM = i
			AM.forceMove(parent)
		_contents_limbo = null
	if(_user_limbo)
		for(var/i in _user_limbo)
			ui_show(i)
		_user_limbo = null

/datum/component/storage/concrete/_insert_physical_item(obj/item/I, override = FALSE)
	. = TRUE
	var/atom/real_location = real_location()
	if(real_location && I.loc != real_location)
		I.forceMove(real_location)
	refresh_mob_views()

/datum/component/storage/concrete/refresh_mob_views()
	. = ..()
	for(var/i in slaves)
		var/datum/component/storage/slave = i
		slave.refresh_mob_views()

/datum/component/storage/concrete/emp_act(datum/source, severity)
	if(emp_shielded)
		return
	var/atom/real_location = real_location()
	for(var/i in real_location)
		var/atom/A = i
		A.emp_act(severity)

/datum/component/storage/concrete/proc/on_slave_link(datum/component/storage/S)
	if(S == src)
		return FALSE
	slaves += S
	return TRUE

/datum/component/storage/concrete/proc/on_slave_unlink(datum/component/storage/S)
	slaves -= S
	return FALSE

/datum/component/storage/concrete/proc/on_contents_del(datum/source, atom/A)
	SIGNAL_HANDLER
	var/atom/real_location = parent
	if(A in real_location)
		usr = null
		remove_from_storage(A, null)

/datum/component/storage/concrete/can_see_contents()
	. = ..()
	for(var/i in slaves)
		var/datum/component/storage/slave = i
		. |= slave.can_see_contents()

//Resets screen loc and other vars of something being removed from storage.
/datum/component/storage/concrete/_removal_reset(atom/movable/thing)
	thing.layer = initial(thing.layer)
	thing.plane = initial(thing.plane)
	thing.mouse_opacity = initial(thing.mouse_opacity)
	if(thing.maptext)
		thing.maptext = ""

/datum/component/storage/concrete/remove_from_storage(atom/movable/AM, atom/new_location)
	//Cache this as it should be reusable down the bottom, will not apply if anyone adds a sleep to dropped
	//or moving objects, things that should never happen
	var/atom/parent = src.parent
	var/list/seeing_mobs = can_see_contents()
	for(var/mob/M in seeing_mobs)
		M.client.screen -= AM
	if(isitem(AM))
		var/obj/item/removed_item = AM
		removed_item.item_flags &= ~IN_STORAGE
		if(ismob(parent.loc))
			var/mob/carrying_mob = parent.loc
			removed_item.dropped(carrying_mob, TRUE)
	if(new_location)
		//Reset the items values
		_removal_reset(AM)
		AM.forceMove(new_location)
		//We don't want to call this if the item is being destroyed
		AM.on_exit_storage(src)
	else
		//Being destroyed, just move to nullspace now (so it's not in contents for the icon update)
		AM.moveToNullspace()
	refresh_mob_views()
	if(isobj(parent))
		var/obj/O = parent
		O.update_appearance()
	return TRUE

/datum/component/storage/concrete/proc/slave_can_insert_object(datum/component/storage/slave, obj/item/I, stop_messages = FALSE, mob/M)
	return TRUE

/datum/component/storage/concrete/proc/handle_item_insertion_from_slave(datum/component/storage/slave, obj/item/I, prevent_warning = FALSE, M)
	. = handle_item_insertion(I, prevent_warning, M, slave)
	if(. && !prevent_warning)
		slave.mob_item_insertion_feedback(usr, M, I)

/datum/component/storage/concrete/handle_item_insertion(obj/item/I, prevent_warning = FALSE, mob/M, datum/component/storage/remote) //Remote is null or the slave datum
	var/datum/component/storage/concrete/master = master()
	var/atom/parent = src.parent
	var/moved = FALSE
	if(!istype(I))
		return FALSE
	if(M)
		if(!M.temporarilyRemoveItemFromInventory(I))
			return FALSE
		else
			moved = TRUE //At this point if the proc fails we need to manually move the object back to the turf/mob/whatever.
	if(I.pulledby)
		I.pulledby.stop_pulling()
	if(silent)
		prevent_warning = TRUE
	if(!_insert_physical_item(I))
		if(moved)
			if(M)
				if(!M.put_in_active_hand(I))
					I.forceMove(parent.drop_location())
			else
				I.forceMove(parent.drop_location())
		return FALSE
	I.on_enter_storage(master)
	I.item_flags |= IN_STORAGE
	refresh_mob_views()
	I.mouse_opacity = MOUSE_OPACITY_OPAQUE //So you can click on the area around the item to equip it, instead of having to pixel hunt
	if(M)
		if(M.client && M.active_storage != src)
			M.client.screen -= I
		if(M.observers && M.observers.len)
			for(var/i in M.observers)
				var/mob/dead/observe = i
				if(observe.client && observe.active_storage != src)
					observe.client.screen -= I
		if(!remote)
			parent.add_fingerprint(M)
			if(!prevent_warning)
				mob_item_insertion_feedback(usr, M, I)
	update_icon()
	return TRUE

/datum/component/storage/concrete/update_icon()
	if(isobj(parent))
		var/obj/O = parent
		O.update_appearance()
	for(var/i in slaves)
		var/datum/component/storage/slave = i
		slave.update_icon()
/datum/component/storage/concrete/rped
	collection_mode = COLLECT_EVERYTHING
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	click_gather = TRUE
	storage_flags = STORAGE_FLAGS_LEGACY_DEFAULT
	max_w_class = WEIGHT_CLASS_NORMAL
	max_combined_w_class = 100
	max_items = 100
	display_numerical_stacking = TRUE

/datum/component/storage/concrete/rped/can_be_inserted(obj/item/I, stop_messages, mob/M)
	. = ..()
	if(!I.get_part_rating())
		if (!stop_messages)
			to_chat(M, "<span class='warning'>[parent] only accepts machine parts!</span>")
		return FALSE

/datum/component/storage/concrete/rped/quick_empty(mob/M)
	var/atom/A = parent
	if(!M.canUseStorage() || !A.Adjacent(M) || M.incapacitated())
		return
	if(check_locked(null, M, TRUE))
		return FALSE
	A.add_fingerprint(M)
	var/list/things = contents()
	var/lowest_rating = INFINITY
	for(var/obj/item/B in things)
		if(B.get_part_rating() < lowest_rating)
			lowest_rating = B.get_part_rating()
	for(var/obj/item/B in things)
		if(B.get_part_rating() > lowest_rating)
			things.Remove(B)
	if(lowest_rating == INFINITY)
		to_chat(M, "<span class='notice'>There's no parts to dump out from [parent].</span>")
		return
	to_chat(M, "<span class='notice'>You start dumping out tier/cell rating [lowest_rating] parts from [parent].</span>")
	var/turf/T = get_turf(A)
	var/datum/progressbar/progress = new(M, length(things), T)
	while (do_after(M, 10, TRUE, T, FALSE, CALLBACK(src, .proc/mass_remove_from_storage, T, things, progress, TRUE, M)))
		stoplag(1)
	qdel(progress)
	A.do_squish(0.8, 1.2)

/datum/component/storage/concrete/bluespace/rped
	collection_mode = COLLECT_EVERYTHING
	allow_quick_gather = TRUE
	allow_quick_empty = TRUE
	click_gather = TRUE
	max_w_class = WEIGHT_CLASS_BULKY  // can fit vending refills
	max_combined_w_class = 800
	max_items = 350
	display_numerical_stacking = TRUE

/datum/component/storage/concrete/bluespace/rped/can_be_inserted(obj/item/I, stop_messages, mob/M)
	. = ..()
	if(!I.get_part_rating())
		if (!stop_messages)
			to_chat(M, "<span class='warning'>[parent] only accepts machine parts!</span>")
		return FALSE


/datum/component/storage/concrete/bluespace/rped/quick_empty(mob/M)
	var/atom/A = parent
	if(!M.canUseStorage() || !A.Adjacent(M) || M.incapacitated())
		return
	if(check_locked(null, M, TRUE))
		return FALSE
	A.add_fingerprint(M)
	var/list/things = contents()
	var/lowest_rating = INFINITY
	for(var/obj/item/B in things)
		if(B.get_part_rating() < lowest_rating)
			lowest_rating = B.get_part_rating()
	for(var/obj/item/B in things)
		if(B.get_part_rating() > lowest_rating)
			things.Remove(B)
	if(lowest_rating == INFINITY)
		to_chat(M, "<span class='notice'>There's no parts to dump out from [parent].</span>")
		return
	to_chat(M, "<span class='notice'>You start dumping out tier/cell rating [lowest_rating] parts from [parent].</span>")
	var/turf/T = get_turf(A)
	var/datum/progressbar/progress = new(M, length(things), T)
	while (do_after(M, 10, TRUE, T, FALSE, CALLBACK(src, .proc/mass_remove_from_storage, T, things, progress, TRUE, M)))
		stoplag(1)
	qdel(progress)
	A.do_squish(0.8, 1.2)

/datum/component/storage/concrete/pockets
	max_items = 2
	max_w_class = WEIGHT_CLASS_SMALL
	max_combined_w_class = 50
	rustle_sound = FALSE

/datum/component/storage/concrete/pockets/handle_item_insertion(obj/item/I, prevent_warning, mob/user)
	. = ..()
	if(. && silent && !prevent_warning)
		if(quickdraw)
			to_chat(user, "<span class='notice'>You discreetly slip [I] into [parent]. Alt-click [parent] to remove it.</span>")
		else
			to_chat(user, "<span class='notice'>You discreetly slip [I] into [parent].</span>")

//Stack-only storage.
/datum/component/storage/concrete/stack
	display_numerical_stacking = TRUE
	storage_flags = STORAGE_FLAGS_LEGACY_DEFAULT
	var/max_combined_stack_amount = 300
	max_w_class = WEIGHT_CLASS_NORMAL
	max_combined_w_class = WEIGHT_CLASS_NORMAL * 14

/datum/component/storage/concrete/stack/proc/total_stack_amount()
	. = 0
	var/atom/real_location = real_location()
	for(var/i in real_location)
		var/obj/item/stack/S = i
		if(!istype(S))
			continue
		. += S.amount

//emptying procs do not need modification as stacks automatically merge.

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

/datum/component/storage/concrete/stack/_process_numerical_display()
	var/atom/real_location = real_location()
	. = list()
	for(var/i in real_location)
		var/obj/item/stack/I = i
		if(!istype(I) || QDELETED(I))				//We're specialized stack storage, just ignore non stacks.
			continue
		if(!.[I.merge_type])
			.[I.merge_type] = new /datum/numbered_display(I, I.amount)
		else
			var/datum/numbered_display/ND = .[I.merge_type]
			ND.number += I.amount

/atom/movable/screen/storage
	name = "storage"
	var/insertion_click = FALSE

/atom/movable/screen/storage/Initialize(mapload, new_master)
	. = ..()
	master = new_master

/atom/movable/screen/storage/Click(location, control, params)
	if(!insertion_click)
		return ..()
	if(hud?.mymob && (hud.mymob != usr))
		return
	// just redirect clicks
	if(master)
		var/obj/item/I = usr.get_active_held_item()
		if(I)
			master.attackby(null, I, usr, params)
	return TRUE

/atom/movable/screen/storage/boxes
	name = "storage"
	icon_state = "block"
	screen_loc = "7,7 to 10,8"
	layer = HUD_LAYER
	plane = HUD_PLANE
	insertion_click = TRUE


/atom/movable/screen/storage/volumetric_box
	icon_state = "stored_continue"

/atom/movable/screen/storage/volumetric_box/center
	icon_state = "stored_continue"
	var/atom/movable/screen/storage/volumetric_edge/stored_left/left
	var/atom/movable/screen/storage/volumetric_edge/stored_right/right
	var/atom/movable/screen/storage/item_holder/holder
	var/pixel_size

/atom/movable/screen/storage/volumetric_box/center/Initialize(mapload, new_master, our_item)
	left = new(null, src, our_item)
	right = new(null, src, our_item)
	return ..()

/atom/movable/screen/storage/volumetric_box/center/Destroy()
	QDEL_NULL(left)
	QDEL_NULL(right)
	vis_contents.Cut()
	if(holder)
		QDEL_NULL(holder)
	return ..()

/atom/movable/screen/storage/volumetric_box/center/proc/on_screen_objects()
	return list(src)

/**
  * Sets the size of this box screen object and regenerates its left/right borders. This includes the actual border's size!
  */
/atom/movable/screen/storage/volumetric_box/center/proc/set_pixel_size(pixels)
	if(pixel_size == pixels)
		return
	pixel_size = pixels
	cut_overlays()
	vis_contents.Cut()
	//our icon size is 32 pixels.
	var/multiplier = (pixels - (VOLUMETRIC_STORAGE_BOX_BORDER_SIZE * 2)) / VOLUMETRIC_STORAGE_BOX_ICON_SIZE
	transform = matrix(multiplier, 0, 0, 0, 1, 0)
	if(our_item)
		if(holder)
			qdel(holder)
		holder = new(null, src, our_item)
		holder.transform = matrix(1 / multiplier, 0, 0, 0, 1, 0)
		holder.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
		holder.appearance_flags &= ~RESET_TRANSFORM
		makeItemInactive()
	vis_contents += holder
	left.pixel_x = -((pixels - VOLUMETRIC_STORAGE_BOX_ICON_SIZE) * 0.5) - VOLUMETRIC_STORAGE_BOX_BORDER_SIZE
	right.pixel_x = ((pixels - VOLUMETRIC_STORAGE_BOX_ICON_SIZE) * 0.5) + VOLUMETRIC_STORAGE_BOX_BORDER_SIZE
	add_overlay(left)
	add_overlay(right)

/atom/movable/screen/storage/volumetric_box/center/makeItemInactive()
	if(!holder)
		return
	holder.layer = VOLUMETRIC_STORAGE_ITEM_LAYER
	holder.plane = VOLUMETRIC_STORAGE_ITEM_PLANE

/atom/movable/screen/storage/volumetric_box/center/makeItemActive()
	if(!holder)
		return
	holder.our_item.layer = VOLUMETRIC_STORAGE_ACTIVE_ITEM_LAYER		//make sure we display infront of the others!
	holder.our_item.plane = VOLUMETRIC_STORAGE_ACTIVE_ITEM_PLANE

/atom/movable/screen/storage/volumetric_edge
	layer = VOLUMETRIC_STORAGE_BOX_LAYER
	plane = VOLUMETRIC_STORAGE_BOX_PLANE

/atom/movable/screen/storage/volumetric_edge/Initialize(mapload, master, our_item)
	src.master = master
	return ..()

/atom/movable/screen/storage/volumetric_edge/Click(location, control, params)
	return master.Click(location, control, params)

/atom/movable/screen/storage/volumetric_edge/MouseDrop(atom/over, src_location, over_location, src_control, over_control, params)
	return master.MouseDrop(over, src_location, over_location, src_control, over_control, params)

/atom/movable/screen/storage/volumetric_edge/MouseExited(location, control, params)
	return master.MouseExited(location, control, params)

/atom/movable/screen/storage/volumetric_edge/MouseEntered(location, control, params)
	return master.MouseEntered(location, control, params)

/atom/movable/screen/storage/volumetric_edge/stored_left
	icon_state = "stored_start"
	appearance_flags = APPEARANCE_UI | KEEP_APART | RESET_TRANSFORM // Yes I know RESET_TRANSFORM is in APPEARANCE_UI but we're hard-asserting this incase someone changes it.

/atom/movable/screen/storage/volumetric_edge/stored_right
	icon_state = "stored_end"
	appearance_flags = APPEARANCE_UI | KEEP_APART | RESET_TRANSFORM

/atom/movable/screen/storage/item_holder
	var/obj/item/our_item
	vis_flags = NONE

/atom/movable/screen/storage/item_holder/Initialize(mapload, new_master, obj/item/I)
	. = ..()
	our_item = I
	vis_contents += I

/atom/movable/screen/storage/item_holder/Destroy()
	vis_contents.Cut()
	our_item = null
	return ..()

/atom/movable/screen/storage/item_holder/Click(location, control, params)
	return our_item.Click(location, control, params)
