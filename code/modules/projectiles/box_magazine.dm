/obj/item/ammo_box
	name = "ammo box"
	desc = "A box of ammo, of some sort."
	icon =
	icon_state =
	flags = CONDUCT
	slot_flags = NONE
	item_state = "syringe_kit"
	throwforce = 5
	w_class = ITEMSIZE_SMALL
	throw_speed = 4
	throw_range = 10
	matter = list(DEFAULT_WALL_MATERIAL = 500)

	var/magazine_type = SPEEDLOADER
	var/caliber = CALIBER_357
	var/list/stored_ammo					//DO NOT DIRECTLY ACCESS. SPECIAL FORMAT! ONLY TRY TO SET IN COMPILE TIME IF YOU KNOW WHAT YOU ARE DOING!
	//stored_ammo list: The first loaded (so index 1) will be the first out.
	//If it gets a projectile, it will return/eject that
	//If it's something like type, number, where the next index after the type is the number, it will deduct one if ejecting, or instantiate it and shift the rest backwards to put the new casing on top
	//this is all to save memory.
	var/max_ammo = 7
	var/starting_ammo = 7
	var/ammo_type = /obj/item/ammo_casing	//Initially loaded type
	var/open_container = TRUE				//Can remove ammo by hand.

/obj/item/ammo_box/Initialize()

/obj/item/ammo_box/proc/return_top_casing()
	if(!LAZYLEN(stored_ammo))
		return
	var/obj/item/ammu_casing/C = stored_ammo[1]
	if(istype(C))
		return C
	else if(ispath(C))
		var/amount_left = stored_ammo[2]
		if(amount_left

////////////////////////////////////////


	var/multiple_sprites = 0
	//because BYOND doesn't support numbers as keys in associative lists
	var/list/icon_keys = list()		//keys
	var/list/ammo_states = list()	//values

/obj/item/ammo_magazine/New()
	..()
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

// This dumps all the bullets right on the floor
/obj/item/ammo_magazine/attack_self(mob/user)
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
			C.setDir(pick(cardinal))
		stored_ammo.Cut()
		update_icon()
	else
		to_chat(user, "<span class='notice'>\The [src] is not designed to be unloaded.</span>")
		return

// This puts one bullet from the magazine into your hand
/obj/item/ammo_magazine/attack_hand(mob/user)
	if(can_remove_ammo)	// For Smart Magazines
		if(user.get_inactive_hand() == src)
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
	icon = 'icons/obj/ammo.dmi'
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BELT
	item_state = "syringe_kit"
	lefthand_file = 'icons/mob/inhands/equipment/medical_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/medical_righthand.dmi'
	materials = list(MAT_METAL = 30000)
	throwforce = 2
	w_class = WEIGHT_CLASS_TINY
	throw_speed = 3
	throw_range = 7
	var/list/stored_ammo = list()
	var/ammo_type = /obj/item/ammo_casing
	var/max_ammo = 7
	var/multiple_sprites = 0
	var/caliber
	var/multiload = 1
	var/start_empty = 0
	var/list/bullet_cost
	var/list/base_cost// override this one as well if you override bullet_cost

/obj/item/ammo_box/Initialize()
	. = ..()
	if (!bullet_cost)
		for (var/material in materials)
			var/material_amount = materials[material]
			LAZYSET(base_cost, material, (material_amount * 0.10))

			material_amount *= 0.90 // 10% for the container
			material_amount /= max_ammo
			LAZYSET(bullet_cost, material, material_amount)
	if(!start_empty)
		for(var/i = 1, i <= max_ammo, i++)
			stored_ammo += new ammo_type(src)
	update_icon()

/obj/item/ammo_box/proc/get_round(keep = 0)
	if (!stored_ammo.len)
		return null
	else
		var/b = stored_ammo[stored_ammo.len]
		stored_ammo -= b
		if (keep)
			stored_ammo.Insert(1,b)
		return b

/obj/item/ammo_box/proc/give_round(obj/item/ammo_casing/R, replace_spent = 0)
	// Boxes don't have a caliber type, magazines do. Not sure if it's intended or not, but if we fail to find a caliber, then we fall back to ammo_type.
	if(!R || (caliber && R.caliber != caliber) || (!caliber && R.type != ammo_type))
		return 0

	if (stored_ammo.len < max_ammo)
		stored_ammo += R
		R.forceMove(src)
		return 1

	//for accessibles magazines (e.g internal ones) when full, start replacing spent ammo
	else if(replace_spent)
		for(var/obj/item/ammo_casing/AC in stored_ammo)
			if(!AC.BB)//found a spent ammo
				stored_ammo -= AC
				AC.forceMove(get_turf(src.loc))

				stored_ammo += R
				R.forceMove(src)
				return 1

	return 0

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

/obj/item/ammo_box/attack_self(mob/user)
	var/obj/item/ammo_casing/A = get_round()
	if(A)
		A.forceMove(drop_location())
		if(!user.is_holding(src) || !user.put_in_hands(A))	//incase they're using TK
			A.bounce_away(FALSE, NONE)
		playsound(src, 'sound/weapons/bulletinsert.ogg', 60, TRUE)
		to_chat(user, "<span class='notice'>You remove a round from [src]!</span>")
		update_icon()

/obj/item/ammo_box/update_icon()
	var/shells_left = stored_ammo.len
	switch(multiple_sprites)
		if(1)
			icon_state = "[initial(icon_state)]-[shells_left]"
		if(2)
			icon_state = "[initial(icon_state)]-[shells_left ? "[max_ammo]" : "0"]"
	desc = "[initial(desc)] There [(shells_left == 1) ? "is" : "are"] [shells_left] shell\s left!"
	for (var/material in bullet_cost)
		var/material_amount = bullet_cost[material]
		material_amount = (material_amount*stored_ammo.len) + base_cost[material]
		materials[material] = material_amount

//Behavior for magazines
/obj/item/ammo_box/magazine/proc/ammo_count(countempties = TRUE)
	var/boolets = 0
	for(var/obj/item/ammo_casing/bullet in stored_ammo)
		if(bullet && (bullet.BB || countempties))
			boolets++
	return boolets

/obj/item/ammo_box/magazine/proc/empty_magazine()
	var/turf_mag = get_turf(src)
	for(var/obj/item/ammo in stored_ammo)
		ammo.forceMove(turf_mag)
		stored_ammo -= ammo

/obj/item/ammo_box/magazine/handle_atom_del(atom/A)
	stored_ammo -= A
	update_icon()








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



