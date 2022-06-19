//Also contains /obj/structure/closet/body_bag because I doubt anyone would think to look for bodybags in /object/structures

/obj/item/bodybag
	name = "body bag"
	desc = "A folded bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bodybag_folded"
	w_class = ITEMSIZE_SMALL

/obj/item/bodybag/attack_self(mob/user)
	var/obj/structure/closet/body_bag/R = new /obj/structure/closet/body_bag(user.loc)
	R.add_fingerprint(user)
	qdel(src)

/obj/item/storage/box/bodybags
	name = "body bags"
	desc = "This box contains body bags."
	icon_state = "bodybags"

/obj/item/storage/box/bodybags/Initialize(mapload)
	. = ..()
	new /obj/item/bodybag(src)
	new /obj/item/bodybag(src)
	new /obj/item/bodybag(src)
	new /obj/item/bodybag(src)
	new /obj/item/bodybag(src)
	new /obj/item/bodybag(src)
	new /obj/item/bodybag(src)

/obj/structure/closet/body_bag
	name = "body bag"
	desc = "A plastic bag designed for the storage and transportation of cadavers."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bodybag_closed"
	icon_closed = "bodybag_closed"
	icon_opened = "bodybag_open"
	open_sound = 'sound/items/zip.ogg'
	close_sound = 'sound/items/zip.ogg'
	var/item_path = /obj/item/bodybag
	density = FALSE
	storage_capacity = (MOB_MEDIUM * 2) - 1
	var/contains_body = FALSE

/obj/structure/closet/body_bag/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/pen))
		var/t = input(user, "What would you like the label to be?", text("[]", src.name), null) as text
		if(user.get_active_hand() != W)
			return
		if(!in_range(src, user) && src.loc != user)
			return
		t = sanitizeSafe(t, MAX_NAME_LEN)
		if(t)
			src.name = "body bag - "
			src.name += t
			src.overlays += image(src.icon, "bodybag_label")
		else
			src.name = "body bag"
	//..() //Doesn't need to run the parent. Since when can fucking bodybags be welded shut? -Agouri
		return
	else if(W.is_wirecutter())
		to_chat(user, "You cut the tag off the bodybag")
		src.name = "body bag"
		src.overlays.Cut()
		return

/obj/structure/closet/body_bag/store_mobs(stored_units)
	contains_body = ..()
	return contains_body

/obj/structure/closet/body_bag/close()
	if(..())
		density = FALSE
		return TRUE
	return FALSE

/obj/structure/closet/body_bag/MouseDrop(over_object, src_location, over_location)
	..()
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr))
			return FALSE
		if(opened)
			return FALSE
		if(contents.len)
			return FALSE
		visible_message("[usr] folds up the [src.name]")
		var/folded = new item_path(get_turf(src))
		spawn(0)
			qdel(src)
		return folded

/obj/structure/closet/body_bag/relaymove(mob/user,direction)
	if(src.loc != get_turf(src))
		src.loc.relaymove(user,direction)
	else
		..()

/obj/structure/closet/body_bag/proc/get_occupants()
	var/list/occupants = list()
	for(var/mob/living/carbon/human/H in contents)
		occupants += H
	return occupants

/obj/structure/closet/body_bag/proc/update(broadcast = FALSE)
	if(istype(loc, /obj/structure/morgue))
		var/obj/structure/morgue/M = loc
		M.update(broadcast)

/obj/structure/closet/body_bag/update_icon()
	if(opened)
		icon_state = icon_opened
	else
		if(contains_body > 0)
			icon_state = "bodybag_closed1"
		else
			icon_state = icon_closed


/obj/item/bodybag/cryobag
	name = "stasis bag"
	desc = "A non-reusable plastic bag designed to slow down bodily functions such as circulation and breathing, \
	especially useful if short on time or in a hostile enviroment."
	icon = 'icons/obj/cryobag.dmi'
	icon_state = "bodybag_folded"
	item_state = "bodybag_cryo_folded"
	origin_tech = list(TECH_BIO = 4)
	var/obj/item/reagent_containers/syringe/syringe

/obj/item/bodybag/cryobag/attack_self(mob/user)
	var/obj/structure/closet/body_bag/cryobag/R = new /obj/structure/closet/body_bag/cryobag(user.loc)
	R.add_fingerprint(user)
	if(syringe)
		R.syringe = syringe
		syringe = null
	qdel(src)

/obj/structure/closet/body_bag/cryobag
	name = "stasis bag"
	desc = "A non-reusable plastic bag designed to slow down bodily functions such as circulation and breathing, \
	especially useful if short on time or in a hostile enviroment."
	icon = 'icons/obj/cryobag.dmi'
	item_path = /obj/item/bodybag/cryobag
	store_misc = FALSE
	store_items = FALSE
	var/used = FALSE
	var/obj/item/tank/tank = null
	var/tank_type = /obj/item/tank/stasis/oxygen
	var/stasis_level = 3 //Every 'this' life ticks are applied to the mob (when life_ticks%stasis_level == 1)
	var/obj/item/reagent_containers/syringe/syringe

/obj/structure/closet/body_bag/cryobag/Initialize(mapload)
	. = ..()
	tank = new tank_type(null) //It's in nullspace to prevent ejection when the bag is opened.

/obj/structure/closet/body_bag/cryobag/Destroy()
	QDEL_NULL(syringe)
	QDEL_NULL(tank)
	return ..()

/obj/structure/closet/body_bag/cryobag/attack_hand(mob/living/user)
	if(used)
		var/confirm = tgui_alert(user, "Are you sure you want to open \the [src]? \The [src] will expire upon opening it.", "Confirm Opening", list("No", "Yes"))
		if(confirm == "Yes")
			..() // Will call `toggle()` and open the bag.
	else
		..()

/obj/structure/closet/body_bag/cryobag/open()
	. = ..()
	if(used)
		var/obj/item/O = new/obj/item(src.loc)
		O.name = "used [name]"
		O.icon = src.icon
		O.icon_state = "bodybag_used"
		O.desc = "Pretty useless now..."
		qdel(src)

/obj/structure/closet/body_bag/cryobag/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(. && syringe)
		var/obj/item/bodybag/cryobag/folded = .
		folded.syringe = syringe
		syringe = null

/obj/structure/closet/body_bag/cryobag/Entered(atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.Stasis(stasis_level)
		src.used = TRUE
		inject_occupant(H)

	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.preserved = TRUE
		for(var/obj/item/organ/organ in O)
			organ.preserved = TRUE
	..()

/obj/structure/closet/body_bag/cryobag/Exited(atom/movable/AM)
	if(ishuman(AM))
		var/mob/living/carbon/human/H = AM
		H.Stasis(0)

	if(istype(AM, /obj/item/organ))
		var/obj/item/organ/O = AM
		O.preserved = FALSE
		for(var/obj/item/organ/organ in O)
			organ.preserved = FALSE
	..()

/// Used to make stasis bags protect from vacuum.
/obj/structure/closet/body_bag/cryobag/return_air()
	if(tank)
		return tank.air_contents
	..()

/obj/structure/closet/body_bag/cryobag/proc/inject_occupant(mob/living/carbon/human/H)
	if(!syringe)
		return

	if(H.reagents)
		syringe.reagents.trans_to_mob(H, 30, CHEM_BLOOD)

/obj/structure/closet/body_bag/cryobag/examine(mob/user)
	. = ..()
	if(Adjacent(user)) //The bag's rather thick and opaque from a distance.
		. += SPAN_INFO("You peer into \the [src].")
		if(syringe)
			. += SPAN_INFO("It has a syringe added to it.")
		for(var/mob/living/L in contents)
			L.examine(user)

/obj/structure/closet/body_bag/cryobag/attackby(obj/item/W, mob/user)
	if(opened)
		..()
	else //Allows the bag to respond to a health analyzer by analyzing the mob inside without needing to open it.
		if(istype(W,/obj/item/healthanalyzer))
			var/obj/item/healthanalyzer/analyzer = W
			for(var/mob/living/L in contents)
				analyzer.attack(L,user)

		else if(istype(W,/obj/item/reagent_containers/syringe))
			if(syringe)
				to_chat(user, SPAN_WARNING("\The [src] already has an injector! Remove it first."))
			else
				var/obj/item/reagent_containers/syringe/syringe = W
				to_chat(user, SPAN_INFO("You insert \the [syringe] into \the [src], and it locks into place."))
				user.unEquip(syringe)
				src.syringe = syringe
				syringe.loc = null
				for(var/mob/living/carbon/human/H in contents)
					inject_occupant(H)
					break

		else if(W.is_screwdriver())
			if(syringe)
				if(used)
					to_chat(user, SPAN_WARNING("The injector cannot be removed now that the stasis bag has been used!"))
				else
					syringe.forceMove(src.loc)
					to_chat(user, SPAN_INFO("You pry \the [syringe] out of \the [src]."))
					syringe = null
		else
			..()
