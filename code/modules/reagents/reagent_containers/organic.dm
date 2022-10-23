//Sweet Sweet Honeycomb
/obj/item/reagent_containers/organic
	name = " "
	var/base_name = " "
	desc = " "
	var/base_desc = " "
	icon = 'icons/obj/chemical.dmi'
	icon_state = "null"
	item_state = "null"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60)
	volume = 60
	w_class = ITEMSIZE_SMALL
	flags = NOCONDUCT
	unacidable = 0 //tissues does dissolve in acid
	drop_sound = 'sound/effects/splat.ogg'
	pickup_sound = 'sound/effects/squelch1.ogg'

	var/label_text = ""

	var/list/prefill = null	//Reagents to fill the container with on New(), formatted as "reagentID" = quantity

	var/list/can_be_placed_into = list(
		/obj/machinery/chem_master/,
		/obj/machinery/chemical_dispenser,
		/obj/machinery/reagentgrinder,
		/obj/structure/table,
		/obj/structure/closet,
		/obj/structure/sink,
		/obj/item/storage,
		/obj/item/storage/secure/safe,
		/obj/machinery/disposal,
		/obj/machinery/smartfridge/,
		/obj/machinery/biogenerator,
		/obj/machinery/portable_atmospherics/powered/reagent_distillery
		)

/obj/item/reagent_containers/organic/Initialize(mapload)
	. = ..()
	if(LAZYLEN(prefill))
		for(var/R in prefill)
			reagents.add_reagent(R,prefill[R])
		prefill = null
	base_name = name
	base_desc = desc

/obj/item/reagent_containers/organic/pickup(mob/user, flags, atom/oldLoc)
	. = ..()
	update_icon()

/obj/item/reagent_containers/organic/dropped(mob/user, flags, atom/newLoc)
	. = ..()
	update_icon()

/obj/item/reagent_containers/organic/attack_hand()
	..()
	update_icon()


/obj/item/reagent_containers/organic/attack_self(mob/user)
	..()
	if(is_open_container())
		to_chat(usr, "<span class = 'notice'>You crush \the [src] in your hands.</span>")
		playsound(loc, 'sound/effects/slime_squish.ogg', 50, 1)
		qdel(src)
		var/crushed_organic_container = /obj/item/stack/material/wax
		new crushed_organic_container(get_turf(user))
	else
		to_chat(usr, "<span class = 'notice'>You peel the wax layer off \the [src].</span>")
		playsound(loc, 'sound/effects/pageturn2.ogg', 50, 1)
		flags |= OPENCONTAINER
	update_icon()

/obj/item/reagent_containers/organic/update_icon()
	overlays.Cut()

	if (!is_open_container())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid

/obj/item/reagent_containers/organic/attack(mob/M as mob, mob/user as mob, def_zone)
	if(force && !(item_flags & ITEM_NOBLUDGEON) && user.a_intent == INTENT_HARM)
		return	..()

	if(standard_feed_mob(user, M))
		return

	return 0

/obj/item/reagent_containers/organic/standard_feed_mob(var/mob/user, var/mob/target)
	if(!is_open_container())
		to_chat(user, "<span class='notice'>You need to peeol open \the [src] first.</span>")
		return 1
	if(user.a_intent == INTENT_HARM)
		return 1
	return ..()

/obj/item/reagent_containers/organic/self_feed_message(var/mob/user)
	to_chat(user, "<span class='notice'>You swallow a gulp from \the [src].</span>")

/obj/item/reagent_containers/organic/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!is_open_container() || !proximity) //Is the container open & are they next to whatever they're clicking?
		return 1 //If not, do nothing.
	for(var/type in can_be_placed_into) //Is it something it can be placed into?
		if(istype(target, type))
			return 1
	if(standard_dispenser_refill(user, target)) //Are they clicking a water tank/some dispenser?
		return 1
	if(standard_pour_into(user, target)) //Pouring into another beaker?
		return
	if(user.a_intent == INTENT_HARM)
		if(standard_splash_mob(user,target))
			return 1
		if(reagents && reagents.total_volume)
			to_chat(user, "<span class='notice'>You splash the solution onto [target].</span>") //They are on harm intent, aka wanting to spill it.
			reagents.splash(target, reagents.total_volume)
			return 1
	..()

/obj/item/reagent_containers/organic/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/pen) || istype(W, /obj/item/flashlight/pen))
		var/tmp_label = sanitizeSafe(input(user, "Enter a label for [name]", "Label", label_text), MAX_NAME_LEN)
		if(length(tmp_label) > 50)
			to_chat(user, "<span class='notice'>The label can be at most 50 characters long.</span>")
		else if(length(tmp_label) > 10)
			to_chat(user, "<span class='notice'>You set the label.</span>")
			label_text = tmp_label
			update_name_label()
		else
			to_chat(user, "<span class='notice'>You set the label to \"[tmp_label]\".</span>")
			label_text = tmp_label
			update_name_label()
	if(istype(W,/obj/item/storage/bag))
		..()
	if(istype(W,/obj/item/reagent_containers/glass) || istype(W,/obj/item/reagent_containers/food/drinks) || istype(W,/obj/item/reagent_containers/food/condiment))
		return
	if(W && W.w_class <= w_class && (flags & OPENCONTAINER))
		to_chat(user, "<span class='notice'>You dip \the [W] into \the [src].</span>")
		reagents.touch_obj(W, reagents.total_volume)

/obj/item/reagent_containers/organic/proc/update_name_label()
	if(label_text == "")
		name = base_name
	else if(length(label_text) > 20)
		var/short_label_text = copytext(label_text, 1, 21)
		name = "[base_name] ([short_label_text]...)"
	else
		name = "[base_name] ([label_text])"
	desc = "[base_desc] It is labeled \"[label_text]\"."

// Containers

/obj/item/reagent_containers/organic/waxcomb
	name = "waxcomb (honey)"
	desc = "A glob of freshly produced honey encased in sturdy wax."
	icon_state = "waxcomb"
	matter = list("wax" = 100)
	volume = 30
	w_class = ITEMSIZE_TINY
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,30)
	prefill = list("honey" = 30)

/obj/item/reagent_containers/organic/waxcomb_jelly
	name = "waxcomb (jelly)"
	desc = "A glob of freshly produced jelly encased in sturdy wax."
	icon_state = "waxcomb"
	matter = list("wax" = 100)
	volume = 30
	w_class = ITEMSIZE_TINY
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,30)
	prefill = list("cherryjelly" = 30)
