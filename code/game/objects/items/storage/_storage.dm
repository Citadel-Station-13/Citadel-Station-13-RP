// To clarify:
// For use_to_pickup and allow_quick_gather functionality,
// see item/attackby() (/game/objects/items.dm)
// Do not remove this functionality without good reason, cough reagent_containers cough.
// -Sayu
#define storage_ui_default "LEFT+7,BOTTOM+7 to LEFT+10,BOTTOM+8"
/obj/item/storage
	name = "storage"
	icon = 'icons/obj/storage.dmi'
	inhand_default_type = INHAND_DEFAULT_ICON_STORAGE
	w_class = ITEMSIZE_NORMAL
	show_messages = 1

	var/list/can_hold = new/list() //List of objects which this item can store (if set, it can't store anything else)
	var/list/cant_hold = new/list() //List of objects which this item can't store (in effect only if can_hold isn't set)
	var/list/is_seeing = new/list() //List of mobs which are currently seeing the contents of this item's storage
	var/max_w_class = ITEMSIZE_SMALL //Max size of objects that this object can store (in effect only if can_hold isn't set)
	var/max_storage_space = ITEMSIZE_COST_SMALL * 4 //The sum of the storage costs of all the items in this storage item.
	var/storage_slots = null //The number of storage slots in this container.  If null, it uses the volume-based storage instead.
	var/atom/movable/screen/storage/boxes = null
	var/atom/movable/screen/storage/storage_start = null //storage UI
	var/atom/movable/screen/storage/storage_continue = null
	var/atom/movable/screen/storage/storage_end = null
	var/atom/movable/screen/storage/stored_start = null
	var/atom/movable/screen/storage/stored_continue = null
	var/atom/movable/screen/storage/stored_end = null
	var/atom/movable/screen/close/closer = null
	var/use_to_pickup	//Set this to make it possible to use this item in an inverse way, so you can have the item in your hand and click items on the floor to pick them up.
	var/display_contents_with_number	//Set this to make the storage item group contents of the same type and display them as a number.
	var/allow_quick_empty	//Set this variable to allow the object to have the 'empty' verb, which dumps all the contents on the floor.
	var/allow_quick_gather	//Set this variable to allow the object to have the 'toggle mode' verb, which quickly collects all items from a tile.
	var/collection_mode = 1;  //0 = pick one at a time, 1 = pick all on tile
	var/use_sound = "rustle"	//sound played when used. null for no sound.

	var/list/starts_with //Things to spawn on the box on spawn				//THIS IS A BANNED LIST. ALL NEW STORAGE MUST USE POPULATE_CONTENTS() TO MAKE THEIR ITEMS! - KEVINZ000

	var/empty //Mapper override to spawn an empty version of a container that usually has stuff

	var/last_message = 0

/obj/item/storage/Destroy()
	close_all()
	QDEL_NULL(boxes)
	QDEL_NULL(src.storage_start)
	QDEL_NULL(src.storage_continue)
	QDEL_NULL(src.storage_end)
	QDEL_NULL(src.stored_start)
	QDEL_NULL(src.stored_continue)
	QDEL_NULL(src.stored_end)
	QDEL_NULL(closer)
	return ..()

/obj/item/storage/AltClick(mob/user)
	if(user in is_seeing)
		src.close(user)
	// I would think there should be some incap check here or something
	// But MouseDrop doesn't use one (as of this writing), so...
	else if(isliving(user) && user.Reachability(src))
		src.open(user)
	else
		return ..()

/obj/item/storage/OnMouseDrop(atom/over, mob/user, proximity, params)
	if(user != over)
		return ..()
	if(user in is_seeing)
		close(user)
	else if(isliving(user) && user.Reachability(src))
		open(user)
	else
		return ..()

/obj/item/storage/proc/return_inv()

	var/list/L = list(  )

	L += src.contents

	for(var/obj/item/storage/S in src)
		L += S.return_inv()
	for(var/obj/item/gift/G in src)
		L += G.gift
		if (istype(G.gift, /obj/item/storage))
			L += G.gift:return_inv()
	return L

/obj/item/storage/proc/show_to(mob/user as mob)
	// todo: datum storage
	if(!user.client)
		return
	if(user.s_active != src)
		for(var/obj/item/I in src)
			if(I.on_found(user))
				return
	if(user.s_active)
		user.s_active.hide_from(user)
	user.client.screen -= src.boxes
	user.client.screen -= src.storage_start
	user.client.screen -= src.storage_continue
	user.client.screen -= src.storage_end
	user.client.screen -= src.closer
	user.client.screen -= src.contents
	user.client.screen += src.closer
	user.client.screen += src.contents
	if(storage_slots)
		user.client.screen += src.boxes
	else
		user.client.screen += src.storage_start
		user.client.screen += src.storage_continue
		user.client.screen += src.storage_end
	user.s_active = src
	is_seeing |= user
	return

/obj/item/storage/proc/hide_from(mob/user as mob)
	if(!user)
		return
	is_seeing -= user
	if(user.s_active == src)
		user.s_active = null
	if(!user?.client)
		return
	user.client.screen -= src.boxes
	user.client.screen -= src.storage_start
	user.client.screen -= src.storage_continue
	user.client.screen -= src.storage_end
	user.client.screen -= src.closer
	user.client.screen -= src.contents

/obj/item/storage/proc/open(mob/user as mob, sound_played = FALSE)
	if (src.use_sound && !isobserver(user) && !sound_played)
		playsound(src.loc, src.use_sound, 50, 1, -5)

	orient2hud(user)
	if (user.s_active)
		user.s_active.close(user)
	show_to(user)

/obj/item/storage/proc/close(mob/user as mob)
	src.hide_from(user)
	user.s_active = null
	return

/obj/item/storage/proc/close_all()
	for(var/mob/M in can_see_contents())
		close(M)
		. = 1

/obj/item/storage/proc/can_see_contents()
	var/list/cansee = list()
	for(var/mob/M in is_seeing)
		if(M.s_active == src && M.client)
			cansee |= M
		else
			is_seeing -= M
	return cansee

/// Adds up the combined w_classes.
/obj/item/storage/proc/storage_space_used()
	. = 0
	for(var/obj/item/I in contents)
		. += I.get_storage_cost()

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

	var/baseline_max_storage_space = INVENTORY_STANDARD_SPACE / 2 //should be equal to default backpack capacity // This is a lie.
	// Above var is misleading, what it does upon changing is makes smaller inventory sizes have smaller space on the UI.
	// It's cut in half because otherwise boxes of IDs and other tiny items are unbearably cluttered.

	var/storage_cap_width = 2 //length of sprite for start and end of the box representing total storage space
	var/stored_cap_width = 4 //length of sprite for start and end of the box representing the stored item
	var/storage_width = min( round( 224 * max_storage_space/baseline_max_storage_space ,1) ,274) //length of sprite for the box representing total storage space

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
		endpoint += storage_width * O.get_storage_cost()/max_storage_space

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

	if(storage_slots == null)
		src.space_orient_objs(numbered_contents)
	else
		var/row_num = 0
		var/col_count = min(7,storage_slots) -1
		if (adjusted_contents > 7)
			row_num = round((adjusted_contents-1) / 7) // 7 is the maximum allowed width.
		src.slot_orient_objs(row_num, col_count, numbered_contents)
	return

//This proc return 1 if the item can be picked up and 0 if it can't.
//Set the stop_messages to stop it from printing messages
/obj/item/storage/proc/can_be_inserted(obj/item/W as obj, stop_messages = 0)
	if(!istype(W))
		return //Not an item

	if(usr && usr.is_in_inventory(W) && !usr.can_unequip(W, user = usr))
		return 0

	if(src.loc == W)
		return 0 //Means the item is already in the storage item

	if(storage_slots != null && contents.len >= storage_slots)
		if(!stop_messages)
			to_chat(usr, "<span class='notice'>[src] is full, make some space.</span>")
		return 0 //Storage item is full

	if(can_hold.len && !is_type_in_list(W, can_hold))
		if(!stop_messages)
			if (istype(W, /obj/item/hand_labeler))
				return 0
			to_chat(usr, "<span class='notice'>[src] cannot hold [W].</span>")
		return 0

	if(cant_hold.len && is_type_in_list(W, cant_hold))
		if(!stop_messages)
			to_chat(usr, "<span class='notice'>[src] cannot hold [W].</span>")
		return 0

	if (max_w_class != null && W.w_class > max_w_class)
		if(!stop_messages)
			to_chat(usr, "<span class='notice'>[W] is too long for \the [src].</span>")
		return 0

	if((storage_space_used() + W.get_storage_cost()) > max_storage_space) //Adds up the combined w_classes which will be in the storage item if the item is added to it.
		if(!stop_messages)
			to_chat(usr, "<span class='notice'>[src] is too full, make some space.</span>")
		return 0

	if(W.w_class >= src.w_class && (istype(W, /obj/item/storage)))
		if(!stop_messages)
			to_chat(usr, "<span class='notice'>[src] cannot hold [W] as it's a storage item of the same size.</span>")
		return 0 //To prevent the stacking of same sized storage items.

	return 1

//This proc handles items being inserted. It does not perform any checks of whether an item can or can't be inserted. That's done by can_be_inserted()
//The stop_warning parameter will stop the insertion message from being displayed. It is intended for cases where you are inserting multiple items at once,
//such as when picking up all the items on a tile with one click.
/obj/item/storage/proc/handle_item_insertion(obj/item/W as obj, mob/user, prevent_warning = 0)
	if(!istype(W))
		return 0

	W.forceMove(src)
	W.on_enter_storage(src)
	W.item_flags |= ITEM_IN_STORAGE
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
	update_icon()
	return 1

/obj/item/storage/Exited(atom/movable/AM, atom/newLoc)
	if(isitem(AM))
		var/obj/item/I = AM
		if(I.item_flags & ITEM_IN_STORAGE)
			remove_from_storage(I, null, FALSE)
	return ..()

//This proc is called when you want to place an item into the storage item.
/obj/item/storage/attackby(obj/item/W as obj, mob/user as mob)
	..()

	if(isrobot(user))
		return //Robots can't interact with storage items.

	if(istype(W, /obj/item/lightreplacer))
		var/obj/item/lightreplacer/LP = W
		var/amt_inserted = 0
		var/turf/T = get_turf(user)
		for(var/obj/item/light/L in src.contents)
			if(L.status == 0)
				if(LP.uses < LP.max_uses)
					LP.add_uses(1)
					amt_inserted++
					remove_from_storage(L, T)
					qdel(L)
		if(amt_inserted)
			to_chat(user, "You inserted [amt_inserted] light\s into \the [LP.name]. You have [LP.uses] light\s remaining.")
			return

	if(!can_be_inserted(W))
		return

	if(!user.transfer_item_to_loc(W, src))
		return

	W.add_fingerprint(user)
	return handle_item_insertion(W, user)

/obj/item/storage/attack_hand(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.l_store == src && !H.get_active_held_item())	//Prevents opening if it's in a pocket.
			H.put_in_hands(src)
			H.l_store = null
			return
		if(H.r_store == src && !H.get_active_held_item())
			H.put_in_hands(src)
			H.r_store = null
			return

	if (loc == user)
		open(user)
	else
		..()
		for(var/mob/M in range(1))
			if (M.s_active == src)
				src.close(M)
	src.add_fingerprint(user)
	return

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

/obj/item/storage/verb/toggle_gathering_mode()
	set name = "Switch Gathering Method"
	set category = "Object"

	collection_mode = !collection_mode
	switch (collection_mode)
		if(1)
			to_chat(usr, "[src] now picks up all items on a tile at once.")
		if(0)
			to_chat(usr, "[src] now picks up one item at a time.")

/obj/item/storage/verb/quick_empty()
	set name = "Empty Contents"
	set category = "Object"

	if(((!(ishuman(usr) || isrobot(usr))) && (src.loc != usr)) || usr.stat || usr.restrained())
		return
	drop_contents()

/obj/item/storage/proc/drop_contents()
	hide_from(usr)
	var/turf/T = get_turf(src)
	for(var/obj/item/I in contents)
		remove_from_storage(I, T)

/obj/item/storage/Initialize(mapload)
	. = ..()

	if(allow_quick_empty)
		add_obj_verb(src, /obj/item/storage/verb/quick_empty)
	else
		remove_obj_verb(src, /obj/item/storage/verb/quick_empty)

	if(allow_quick_gather)
		add_obj_verb(src, /obj/item/storage/verb/toggle_gathering_mode)
	else
		remove_obj_verb(src, /obj/item/storage/verb/toggle_gathering_mode)

	src.boxes = new /atom/movable/screen/storage(  )
	src.boxes.name = "storage"
	src.boxes.master = src
	src.boxes.icon_state = "block"
	src.boxes.screen_loc = storage_ui_default

	src.storage_start = new /atom/movable/screen/storage(  )
	src.storage_start.name = "storage"
	src.storage_start.master = src
	src.storage_start.icon_state = "storage_start"
	src.storage_start.screen_loc = storage_ui_default

	src.storage_continue = new /atom/movable/screen/storage(  )
	src.storage_continue.name = "storage"
	src.storage_continue.master = src
	src.storage_continue.icon_state = "storage_continue"
	src.storage_continue.screen_loc = storage_ui_default

	src.storage_end = new /atom/movable/screen/storage(  )
	src.storage_end.name = "storage"
	src.storage_end.master = src
	src.storage_end.icon_state = "storage_end"
	src.storage_end.screen_loc = storage_ui_default

	src.stored_start = new /atom/movable //we just need these to hold the icon
	src.stored_start.icon_state = "stored_start"

	src.stored_continue = new /atom/movable
	src.stored_continue.icon_state = "stored_continue"

	src.stored_end = new /atom/movable
	src.stored_end.icon_state = "stored_end"

	src.closer = new /atom/movable/screen/close(  )
	src.closer.master = src
	src.closer.icon_state = "storage_close"
	src.closer.hud_layerise()
	orient2hud()

	populate_contents_legacy()

	PopulateContents()

	//calibrate_size()			//Let's not!

/obj/item/storage/proc/populate_contents_legacy()
	if(LAZYLEN(starts_with) && !empty)
		for(var/newtype in starts_with)
			var/count = starts_with[newtype] || 1 //Could have left it blank.
			while(count)
				count--
				new newtype(src)
		starts_with = null //Reduce list count.

/obj/item/storage/proc/PopulateContents()


///Prevents spawned containers from being too small for their contents.
/obj/item/storage/proc/calibrate_size()
	max_storage_space = max(storage_space_used(),max_storage_space)

/obj/item/storage/emp_act(severity)
	if(!istype(src.loc, /mob/living))
		for(var/obj/O in contents)
			O.emp_act(severity)
	..()

/obj/item/storage/attack_self(mob/user as mob)
	if((user.get_active_held_item() == src) || (isrobot(user)) && allow_quick_empty)
		if(src.verbs.Find(/obj/item/storage/verb/quick_empty))
			src.quick_empty()
			return 1

//Returns the storage depth of an atom. This is the number of storage items the atom is contained in before reaching toplevel (the area).
//Returns -1 if the atom was not found on container.
/atom/proc/storage_depth(atom/container)
	var/depth = 0
	var/atom/cur_atom = src

	while (cur_atom && !(cur_atom in container.contents))
		if (isarea(cur_atom))
			return INFINITY
		if (istype(cur_atom.loc, /obj/item/storage))
			depth++
		cur_atom = cur_atom.loc

	if (!cur_atom)
		return INFINITY	//inside something with a null loc.

	return depth

//Like storage depth, but returns the depth to the nearest turf
//Returns -1 if no top level turf (a loc was null somewhere, or a non-turf atom's loc was an area somehow).
/atom/proc/storage_depth_turf()
	var/depth = 0
	var/atom/cur_atom = src

	while (cur_atom && !isturf(cur_atom))
		if (isarea(cur_atom))
			return INFINITY
		if (istype(cur_atom.loc, /obj/item/storage))
			depth++
		cur_atom = cur_atom.loc

	if (!cur_atom)
		return INFINITY	//inside something with a null loc.

	return depth

// See inventory_sizes.dm for the defines.
/obj/item/proc/get_storage_cost()
	if (storage_cost)
		return storage_cost
	else
		switch(w_class)
			if(ITEMSIZE_TINY)
				return ITEMSIZE_COST_TINY
			if(ITEMSIZE_SMALL)
				return ITEMSIZE_COST_SMALL
			if(ITEMSIZE_NORMAL)
				return ITEMSIZE_COST_NORMAL
			if(ITEMSIZE_LARGE)
				return ITEMSIZE_COST_LARGE
			if(ITEMSIZE_HUGE)
				return ITEMSIZE_COST_HUGE
			else
				return ITEMSIZE_COST_NO_CONTAINER

/obj/item/storage/proc/make_exact_fit()
	storage_slots = contents.len

	can_hold.Cut()
	max_w_class = 0
	max_storage_space = 0
	for(var/obj/item/I in src)
		can_hold[I.type]++
		max_w_class = max(I.w_class, max_w_class)
		max_storage_space += I.get_storage_cost()

/*
 * Trinket Box - READDING SOON
 */
/obj/item/storage/trinketbox
	name = "trinket box"
	desc = "A box that can hold small trinkets, such as a ring."
	icon = 'icons/obj/items.dmi'
	icon_state = "trinketbox"
	var/open = 0
	storage_slots = 1
	can_hold = list(
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

/obj/item/storage/trinketbox/attack_self()
	open = !open
	update_icon()
	..()

/obj/item/storage/trinketbox/examine(mob/user)
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
