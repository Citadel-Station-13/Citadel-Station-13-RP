/obj/item/storage
	name = "storage"
	icon = 'icons/obj/storage.dmi'
	inhand_default_type = INHAND_DEFAULT_ICON_STORAGE
	w_class = WEIGHT_CLASS_NORMAL
	show_messages = 1
	
	//* Directly passed to storage system. *//

	var/list/insertion_whitelist
	var/list/insertion_blacklist
	var/list/insertion_allow

	var/max_single_weight_class = WEIGHT_CLASS_SMALL
	var/max_combined_weight_class
	var/max_combined_volume = WEIGHT_VOLUME_SMALL * 4
	var/max_items
	
	var/weight_subtract = 0
	var/weight_multiply = 1
	
	var/allow_mass_gather = FALSE
	var/allow_mass_gather_mode_switch = TRUE
	var/mass_gather_mode = STORAGE_QUICK_GATHER_COLLECT_ALL

	var/allow_quick_empty = FALSE
	var/allow_quick_empty_via_clickdrag = TRUE
	var/allow_quick_empty_via_attack_self = TRUE
	
	var/sfx_open = "rustle"
	var/sfx_insert = "rustle"
	var/sfx_remove = "rustle"

	var/ui_numerical_mode = FALSE

	//* Initialization *//
	
	/// storage datum path
	var/storage_datum_path = /datum/object_system/storage
	/// Cleared after Initialize().
	/// List of types associated to amounts.
	var/list/starts_with
	/// set to prevent us from spawning starts_with
	var/empty = FALSE

/obj/item/storage/Initialize(mapload)
	. = ..()
	initialize_storage()
	spawn_contents()
	legacy_spawn_contents()

/**
 * Make sure to set [worth_dynamic] to TRUE if this does more than spawning what's in starts_with.
 */
/obj/item/storage/proc/spawn_contents()
	if(length(starts_with) && !empty)
		// this is way too permissive already
		var/safety = 256
		for(var/path in starts_with)
			var/amount = starts_with[path] || 1
			for(var/i in 1 to amount)
				if(!--safety)
					CRASH("tried to spawn too many objects")
				new path(src)
	starts_with = null

/**
 * Please get rid of this in favor of spawn_contents() and starts_with
 */
/obj/item/storage/proc/legacy_spawn_contents()
	return

/obj/item/storage/proc/initialize_storage()
	ASSERT(isnull(obj_storage))
	obj_storage = new(src)
	obj_storage.set_insertion_allow(insertion_allow)
	obj_storage.set_insertion_whitelist(insertion_whitelist)
	obj_storage.set_insertion_blacklist(insertion_blacklist)

	obj_storage.max_single_weight_class = max_single_weight_class
	obj_storage.max_combined_weight_class = max_combined_weight_class
	obj_storage.max_combined_volume = max_combined_volume
	obj_storage.max_items = max_items

	obj_storage.weight_subtract = weight_subtract
	obj_storage.weight_multiply = weight_multiply
	
	obj_storage.allow_mass_gather = allow_mass_gather
	obj_storage.allow_mass_gather_mode_switch = allow_mass_gather_mode_switch
	obj_storage.mass_gather_mode = mass_gather_mode

	obj_storage.sfx_open = sfx_open
	obj_storage.sfx_insert = sfx_insert
	obj_storage.sfx_remove = sfx_remove

	obj_storage.ui_numerical_mode = ui_numerical_mode

#warn below

/obj/item/storage/Initialize(mapload)
	. = ..()

	orient2hud()

	//calibrate_size()			//Let's not!

	reset_weight()

/obj/item/storage/get_weight()
	. = ..()
	. += max(0, (weight_cached * weight_multiply) - weight_subtract)

/obj/item/storage/proc/reset_weight()
	var/old_weight_cached = weight_cached
	weight_cached = 0
	for(var/obj/item/I in contents)
		weight_cached += I.get_weight()
	propagate_weight(old_weight_cached, weight_cached)
	update_weight()

/obj/item/storage/proc/stored_weight_changed(obj/item/I, old_weight, new_weight)
	var/diff = new_weight - old_weight
	var/old = weight_cached
	weight_cached += diff
	propagate_weight(old, weight_cached)

/obj/item/storage/proc/reset_weight_recursive()
	do_reset_weight_recursive(200)

/obj/item/storage/proc/do_reset_weight_recursive(safety)
	if(!(safety - 1))
		CRASH("out of safety")
	for(var/obj/item/storage/S in contents)
		S.do_reset_weight_recursive(safety - 1)
	reset_weight()

/obj/item/storage/OnMouseDrop(atom/over, mob/user, proximity, params)
	if(user != over)
		return ..()
	if(user in is_seeing)
		close(user)
	else if(isliving(user) && user.Reachability(src))
		open(user)
	else

//This proc draws out the inventory and places the items on it. tx and ty are the upper left tile and mx, my are the bottm right.
//The numbers are calculated from the bottom-left The bottom-left slot being 1,1.
/obj/item/storage/proc/orient_objs(tx, ty, mx, my)
	var/cx = tx
	var/cy = ty
	src.boxes.screen_loc = "LEFT+[tx],BOTTOM+[ty] to LEFT+[mx],BOTTOM+[my]"
	for(var/obj/O in src.contents)
		O.screen_loc = "LEFT+[cx],BOTTOM+[cy]"
		O.hud_layerise()
		cx++
		if (cx > mx)
			cx = tx
			cy--
	src.closer.screen_loc = "LEFT+[mx+1],BOTTOM+[my]"
	return

//This proc draws out the inventory and places the items on it. It uses the standard position.
/obj/item/storage/proc/slot_orient_objs(var/rows, var/cols, var/list/obj/item/display_contents)
	var/cx = 3
	var/cy = 1 + rows
	src.boxes.screen_loc = "LEFT+3:16,BOTTOM+1:16 to LEFT+[3+cols]:16,BOTTOM+[1+rows]:16"

	if(display_contents_with_number)
		for(var/datum/numbered_display/ND in display_contents)
			ND.sample_object.screen_loc = "LEFT+[cx]:16,BOTTOM+[cy]:16"
			ND.sample_object.maptext = "<font color='white'>[(ND.number > 1)? "[ND.number]" : ""]</font>"
			ND.sample_object.hud_layerise()
			cx++
			if (cx > (3+cols))
				cx = 3
				cy--
	else
		for(var/obj/O in contents)
			O.screen_loc = "LEFT+[cx]:16,BOTTOM+[cy]:16"
			O.maptext = ""
			O.hud_layerise()
			cx++
			if (cx > (3+cols))
				cx = 3
				cy--
	src.closer.screen_loc = "LEFT+[3+cols+1]:16,BOTTOM+1:16"
	return

/obj/item/storage/proc/space_orient_objs(list/obj/item/display_contents)

	var/baseline_max_combined_volume = INVENTORY_STANDARD_SPACE / 2 //should be equal to default backpack capacity // This is a lie.
	// Above var is misleading, what it does upon changing is makes smaller inventory sizes have smaller space on the UI.
	// It's cut in half because otherwise boxes of IDs and other tiny items are unbearably cluttered.

	var/storage_cap_width = 2 //length of sprite for start and end of the box representing total storage space
	var/stored_cap_width = 4 //length of sprite for start and end of the box representing the stored item
	var/storage_width = min( round( 224 * max_combined_volume/baseline_max_combined_volume ,1) ,274) //length of sprite for the box representing total storage space

	storage_start.cut_overlays()

	var/matrix/M = matrix()
	M.Scale((storage_width-storage_cap_width*2+3)/32,1)
	storage_continue.transform = M

	storage_start.screen_loc = "LEFT+3:16,BOTTOM+1:16"
	storage_continue.screen_loc = "LEFT+3:[storage_cap_width+(storage_width-storage_cap_width*2)/2+2],BOTTOM+1:16"
	storage_end.screen_loc = "LEFT+3:[19+storage_width-storage_cap_width],BOTTOM+1:16"

	var/startpoint = 0
	var/endpoint = 1

	for(var/obj/item/O in contents)
		startpoint = endpoint + 1
		endpoint += storage_width * O.get_weight_volume()/max_combined_volume

		var/matrix/M_start = matrix()
		var/matrix/M_continue = matrix()
		var/matrix/M_end = matrix()
		M_start.Translate(startpoint,0)
		M_continue.Scale((endpoint-startpoint-stored_cap_width*2)/32,1)
		M_continue.Translate(startpoint+stored_cap_width+(endpoint-startpoint-stored_cap_width*2)/2 - 16,0)
		M_end.Translate(endpoint-stored_cap_width,0)
		stored_start.transform = M_start
		stored_continue.transform = M_continue
		stored_end.transform = M_end

		var/list/overlays_to_add = list()
		overlays_to_add += stored_start
		overlays_to_add += stored_continue
		overlays_to_add += stored_end
		storage_start.add_overlay(overlays_to_add)

		O.screen_loc = "LEFT+3:[round((startpoint+endpoint)/2)+2],BOTTOM+1:16"
		O.maptext = ""
		O.hud_layerise()

	// If we're not overloaded, force overlays to build now to reduce visual lag.
	if (!TICK_CHECK)
		storage_start.compile_overlays()

	closer.screen_loc = "LEFT+3:[storage_width+19],BOTTOM+1:16"
	return


/datum/numbered_display
	var/obj/item/sample_object
	var/number

/datum/numbered_display/New(obj/item/sample)
	if(!istype(sample))
		qdel(src)
	sample_object = sample
	number = 1

//This proc determins the size of the inventory to be displayed. Please touch it only if you know what you're doing.
/obj/item/storage/proc/orient2hud(mob/user as mob)

	var/adjusted_contents = contents.len

	//Numbered contents display
	var/list/datum/numbered_display/numbered_contents
	if(display_contents_with_number)
		numbered_contents = list()
		adjusted_contents = 0
		for(var/obj/item/I in contents)
			var/found = 0
			for(var/datum/numbered_display/ND in numbered_contents)
				if(ND.sample_object.type == I.type)
					ND.number++
					found = 1
					break
			if(!found)
				adjusted_contents++
				numbered_contents.Add( new/datum/numbered_display(I) )

	if(max_items == null)
		src.space_orient_objs(numbered_contents)
	else
		var/row_num = 0
		var/col_count = min(7,max_items) -1
		if (adjusted_contents > 7)
			row_num = round((adjusted_contents-1) / 7) // 7 is the maximum allowed width.
		src.slot_orient_objs(row_num, col_count, numbered_contents)
	return


//This proc handles items being inserted. It does not perform any checks of whether an item can or can't be inserted. That's done by can_be_inserted()
//The stop_warning parameter will stop the insertion message from being displayed. It is intended for cases where you are inserting multiple items at once,
//such as when picking up all the items on a tile with one click.
/obj/item/storage/proc/handle_item_insertion(obj/item/W as obj, mob/user, prevent_warning = 0)
	if(!istype(W))
		return 0

	W.forceMove(src)
	W.on_enter_storage(src)
	W.item_flags |= ITEM_IN_STORAGE
	var/old_weight = weight_cached
	weight_cached += W.get_weight()
	propagate_weight(old_weight, weight_cached)
	if(user)
		if(!prevent_warning)
			for(var/mob/M in viewers(user))
				if (M == usr)
					to_chat(usr, "<span class='notice'>You put \the [W] into [src].</span>")
				else if (M in range(1)) //If someone is standing close enough, they can tell what it is...
					M.show_message("<span class='notice'>\The [usr] puts [W] into [src].</span>")
				else if (W && W.w_class >= 3) //Otherwise they can only see large or normal items from a distance...
					M.show_message("<span class='notice'>\The [usr] puts [W] into [src].</span>")
		if(user.s_active == src)
			orient2hud(user)
			show_to(user)

	update_icon()
	return 1

/obj/item/storage/proc/try_insert(obj/item/I, mob/user, prevent_warning = FALSE, force)
	if(!force && !can_be_inserted(I, prevent_warning))
		return FALSE
	return handle_item_insertion(I, user, prevent_warning)

//Call this proc to handle the removal of an item from the storage item. The item will be moved to the atom sent as new_target
/obj/item/storage/proc/remove_from_storage(obj/item/W as obj, atom/new_location, do_move = TRUE)
	if(!istype(W))
		return 0

	if(istype(src, /obj/item/storage/fancy))
		var/obj/item/storage/fancy/F = src
		F.update_icon(1)

	for(var/mob/M in range(1, src.loc))
		if (M.s_active == src)
			if (M.client)
				M.client.screen -= W

	if(do_move)
		if(new_location)
			W.forceMove(new_location)
		else
			W.forceMove(get_turf(src))

	if(usr?.s_active == src)
		orient2hud(usr)
		show_to(usr)
	if(W.maptext)
		W.maptext = ""
	W.on_exit_storage(src)
	W.item_flags &= ~ITEM_IN_STORAGE
	var/old_weight = weight_cached
	weight_cached -= W.get_weight()
	propagate_weight(old_weight, weight_cached)
	update_icon()
	return 1

/obj/item/storage/proc/gather_all(turf/T as turf, mob/user as mob)
	var/list/rejections = list()
	var/success = 0
	var/failure = 0

	for(var/obj/item/I in T)
		if(I.type in rejections) // To limit bag spamming: any given type only complains once
			continue
		if(!can_be_inserted(I, user))	// Note can_be_inserted still makes noise when the answer is no
			rejections += I.type	// therefore full bags are still a little spammy
			failure = 1
			continue
		success = 1
		handle_item_insertion(I, user, TRUE)	//The 1 stops the "You put the [src] into [S]" insertion message from being displayed.
	if(success && !failure)
		to_chat(user, "<span class='notice'>You put everything in [src].</span>")
	else if(success)
		to_chat(user, "<span class='notice'>You put some things in [src].</span>")
	else
		if(world.time >= last_message == 0)
			to_chat(user, "<span class='notice'>You fail to pick anything up with \the [src].</span>")
			last_message = world.time + 200

/*
 * Trinket Box - READDING SOON
 */
/obj/item/storage/trinketbox
	name = "trinket box"
	desc = "A box that can hold small trinkets, such as a ring."
	icon = 'icons/obj/items.dmi'
	icon_state = "trinketbox"
	var/open = 0
	max_items = 1
	insertion_whitelist = list(
		/obj/item/clothing/gloves/ring,
		/obj/item/coin,
		/obj/item/clothing/accessory/medal
		)
	var/open_state
	var/closed_state

/obj/item/storage/trinketbox/update_icon()
	cut_overlays()
	if(open)
		icon_state = open_state

		if(contents.len >= 1)
			var/contained_image = null
			if(istype(contents[1],  /obj/item/clothing/gloves/ring))
				contained_image = "ring_trinket"
			else if(istype(contents[1], /obj/item/coin))
				contained_image = "coin_trinket"
			else if(istype(contents[1], /obj/item/clothing/accessory/medal))
				contained_image = "medal_trinket"
			if(contained_image)
				add_overlay(contained_image)
	else
		icon_state = closed_state

/obj/item/storage/trinketbox/Initialize(mapload)
	if(!open_state)
		open_state = "[initial(icon_state)]_open"
	if(!closed_state)
		closed_state = "[initial(icon_state)]"
	. = ..()

/obj/item/storage/trinketbox/attack_self(mob/user)
	. = ..()
	if(.)
		return
	open = !open
	update_icon()
	..()

/obj/item/storage/trinketbox/examine(mob/user, dist)
	. = ..()
	if(open && contents.len)
		var/display_item = contents[1]
		. += "<span class='notice'>\The [src] contains \the [display_item]!</span>"

/obj/item/storage/AllowDrop()
	return TRUE

/obj/item/storage/clean_radiation(str, mul, cheap)
	. = ..()
	if(cheap)
		return
	for(var/atom/A as anything in contents)
		A.clean_radiation(str, mul, cheap)

/obj/item/storage/drop_products(method, atom/where)
	. = ..()
	for(var/atom/movable/AM as anything in contents)
		AM.forceMove(where)
