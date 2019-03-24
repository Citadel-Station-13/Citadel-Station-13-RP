/obj/item/ammo_box
	name = "ammo box"
	desc = "A box of ammo, of some sort."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "357"
	flags = CONDUCT
	slot_flags = NONE
	item_state = "syringe_kit"
	throwforce = 5
	w_class = ITEMSIZE_SMALL
	throw_speed = 4
	throw_range = 10
	matter = list(DEFAULT_WALL_MATERIAL = 500)

	var/magazine_type = SPEEDLOADER
	var/caliber								//caliber is checked for match first, then ammo typepath == ammo_type
	var/list/_stored_ammo					//DO NOT DIRECTLY ACCESS. SPECIAL FORMAT! ONLY TRY TO SET IN COMPILE TIME IF YOU KNOW WHAT YOU ARE DOING!
	//stored_ammo list: see box_list_access for access procs but basically:
	//If it gets a projectile, it will return/eject that
	//If it gets a path, it'll instantiate it and return/eject that.
	//When it runs out, it'll use ammo_type and default_ammo_left.
	//DEFAULT_AMMO_LEFT IS ALWAYS ASSUMED TO BE THE LAST SHELLS IN THE SHELL ORDERING! If someone wants to change that, be my guest, but right now I don't see a need to get a headache over this.
	//If it's MAGAZINE_USE_COMPILETIME anything that tries to use ammo will deduct from default_ammo_left, however
	//this is all to save memory.
	var/max_ammo = 7
	var/default_ammo_left
	var/ammo_type = /obj/item/ammo_casing	//Initially loaded type
	var/open_container = TRUE				//Can remove ammo by hand.
	var/default_fire_order = MAGAZINE_ORDER_FILO

/obj/item/ammo_box/Initialize()
	. = ..()
	initialize_stored_ammo()
	update_icon()

/obj/item/ammo_box/proc/instantiate_casing(casing_type, location = src)
	return new casing_type(location)

/obj/item/ammo_box/handle_atom_del(atom/A)
	_stored_ammo -= A						//one of the only exceptions to the do not directly access rule.
	update_icon()

/obj/item/ammo_box/rejuvenate(fully_heal, admin_revive)
	. = ..()
	if(fully_heal)
		set_full()

/obj/item/ammo_box/proc/set_full()
	default_ammo_left = initial(default_ammo_left)

/obj/item/ammo_box/proc/set_empty()
	_stored_ammo = null
	default_ammo_left = 0

/obj/item/ammo_box/attack_self(mob/user)
	. = ..()
	if(. & COMPONENT_NO_INTERACT)
		return
	if(open_container)
		var/obj/item/ammo_casing/A = default_expend_casing()
		if(A)
			A.forceMove(drop_location())
			if(!user.is_holding(src) || !user.put_in_hands(A))
				A.bounce_away(FALSE, NONE)
			playsound(src, 'sound/weapons/bulletinsert.ogg', 60, TRUE)
			to_chat(user, "<span class='notice'>You remove a round from [src].</span>")
			update_icon()
	else
		to_chat(user, "<span class='notice'>[src] is not designed to be unloaded.</span>")

/obj/item/ammo_box/proc/dump_out()
	var/atom/drop = drop_location()
	var/obj/item/ammu_casing/A
	do
		A = default_expend_round()
		A.forceMove(drop)
	while(A)
	update_icon()

// This dumps all the bullets right on the floor
/obj/item/ammo_box/AltClick(mob/user)
	. = ..()
	if(open_container)
		if(!ammo_left)
			to_chat(user, "<span class='notice'>[src] is already empty!</span>")
			return
		to_chat(user, "<span class='notice'>You empty [src].</span>")
		playsound(src, "casing_sound", 50, 1)
		dump_out()
	else
		to_chat(user, "<span class='notice'>[src] is not designed to be unloaded.</span>")

/obj/item/ammo_box/examine(mob/user)
	. = ..()
	to_chat(user, "<span class='notice'>Alt click to retrieve all rounds. Use in hand to take out one round.</span>")

/obj/item/ammo_box/proc/give_round(obj/item/ammu_casing/R, replace_spent = FALSE)
	if(!R)
		return FALSE
	if(caliber)
		if(R.caliber != caliber)
			return FALSE
	else
		if(R.type != ammo_type)
			return FALSE
	if(space_left() > 0)
		R.forceMove(src)
		default_top_casing(R)
	else if(replace_spent)
		var/obj/item/ammu_casing/C = replace_round(get_index_first_spent(), R)
		if(C)
			C.forceMove(drop_location())
			R.forceMove(src)
			return TRUE
	return FALSE

/obj/item/ammo_box/proc/give_rounds(list/obj/item/ammu_casing/L, replace_spent = FALSE)
	if(!LAZYLEN(L))
		return 0
	for(var/i in L)
		var/obj/item/ammu_casing/C = i
		if(default_insert_casing(C))
			C.forceMove(src)
			L -= C
			.++
	if(L.len && replace_spent)		//still more, and we can try replacing spent
		var/list/indices = get_indices_spent()
		var/index = 1
		var/max_index = indices.len
		for(var/i in L)
			if(index > max_index)
				return
			var/obj/item/ammu_casing/C = i
			var/obj/item/ammu_casing/old = replace_casing(indices[index++], C)
			if(old)
				old.forceMove(drop_location())
				C.forceMove(src)
				.++
			else
				return

////////////////////////////////////////
///////////////////////



/obj/item/ammo_magazine/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/C = W
		if(C.caliber != caliber)
			to_chat(user, "<span class='warning'>[C] does not fit into [src].</span>")
			return
		if(stored_ammo.len >= max_ammo)
			to_chat(user, "<span class='warning'>[src] is full!</span>")
			return
		user.remove_from_mob(C)
		C.loc = src
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

	var/multiple_sprites = 0
	//because BYOND doesn't support numbers as keys in associative lists
	var/list/icon_keys = list()		//keys
	var/list/ammo_states = list()	//values

/obj/item/ammo_magazine/New()
	..()
	if(multiple_sprites)
		initialize_magazine_icondata(src)

//yeah this is totally not copied from energy guns.
	var/automatic_ammo_overlays = TRUE
	var/shaded_ammo_levels = TRUE			//true = use ratios, false = use overlays + offsets
	var/ammo_offset_x = 0
	var/ammo_offset_y = -1
	var/ammo_sections = 4
	var/old_ratio = 0

/obj/item/ammo_box/update_icon()
	if(!automatic_ammo_overlays)
		return
	cut_overlays()


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

/obj/item/ammo_magazine/examine(mob/user)
	..()
	to_chat(user, "There [(stored_ammo.len == 1)? "is" : "are"] [stored_ammo.len] round\s left!")

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





////////////////////////////////////////////////////
//Boxes of ammo
/obj/item/ammo_box
	name = "ammo box (null_reference_exception)"
	desc = "A box of ammo."
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	materials = list(MAT_METAL = 30000)
	throwforce = 2
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	var/multiple_sprites = 0
	var/multiload = 1



/obj/item/ammo_box/proc/can_load(mob/user)
	return 1

/obj/item/ammo_box/attackby(obj/item/A, mob/user, params, silent = FALSE, replace_spent = 0)
	var/num_loaded = 0
	if(!can_load(user))
		return
	if(istype(A, /obj/item/ammo_box))
		var/obj/item/ammo_box/AM = A
		for(var/obj/item/ammo_casing/AC in AM.stored_ammo)
			var/did_load = give_round(AC, replace_spent)
			if(did_load)
				AM.stored_ammo -= AC
				num_loaded++
			if(!did_load || !multiload)
				break
	if(istype(A, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/AC = A
		if(give_round(AC, replace_spent))
			user.transferItemToLoc(AC, src, TRUE)
			num_loaded++

	if(num_loaded)
		if(!silent)
			to_chat(user, "<span class='notice'>You load [num_loaded] shell\s into \the [src]!</span>")
			playsound(src, 'sound/weapons/bulletinsert.ogg', 60, 1)
		A.update_icon()
		update_icon()

	return num_loaded



/obj/item/ammo_box/update_icon()
	var/shells_left = stored_ammo.len
	switch(multiple_sprites)
		if(1)
			icon_state = "[initial(icon_state)]-[shells_left]"
		if(2)
			icon_state = "[initial(icon_state)]-[shells_left ? "[max_ammo]" : "0"]"
	desc = "[initial(desc)] There [(shells_left == 1) ? "is" : "are"] [shells_left] shell\s left!"


/obj/item/ammo_casing/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/ammo_box))
		var/obj/item/ammo_box/box = I
		if(isturf(loc))
			var/boolets = 0
			for(var/obj/item/ammo_casing/bullet in loc)
				if (box.stored_ammo.len >= box.max_ammo)
					break
				if (bullet.BB)
					if (box.give_round(bullet, 0))
						boolets++
				else
					continue
			if (boolets > 0)
				box.update_icon()
				to_chat(user, "<span class='notice'>You collect [boolets] shell\s. [box] now contains [box.stored_ammo.len] shell\s.</span>")
			else
				to_chat(user, "<span class='warning'>You fail to collect anything!</span>")
	else
		return ..()








