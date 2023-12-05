/obj/item/gun/projectile/ballistic/heavysniper
	name = "anti-materiel rifle"
	desc = "A portable anti-armour rifle fitted with a scope, the HI PTR-7 Rifle was originally designed to used against armoured exosuits. It is capable of punching through windows and non-reinforced walls with ease. Fires armor piercing 12.7mm shells."
	icon_state = "heavysniper"
	item_state = "heavysniper"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "l6closed-empty", SLOT_ID_LEFT_HAND = "l6closed-empty") // placeholder
	w_class = ITEMSIZE_HUGE // So it can't fit in a backpack.
	damage_force = 10
	heavy = TRUE
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	caliber = "12.7mm"
	recoil = 5 //extra kickback
	handle_casings = HOLD_CASINGS
	load_method = SINGLE_CASING
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/a127
	projectile_type = /obj/projectile/bullet/rifle/a127
	load_sound = 'sound/weapons/guns/interaction/rifle_load.ogg'
	accuracy = -45
	scoped_accuracy = 95
	one_handed_penalty = 90
	var/bolt_open = 0

/obj/item/gun/projectile/ballistic/heavysniper/update_icon()
	if(bolt_open)
		icon_state = "heavysniper-open"
	else
		icon_state = "heavysniper"

/obj/item/gun/projectile/ballistic/heavysniper/attack_self(mob/user)
	. = ..()
	if(.)
		return
	playsound(src.loc, 'sound/weapons/flipblade.ogg', 50, 1)
	bolt_open = !bolt_open
	if(bolt_open)
		if(chambered)
			to_chat(user, "<span class='notice'>You work the bolt open, ejecting [chambered]!</span>")
			chambered.loc = get_turf(src)
			loaded -= chambered
			chambered = null
		else
			to_chat(user, "<span class='notice'>You work the bolt open.</span>")
		playsound(src.loc, 'sound/weapons/guns/interaction/rifle_boltback.ogg', 50, 1)
	else
		to_chat(user, "<span class='notice'>You work the bolt closed.</span>")
		playsound(src.loc, 'sound/weapons/guns/interaction/rifle_boltforward.ogg', 50, 1)
		bolt_open = 0
	add_fingerprint(user)
	update_icon()

/obj/item/gun/projectile/ballistic/heavysniper/special_check(mob/user)
	if(bolt_open)
		to_chat(user, "<span class='warning'>You can't fire [src] while the bolt is open!</span>")
		return 0
	return ..()

/obj/item/gun/projectile/ballistic/heavysniper/load_ammo(var/obj/item/A, mob/user)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/ballistic/heavysniper/unload_ammo(mob/user, var/allow_dump=1)
	if(!bolt_open)
		return
	..()

/obj/item/gun/projectile/ballistic/heavysniper/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)

////////////// Dragunov Sniper Rifle //////////////

/obj/item/gun/projectile/ballistic/SVD
	name = "\improper Dragunov"
	desc = "The SVD, also known as the Dragunov, is mass produced with an Optical Sniper Sight so simple that even Ivan can use it. Too bad for you that the inscriptions are written in Russian. Uses 7.62mm rounds."
	icon_state = "SVD"
	item_state = "SVD"
	w_class = ITEMSIZE_HUGE // So it can't fit in a backpack.
	damage_force = 10
	slot_flags = SLOT_BACK // Needs a sprite.
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	caliber = "7.62mm"
	load_method = MAGAZINE
	accuracy = -45 //shooting at the hip
	scoped_accuracy = 95
	heavy = TRUE
//	requires_two_hands = 1
	one_handed_penalty = 60 // The weapon itself is heavy, and the long barrel makes it hard to hold steady with just one hand.
	fire_sound = 'sound/weapons/Gunshot_SVD.ogg' // Has a very unique sound.
	magazine_type = /obj/item/ammo_magazine/m762svd
	allowed_magazines = list(/obj/item/ammo_magazine/m762svd)

/obj/item/gun/projectile/ballistic/SVD/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "SVD"
	else
		icon_state = "SVD-empty"

/obj/item/gun/projectile/ballistic/SVD/verb/scope()
	set category = "Object"
	set name = "Use Scope"
	set popup_menu = 1

	toggle_scope(2.0)

/obj/item/gun/projectile/ballistic/SVD/taj
	name = "Adhomai sniper rifle"
	desc = "The Hotaki Marksman rifle, in stark contrast to the usual products of Hotak's arms, is an elegant and precise rifle that has taken the lives of many high value targets in the name of defending the Democratic People's Republic of Adhomai."
	icon_state = "svd-taj"
	item_state = "svd-taj"
	wielded_item_state = "svd-taj-wielded"


/obj/item/gun/projectile/ballistic/SVD/taj/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "SVD-taj"
	else
		icon_state = "SVD-taj-empty"

/obj/item/gun/projectile/ballistic/heavysniper/collapsible

/obj/item/gun/projectile/ballistic/heavysniper/collapsible/verb/take_down()
	set category = "Object"
	set name = "Disassemble Rifle"

	var/mob/living/carbon/human/user = usr
	if(user.stat)
		return

	if(chambered)
		to_chat(user, "<span class='warning'>You need to empty the rifle to break it down.</span>")
	else
		collapse_rifle(user)

/obj/item/gun/projectile/ballistic/heavysniper/proc/collapse_rifle(mob/user)
	to_chat(user, "<span class='warning'>You begin removing \the [src]'s barrel.</span>")
	if(do_after(user, 40))
		to_chat(user, "<span class='warning'>You remove \the [src]'s barrel.</span>")
		qdel(src)
		var/obj/item/barrel = new /obj/item/sniper_rifle_part/barrel(user)
		var/obj/item/sniper_rifle_part/assembly = new /obj/item/sniper_rifle_part/trigger_group(user)
		var/obj/item/sniper_rifle_part/stock/stock = new(assembly)
		assembly.stock = stock
		assembly.part_count = 2
		assembly.update_build()
		user.put_in_hands(assembly) || assembly.dropInto(user.loc)
		user.put_in_hands(barrel) || barrel.dropInto(user.loc)


/obj/item/sniper_rifle_part
	name = "AM rifle part"
	desc = "A part of an antimateriel rifle."

	w_class = ITEMSIZE_NORMAL

	icon = 'icons/obj/gun/ballistic.dmi'

	var/obj/item/sniper_rifle_part/barrel = null
	var/obj/item/sniper_rifle_part/stock = null
	var/obj/item/sniper_rifle_part/trigger_group = null
	var/part_count = 1


/obj/item/sniper_rifle_part/barrel
	name = "AM rifle barrel"
	icon_state = "heavysniper-barrel"

/obj/item/sniper_rifle_part/barrel/Initialize(mapload)
	. = ..()
	barrel = src

/obj/item/sniper_rifle_part/stock
	name = "AM rifle stock"
	icon_state = "heavysniper-stock"

/obj/item/sniper_rifle_part/stock/Initialize(mapload)
	. = ..()
	stock = src

/obj/item/sniper_rifle_part/trigger_group
	name = "AM rifle trigger assembly"
	icon_state = "heavysniper-trig"

/obj/item/sniper_rifle_part/trigger_group/Initialize(mapload)
	. = ..()
	trigger_group = src

/obj/item/sniper_rifle_part/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(part_count == 1)
		to_chat(user, "<span class='warning'>You can't disassemble this further!</span>")
		return

	to_chat(user, "<span class='notice'>You start disassembling \the [src].</span>")
	if(!do_after(user, 40))
		return

	to_chat(user, "<span class='notice'>You disassemble \the [src].</span>")
	for(var/obj/item/sniper_rifle_part/P in list(barrel, stock, trigger_group))
		if(P.barrel != P)
			P.barrel = null
		if(P.stock != P)
			P.stock = null
		if(P.trigger_group != P)
			P.trigger_group = null
		if(P != src)
			user.put_in_hands(P) || P.dropInto(loc)
		P.part_count = 1

	update_build()

/obj/item/sniper_rifle_part/attackby(var/obj/item/sniper_rifle_part/A as obj, mob/user as mob)

	to_chat(user, "<span class='notice'>You begin adding \the [A] to \the [src].</span>")
	if(!do_after(user, 30))
		return

	if(istype(A, /obj/item/sniper_rifle_part/trigger_group))
		if(A.part_count > 1 && src.part_count > 1)
			to_chat(user, "<span class='warning'>Disassemble one of these parts first!</span>")
			return

		if(!trigger_group)
			if(!user.attempt_insert_item_for_installation(A, src))
				return
			trigger_group = A
		else
			to_chat(user, "<span class='warning'>There's already a trigger group!</span>")
			return

	else if(istype(A, /obj/item/sniper_rifle_part/barrel))
		if(!barrel)
			if(!user.attempt_insert_item_for_installation(A, src))
				return
			barrel = A
		else
			to_chat(user, "<span class='warning'>There's already a barrel!</span>")
			return

	else if(istype(A, /obj/item/sniper_rifle_part/stock))
		if(!stock)
			if(!user.attempt_insert_item_for_installation(A, src))
				return
			stock = A
		else
			to_chat(user, "<span class='warning'>There's already a stock!</span>")
			return

	A.forceMove(src)
	to_chat(user, "<span class='notice'>You install \the [A].</span>")

	if(A.barrel && !src.barrel)
		src.barrel = A.barrel
	if(A.stock && !src.stock)
		src.stock = A.stock
	if(A.trigger_group && !src.trigger_group)
		src.trigger_group = A.trigger_group


	part_count = A.part_count + src.part_count
	update_build(user)

/obj/item/sniper_rifle_part/proc/update_build()
	switch(part_count)
		if(1)
			name = initial(name)
			w_class = ITEMSIZE_NORMAL
			icon_state = initial(icon_state)
		if(2)
			if(barrel && trigger_group)
				name = "AM rifle barrel-trigger assembly"
				icon_state = "heavysniper-trigbar"
			else if(stock && trigger_group)
				name = "AM rifle stock-trigger assembly"
				icon_state = "heavysniper-trigstock"
			else if(stock && barrel)
				name = "AM rifle stock-barrel assembly"
				icon_state = "heavysniper-barstock"
			w_class = ITEMSIZE_LARGE

		if(3)
			var/obj/item/gun/projectile/ballistic/heavysniper/collapsible/gun = new (get_turf(src), 0)
			if(usr && istype(usr, /mob/living/carbon/human))
				var/mob/living/carbon/human/user = usr
				user.temporarily_remove_from_inventory(src, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)
				user.put_in_hands_or_drop(gun)
			qdel(src)

/obj/item/gun/projectile/ballistic/heavysniper/update_icon_state()
	. = ..()
	if(bolt_open)
		icon_state = "heavysniper-open"
	else
		icon_state = "heavysniper"
