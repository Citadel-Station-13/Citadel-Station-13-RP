

// External storage-related logic:
// /mob/proc/ClickOn() in /_onclick/click.dm - clicking items in storages
// /mob/living/Move() in /modules/mob/living/living.dm - hiding storage boxes on mob movement

/datum/component/storage
	var/silent = FALSE								//whether this makes a message when things are put in.
	var/rustle_sound = TRUE							//play rustle sound on interact.
	var/quickdraw = FALSE							//altclick interact
	var/datum/action/item_action/storage_gather_mode/modeswitch_action

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
