////////////// PTR-7 Anti-Materiel Rifle //////////////

/obj/item/gun/projectile/heavysniper/collapsible

/obj/item/gun/projectile/heavysniper/collapsible/verb/take_down()
	set category = "Object"
	set name = "Disassemble Rifle"

	var/mob/living/carbon/human/user = usr
	if(user.stat)
		return

	if(chambered)
		to_chat(user, "<span class='warning'>You need to empty the rifle to break it down.</span>")
	else
		collapse_rifle(user)

/obj/item/gun/projectile/heavysniper/proc/collapse_rifle(mob/user)
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

/obj/item/sniper_rifle_part/attack_self(mob/user as mob)
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
			var/obj/item/gun/projectile/heavysniper/collapsible/gun = new (get_turf(src), 0)
			if(usr && istype(usr, /mob/living/carbon/human))
				var/mob/living/carbon/human/user = usr
				user.temporarily_remove_from_inventory(src, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)
				user.put_in_hands_or_drop(gun)
			qdel(src)

/obj/item/gun/projectile/heavysniper/update_icon_state()
	. = ..()
	if(bolt_open)
		icon_state = "heavysniper-open"
	else
		icon_state = "heavysniper"
