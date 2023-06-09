/obj/item/gun/ballistic/bow
	name = "wooden bow"
	desc = "Some sort of primitive projectile weapon. Used to fire arrows."
	icon_state = "bow"
	item_state = "bow"
	w_class = ITEMSIZE_LARGE
	damage_force = 5
	load_method = SINGLE_CASING
	caliber = "arrow"
	max_shells = 1
	fire_sound = 'sound/weapons/bowfire.wav'
	slot_flags = SLOT_BACK
	pin = null
	no_pin_required = TRUE
	safety_state = GUN_SAFETY_OFF
	var/ready = 0

/obj/item/gun/ballistic/bow/unload_ammo(mob/user, var/allow_dump =0)
	var/obj/item/ammo_casing/C = loaded[loaded.len]
	loaded.len--
	user.put_in_hands(C)
	user.visible_message("[user] removes \a [C] from [src].", "<span class='notice'>You gently release the bowstring, removing the [C] from [src].</span>")
	src.ready = 0
	playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
	update_icon()

/obj/item/gun/ballistic/bow/load_ammo(var/obj/item/A, mob/user)
	if(istype(A, /obj/item/ammo_casing))
		var/obj/item/ammo_casing/C = A
		if(!(load_method & SINGLE_CASING) || caliber != C.caliber)
			return //incompatible
		if(loaded.len >= max_shells)
			to_chat(user, "<span class='warning'>[src] is full.</span>")
			return
		if(!user.attempt_insert_item_for_installation(C, src))
			return
		loaded.Insert(1, C) //add to the head of the list
		user.visible_message("[user] notches \the [C] into [src].", "<span class='notice'>You nock \the [C] into [src].</span>")
		playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
	else
		return
	update_icon()

/obj/item/gun/ballistic/bow/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(loaded.len)
		src.ready = 1
		to_chat(user, "<span class='notice'>You draw back the bowstring.</span>")
		playsound(src, 'sound/weapons/bowdraw.wav', 75, 0) //gets way too high pitched if the freq varies
		consume_next_projectile()
		update_icon()
	else
		return

/obj/item/gun/ballistic/bow/attack_hand(mob/user, list/params)
	if(user.get_inactive_held_item() == src)
		unload_ammo(user, allow_dump=0)
	else
		return ..()

/obj/item/gun/ballistic/bow/attackby(var/obj/item/A as obj, mob/user as mob)
	if (istype(A, /obj/item/ammo_casing/arrow))
		load_ammo(A, user)

/obj/item/gun/ballistic/bow/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	..()
	src.ready = 0
	update_icon()

/obj/item/gun/ballistic/bow/update_icon_state()
	. = ..()
	if(ready)
		icon_state = "[initial(icon_state)]_firing"
	else if(loaded.len)
		icon_state = "[initial(icon_state)]_loaded"
	else
		icon_state = initial(icon_state)

/obj/item/gun/ballistic/bow/ashen
	name = "bone bow"
	desc = "Some sort of primitive projectile weapon made of bone and sinew. Used to fire arrows."
	icon_state = "bow_ashen"
	item_state = "bow_ashen"
	damage_force = 8

/obj/item/gun/ballistic/bow/pipe
	name = "pipe bow"
	desc = "Some sort of pipe-based projectile weapon made of string and lots of bending. Used to fire arrows."
	icon_state = "bow_pipe"
	item_state = "bow_pipe"
	damage_force = 2
