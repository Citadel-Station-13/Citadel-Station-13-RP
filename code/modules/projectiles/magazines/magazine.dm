//An item that holds casings and can be used to put them inside guns
/obj/item/ammo_magazine
	name = "magazine"
	desc = "A magazine for some kind of gun."
	icon_state = ".357"
	icon = 'icons/obj/ammo.dmi'
	item_flags = ITEM_EASY_LATHE_DECONSTRUCT | ITEM_ENCUMBERS_WHILE_HELD
	slot_flags = SLOT_BELT
	item_state = "syringe_kit"
	materials_base = list(MAT_STEEL = 500)
	throw_force = 5
	w_class = ITEMSIZE_SMALL
	throw_speed = 4
	throw_range = 10
	preserve_item = 1

	//* dynamic config; can be changed at runtime freely
	/// is this a speedloader / supports being a speedloader?
	/// speedloader can only be used with internal ammo guns, and only if they allow speedloaders
	var/is_speedloader = FALSE
	/// is this a magazine despite being a speedloader? if set to TRUE, this still works with
	/// guns that accept magazines, even if it's a speedloader
	var/is_magazine_regardless = FALSE

	//* for speedloaders
	/// inherent speedloader delay, added to gun's speedloaders_delay
	var/speedloader_delay = 0

	//* ammo storage
	/// max ammo in us
	var/ammo_max = 7
	/// currently stored ammo; defaults to ammo_max if unset
	/// this is used to detect base material costs too, so
	/// if this is not set properly or you're abusing ammo_internal, bad stuff happens
	//  todo: way to use a different count for base material cost detection
	var/ammo_current
	/// can bullets be removed?
	var/ammo_removable = TRUE
	/// ammo list
	/// only instantiated when we need to for memory reasons
	/// should not be directly manipulated unless you know what you're doing.
	///
	/// spec:
	/// ammo_preload is what 'current ammo' is, type-wise
	/// ammo_internal is considered the list of 1 to n casings infront of ammo_current.
	var/list/ammo_internal
	/// caliber
	var/ammo_caliber
	/// preloaded ammo type
	var/ammo_preload

	//* Rendering
	/// use default rendering system
	/// in state moide, we will be "[base_icon_state]-[count]"
	/// in segements mode, we will repeatedly add "[base_icon_state]-ammo" with given offsets.
	/// overlay mode is not supported
	var/rendering_system = GUN_RENDERING_DISABLED
	/// number of states
	var/rendering_count = 0
	/// used internally to avoid appearance churn
	VAR_PRIVATE/rendering_count_current
	/// for offset mode: initial x offset
	var/rendering_segment_x_start
	/// for offset mode: initial y offset
	var/rendering_segment_y_start
	/// for offset mode: x offset
	var/rendering_segment_x_offset
	/// for offset mode: y offset
	var/rendering_segment_y_offset
	/// display special "[base_icon_state]-empty" if count == 0
	var/rendering_segment_use_empty = FALSE
	/// add a specific overlay as "[base_icon_state]-[state]", useful for denoting different magazines
	/// that look similar with a stripe
	var/rendering_static_overlay

/obj/item/ammo_magazine/Initialize(mapload)
	. = ..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)
	if(!isnull(rendering_static_overlay))
		add_overlay(rendering_static_overlay, TRUE)
	update_icon()

/obj/item/ammo_magazine/examine(mob/user, dist)
	. = ..()
	var/amount_left = amount_remaining()
	. += "There [(amount_left == 1)? "is" : "are"] [amount_left] round\s left!"

/**
 * peek top ammo casing
 */
/obj/item/ammo_magazine/proc/peek_top()
	#warn impl

/**
 * get and eject top casing
 */
/obj/item/ammo_magazine/proc/draw_top()
	#warn impl

/**
 * put a casing into top
 */
/obj/item/ammo_magazine/proc/insert_top(obj/item/ammo_casing/casing)
	#warn impl

/**
 * replace the first spent casing or insert top depending on if there's room
 */
/obj/item/ammo_magazine/proc/resupply_top(obj/item/ammo_casing/casing, replace_spent)
	#warn impl

/**
 * create casing when we draw into non-instantiated part of the mag
 */
/obj/item/ammo_magazine/proc/instantiate_casing()
	#warn impl

/**
 * instantiate the entire internal ammo list
 *
 * DO NOT USE UNLESS YOU KNOW WHAT YOU ARE DOING.
 */
/obj/item/ammo_magazine/proc/instantiate_internal_list()
	#warn impl


/obj/item/ammo_magazine/detect_material_base_costs()
	. = ..()
	if(isnull(ammo_preload))
		return
	var/shell_amount = isnull(ammo_current)? ammo_max : ammo_current
	if(!shell_amount)
		return
	var/obj/item/ammo_casing/casing = new ammo_preload
	if(!istype(casing))
		qdel(casing)
		return
	var/list/adding = casing.detect_material_base_costs()
	qdel(casing)
	for(var/key in adding)
		.[key] += adding[key] * shell_amount

#warn below

/obj/item/ammo_magazine/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/C = W
		if(C.caliber != caliber)
			to_chat(user, "<span class='warning'>[C] does not fit into [src].</span>")
			return
		if(stored_ammo.len >= ammo_max)
			to_chat(user, "<span class='warning'>[src] is full!</span>")
			return
		if(!user.attempt_insert_item_for_installation(C, src))
			return
		stored_ammo.Add(C)
		update_icon()
	if(istype(W, /obj/item/ammo_magazine/clip))
		var/obj/item/ammo_magazine/clip/L = W
		if(L.caliber != caliber)
			to_chat(user, "<span class='warning'>The ammo in [L] does not fit into [src].</span>")
			return
		if(!L.stored_ammo.len)
			to_chat(user, "<span class='warning'>There's no more ammo [L]!</span>")
			return
		if(stored_ammo.len >= ammo_max)
			to_chat(user, "<span class='warning'>[src] is full!</span>")
			return
		var/obj/item/ammo_casing/AC = L.stored_ammo[1] //select the next casing.
		L.stored_ammo -= AC //Remove this casing from loaded list of the clip.
		AC.loc = src
		stored_ammo.Insert(1, AC) //add it to the head of our magazine's list
		L.update_icon()
	playsound(user.loc, 'sound/weapons/flipblade.ogg', 50, 1)
	update_icon()

// This dumps all the bullets right on the floor
/obj/item/ammo_magazine/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(can_remove_ammo)
		if(!stored_ammo.len)
			to_chat(user, "<span class='notice'>[src] is already empty!</span>")
			return
		to_chat(user, "<span class='notice'>You empty [src].</span>")
		playsound(user.loc, "casing_sound", 50, 1)
		spawn(7)
			playsound(user.loc, "casing_sound", 50, 1)
		spawn(10)
			playsound(user.loc, "casing_sound", 50, 1)
		for(var/obj/item/ammo_casing/C in stored_ammo)
			C.loc = user.loc
			C.setDir(pick(GLOB.cardinal))
		stored_ammo.Cut()
		update_icon()
	else
		to_chat(user, "<span class='notice'>\The [src] is not designed to be unloaded.</span>")
		return

// This puts one bullet from the magazine into your hand
/obj/item/ammo_magazine/attack_hand(mob/user, list/params)
	if(can_remove_ammo)	// For Smart Magazines
		if(user.get_inactive_held_item() == src)
			if(stored_ammo.len)
				var/obj/item/ammo_casing/C = stored_ammo[stored_ammo.len]
				stored_ammo-=C
				user.put_in_hands(C)
				user.visible_message("\The [user] removes \a [C] from [src].", "<span class='notice'>You remove \a [C] from [src].</span>")
				update_icon()
				return
	..()


/**
 * puts a round into us, if possible
 * does not update icon by default!
 */
/obj/item/ammo_magazine/proc/load_casing(obj/item/ammo_casing/casing, replace_spent, update_icon)
	if(caliber)
		if(casing.caliber != caliber)
			return FALSE
	else
		if(casing.type != ammo_type)
			return FALSE
	if(length(stored_ammo) < ammo_max)
		// add
		casing.forceMove(src)
		if(QDELETED(casing))
			return FALSE
		stored_ammo += casing
		if(update_icon)
			update_icon()
		return TRUE
	else if(replace_spent)
		// replace
		var/obj/item/ammo_casing/enemy
		for(var/i in 1 to length(stored_ammo))
			enemy = stored_ammo[i]
			if(enemy.loaded())
				continue
			// this is the one
			casing.forceMove(src)
			if(QDELETED(casing))
				return FALSE
			stored_ammo[i] = casing
			// kick 'em out
			enemy.forceMove(drop_location())
			if(update_icon)
				update_icon()
			return TRUE
	return FALSE

/**
 * quickly gathers stuff from turf
 * does not sainty check
 *
 * @params
 * * where - the turf
 * * user - (optional) who's doing it
 *
 * @return number of rounds gathered
 */
/obj/item/ammo_magazine/proc/quick_gather(turf/where, mob/user)
	. = 0
	if(full())
		user?.action_feedback(SPAN_WARNING("[src] is full."), src)
		return
	for(var/obj/item/ammo_casing/casing in where)
		if(length(stored_ammo) >= ammo_max)
			break
		if(!casing.loaded())
			continue
		if(!load_casing(casing, FALSE))
			continue
		++.
	if(.)
		update_icon()
		user?.action_feedback(SPAN_NOTICE("You collect [.] rounds."), src)
	else
		user?.action_feedback(SPAN_WARNING("You fail to collect anything."), src)

#warn above

/obj/item/ammo_magazine/proc/is_full()
	return amount_remaining() >= ammo_max

/obj/item/ammo_magazine/proc/amount_remaining(live_only)
	if(!live_only)
		return ammo_current + length(ammo_internal)
	. = ammo_current
	for(var/obj/item/ammo_casing/casing as anything in ammo_internal)
		if(casing.loaded())
			.++

/obj/item/ammo_magazine/proc/amount_missing(live_only)
	return ammo_max - amount_remaining(live_only)

/obj/item/ammo_magazine/update_icon(updates)
	if(rendering_system == GUN_RENDERING_DISABLED)
		return ..()
	cut_overlays()
	var/count = round(amount_remaining() / ammo_max * rendering_count)
	if(count != rendering_count_current)
		return
	rendering_count_current = count
	switch(rendering_system)
		if(GUN_RENDERING_STATES)
			icon_state = "[base_icon_state]-[count]"
		if(GUN_RENDERING_SEGMENTS)
			if(count == 0)
				if(rendering_segment_use_empty)
					add_overlay("[base_icon_state]-empty")
			else
				var/px = rendering_segment_x_start
				var/py = rendering_segment_y_start
				for(var/i in 1 to count)
					var/image/seg = image(icon, icon_state = "[base_icon_state]-ammo")
					seg.pixel_x = px
					seg.pixel_y = py
					px += rendering_segment_x_offset
					py += rendering_segment_y_offset
	return ..()


