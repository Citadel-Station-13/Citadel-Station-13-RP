//An item that holds casings and can be used to put them inside guns
/obj/item/ammo_magazine
	name = "magazine"
	desc = "A magazine for some kind of gun."
	icon_state = ".357"
	icon = 'icons/obj/ammo.dmi'
	item_flags = ITEM_EASY_LATHE_DECONSTRUCT
	slot_flags = SLOT_BELT
	item_state = "syringe_kit"
	materials = list(MAT_STEEL = 500)
	throw_force = 5
	w_class = ITEMSIZE_SMALL
	throw_speed = 4
	throw_range = 10
	preserve_item = 1

	var/list/stored_ammo = list()
	var/mag_type = SPEEDLOADER //ammo_magazines can only be used with compatible guns. This is not a bitflag, the load_method var on guns is.
	var/caliber = ".357"
	var/max_ammo = 7

	var/ammo_type = /obj/item/ammo_casing //ammo type that is initially loaded
	var/initial_ammo = null

	var/can_remove_ammo = TRUE	// Can this thing have bullets removed one-by-one? As of first implementation, only affects smart magazines

	var/multiple_sprites = 0
	//because BYOND doesn't support numbers as keys in associative lists
	var/list/icon_keys = list()		//keys
	var/list/ammo_states = list()	//values
	var/ammo_mark = null			//Used for overlays simulated paint or tape bands on magazines. Cuts down on bloat.

/obj/item/ammo_magazine/Initialize(mapload)
	. = ..()
	pixel_x = rand(-5, 5)
	pixel_y = rand(-5, 5)
	if(multiple_sprites)
		initialize_magazine_icondata(src)

	if(isnull(initial_ammo))
		initial_ammo = max_ammo

	if(initial_ammo)
		for(var/i in 1 to initial_ammo)
			stored_ammo += new ammo_type(src)
	update_icon()

/obj/item/ammo_magazine/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/C = W
		if(C.caliber != caliber)
			to_chat(user, "<span class='warning'>[C] does not fit into [src].</span>")
			return
		if(stored_ammo.len >= max_ammo)
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
		if(stored_ammo.len >= max_ammo)
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

/obj/item/ammo_magazine/update_icon()
	if(multiple_sprites)
		//find the lowest key greater than or equal to stored_ammo.len
		var/new_state = null
		for(var/idx in 1 to icon_keys.len)
			var/ammo_count = icon_keys[idx]
			if (ammo_count >= stored_ammo.len)
				new_state = ammo_states[idx]
				break
		icon_state = (new_state)? new_state : initial(icon_state)
	if(ammo_mark)
		add_overlay("[initial(icon_state)]_[ammo_mark]")

/obj/item/ammo_magazine/examine(mob/user)
	. = ..()
	. += "There [(stored_ammo.len == 1)? "is" : "are"] [stored_ammo.len] round\s left!"

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
	if(length(stored_ammo) < max_ammo)
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
		if(length(stored_ammo) >= max_ammo)
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

/obj/item/ammo_magazine/proc/full()
	return length(stored_ammo) >= max_ammo

/obj/item/ammo_magazine/proc/remaining()
	return length(stored_ammo)

/obj/item/ammo_magazine/proc/missing()
	return max_ammo - length(stored_ammo)

//magazine icon state caching
/var/global/list/magazine_icondata_keys = list()
/var/global/list/magazine_icondata_states = list()

/proc/initialize_magazine_icondata(var/obj/item/ammo_magazine/M)
	var/typestr = "[M.type]"
	if(!(typestr in magazine_icondata_keys) || !(typestr in magazine_icondata_states))
		magazine_icondata_cache_add(M)

	M.icon_keys = magazine_icondata_keys[typestr]
	M.ammo_states = magazine_icondata_states[typestr]

/proc/magazine_icondata_cache_add(var/obj/item/ammo_magazine/M)
	var/list/icon_keys = list()
	var/list/ammo_states = list()
	var/list/states = icon_states(M.icon)
	for(var/i = 0, i <= M.max_ammo, i++)
		var/ammo_state = "[M.icon_state]-[i]"
		if(ammo_state in states)
			icon_keys += i
			ammo_states += ammo_state

	magazine_icondata_keys["[M.type]"] = icon_keys
	magazine_icondata_states["[M.type]"] = ammo_states
