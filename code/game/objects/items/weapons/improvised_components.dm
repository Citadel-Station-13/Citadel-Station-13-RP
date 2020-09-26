/obj/item/material/butterflyconstruction
	name = "unfinished concealed knife"
	desc = "An unfinished concealed knife, it looks like the screws need to be tightened."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "butterflystep1"
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/material/butterflyconstruction/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_screwdriver())
		to_chat(user, "You finish the concealed blade weapon.")
		playsound(src, W.usesound, 50, 1)
		new /obj/item/material/butterfly(user.loc, material.name)
		qdel(src)
		return

/obj/item/material/butterflyblade
	name = "knife blade"
	desc = "A knife blade. Unusable as a weapon without a grip."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "butterfly2"
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/material/butterflyhandle
	name = "concealed knife grip"
	desc = "A plasteel grip with screw fittings for a blade."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "butterfly1"
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/material/butterflyhandle/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/material/butterflyblade))
		var/obj/item/material/butterflyblade/B = W
		to_chat(user, "You attach the two concealed blade parts.")
		new /obj/item/material/butterflyconstruction(user.loc, B.material.name)
		qdel(W)
		qdel(src)
		return

/obj/item/material/wirerod
	name = "wired rod"
	desc = "A rod with some wire wrapped around the top. It'd be easy to attach something to the top bit."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "wiredrod"
	item_state = "rods"
	force = 8
	throwforce = 10
	w_class = ITEMSIZE_NORMAL
	attack_verb = list("hit", "bludgeoned", "whacked", "bonked")
	force_divisor = 0.1
	thrown_force_divisor = 0.1

/obj/item/material/wirerod/attackby(var/obj/item/I, mob/user as mob)
	..()
	var/obj/item/finished
	if(istype(I, /obj/item/material/shard) || istype(I, /obj/item/material/butterflyblade))
		var/obj/item/material/tmp_shard = I
		finished = new /obj/item/material/twohanded/spear(get_turf(user), tmp_shard.material.name)
		to_chat(user, "<span class='notice'>You fasten \the [I] to the top of the rod with the cable.</span>")
	else if(I.is_wirecutter())
		finished = new /obj/item/melee/baton/cattleprod(get_turf(user))
		to_chat(user, "<span class='notice'>You fasten the wirecutters to the top of the rod with the cable, prongs outward.</span>")
	if(finished)
		user.drop_from_inventory(src)
		user.drop_from_inventory(I)
		qdel(I)
		qdel(src)
		user.put_in_hands(finished)
	update_icon(user)


//Sledgehammer construction

/obj/item/material/hammer_head
	name = "hammer head"
	desc = "A rectangular hammer head. Feels very heavy in your hand.."
	icon = 'icons/obj/buildingobject.dmi'
	icon_state = "hammer_construction_1"
	description_info = "You need rods, metal, a wrench and welding fuel to finish this up."

	var/construction_stage = 1

/obj/item/material/hammer_head/attackby(var/obj/item/thing, var/mob/user)

	if(istype(thing, /obj/item/stack/rods) && construction_stage == 1)
		var/obj/item/stack/rods = thing
		if(rods.get_amount() < 4)
			to_chat(user, "<span class='warning'>You need at least 4 rods for this task.</span>")
			return
		rods.use(4)
		user.visible_message("<span class='notice'>\The [user] puts some rods together in \the [src] hole.</span>")
		increment_construction_stage()
		return

	if(istype(thing, /obj/item/weldingtool) && construction_stage == 2)
		var/obj/item/weldingtool/welder = thing
		if(!welder.isOn())
			to_chat(user, "<span class='warning'>Turn it on first!</span>")
			return

		if(!welder.remove_fuel(0,user))
			to_chat(user, "<span class='warning'>You need more fuel!</span>")
			return

		user.visible_message("<span class='notice'>\The [user] welds the rods to the head \the [src] together with \the [thing].</span>")
		playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
		spawn(5)
		increment_construction_stage()
		return

	if(istype(thing, /obj/item/stack/rods) && construction_stage == 3)
		var/obj/item/stack/rods = thing
		if(rods.get_amount() < 4)
			to_chat(user, "<span class='warning'>You need at least 4 rods for this task.</span>")
			return
		rods.use(4)
		user.visible_message("<span class='notice'>\The [user] jams \the [thing]'s into \the [src].</span>")
		increment_construction_stage()
		return

	if(istype(thing, /obj/item/weldingtool) && construction_stage == 4)
		var/obj/item/weldingtool/welder = thing

		if(!welder.isOn())
			to_chat(user, "<span class='warning'>Turn it on first!</span>")
			return

		if(!welder.remove_fuel(0,user))
			to_chat(user, "<span class='warning'>You need more fuel!</span>")
			return

		user.visible_message("<span class='notice'>\The [user] welds the rods together of the handle into place, forming a long irregular shaft.</span>")
		playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)

		increment_construction_stage()
		return

	if(istype(thing, /obj/item/stack/material) && construction_stage == 5)
		var/obj/item/stack/material/reinforcing = thing
		var/datum/material/reinforcing_with = reinforcing.get_material()
		if(reinforcing_with.name == DEFAULT_WALL_MATERIAL) // Steel
			if(reinforcing.get_amount() < 3)
				to_chat(user, "<span class='warning'>You need at least 3 [reinforcing.singular_name]\s for this task.</span>")
				return
			reinforcing.use(3)
			user.visible_message("<span class='notice'>\The [user] shapes some metal sheets around the rods.</span>")
			increment_construction_stage()
			return

	if(istype(thing, /obj/item/weldingtool) && construction_stage == 6)
		var/obj/item/weldingtool/welder = thing
		if(!welder.isOn())
			to_chat(user, "<span class='warning'>Turn it on first!</span>")
			return
		if(!welder.remove_fuel(10,user))
			to_chat(user, "<span class='warning'>You need more fuel!</span>")
			return
		user.visible_message("<span class='notice'>\The [user] heats up the metal sheets until it glows red.</span>")
		playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
		increment_construction_stage()
		return


	if(istype(thing, /obj/item/tool/wrench) && construction_stage == 7)
		user.visible_message("<span class='notice'>\The [user] whacks at \the [src] like a caveman, shaping the metal with \the [thing] into a rough handle, finishing it off.</span>")
		increment_construction_stage()
		playsound(src.loc, 'sound/weapons/smash5.ogg', 100, 1)
		var/obj/item/material/twohanded/sledgehammer/sledge = new(loc, material.name)
		var/put_in_hands
		var/mob/M = src.loc
		if(istype(M))
			put_in_hands = M == user
			M.drop_from_inventory(src)
		if(put_in_hands)
			user.put_in_hands(sledge)
		qdel(src)
		return


	return ..()

/obj/item/material/hammer_head/proc/increment_construction_stage()
	if(construction_stage < 7)
		construction_stage++
	icon_state = "hammer_construction_[construction_stage]"

/obj/item/material/hammer_head/examine(var/mob/user)
	. = ..()
	if(.)
		switch(construction_stage) //BLACKMAJOR YOU KNOW YOU SHOULDN'T INLINE SWITCH STATEMENTS AAAA
			if(1)
				. += "<span class='notice'>It has a slot in the base for a metal rod.</span>"
			if(2)
				. += "<span class='notice'>It has a bunch of rods sticking out of the hole. Consider welding it.</span>"
			if(3)
				. += "<span class='notice'>It has a short rough metal shaft sticking to it, quite short, needs more rods.</span>"
			if(4)
				. += "<span class='notice'>It has a bunch of unwelded rods jammed into the shaft.</span>"
			if(5)
				. += "<span class='notice'>It has a pretty long rough metal shaft sticking out of it, it look hard to grab. Could make a handle with some steel...</span>"
			if(6)
				. += "<span class='notice'>It has a few unwelded sheets bent in half across the handle.</span>"
			if(7)
				. += "<span class='notice'>It has red hot, pliable looking metal sheets spread over the handle. What a sloppy job. Finish the job with a wrench.</span>"
