/* Beds... get your mind out of the gutter, they're for sleeping!
 * Contains:
 * 		Beds
 *		Roller beds
 */

/*
 * Beds
 */
/obj/structure/bed
	name = "bed"
	desc = "This is used to lie in, sleep in or strap on."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "bed"
	pressure_resistance = 15
	anchored = TRUE
	buckle_allowed = TRUE
	pass_flags_self = ATOM_PASS_TABLE | ATOM_PASS_OVERHEAD_THROW
	buckle_dir = SOUTH
	buckle_lying = 90
	var/datum/material/material
	var/datum/material/padding_material
	var/base_icon = "bed"
	var/applies_material_colour = 1

/obj/structure/bed/Initialize(mapload, new_material, new_padding_material)
	. = ..(mapload)
	remove_atom_colour(FIXED_COLOUR_PRIORITY)
	if(!new_material)
		new_material = MAT_STEEL
	material = get_material_by_name(new_material)
	if(!istype(material))
		qdel(src)
		return
	if(new_padding_material)
		padding_material = get_material_by_name(new_padding_material)
	update_icon()

/obj/structure/bed/get_material()
	return material

// Reuse the cache/code from stools, todo maybe unify.
/obj/structure/bed/update_icon()
	// Prep icon.
	icon_state = ""
	overlays.Cut()
	// Base icon.
	var/cache_key = "[base_icon]-[material.name]"
	if(isnull(stool_cache[cache_key]))
		var/image/I = image(icon, base_icon)
		if(applies_material_colour)
			I.color = material.icon_colour
		stool_cache[cache_key] = I
	overlays |= stool_cache[cache_key]
	// Padding overlay.
	if(padding_material)
		var/padding_cache_key = "[base_icon]-padding-[padding_material.name]"
		if(isnull(stool_cache[padding_cache_key]))
			var/image/I =  image(icon, "[base_icon]_padding")
			I.color = padding_material.icon_colour
			stool_cache[padding_cache_key] = I
		overlays |= stool_cache[padding_cache_key]
	// Strings.
	desc = initial(desc)
	if(padding_material)
		name = "[padding_material.display_name] [initial(name)]" //this is not perfect but it will do for now.
		desc += " It's made of [material.use_name] and covered with [padding_material.use_name]."
	else
		name = "[material.display_name] [initial(name)]"
		desc += " It's made of [material.use_name]."

/obj/structure/bed/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				qdel(src)
				return

/obj/structure/bed/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_wrench())
		playsound(src, W.tool_sound, 50, 1)
		dismantle()
		qdel(src)
	else if(istype(W,/obj/item/stack))
		if(padding_material)
			to_chat(user, "\The [src] is already padded.")
			return
		var/obj/item/stack/C = W
		var/padding_type //This is awful but it needs to be like this until tiles are given a material var.
		if(istype(W, /obj/item/stack/tile/carpet))
			padding_type = "carpet"
		else if(istype(W, /obj/item/stack/material))
			var/obj/item/stack/material/M = W
			if(M.material && (M.material.flags & MATERIAL_PADDING))
				padding_type = "[M.material.name]"
		if(!padding_type)
			to_chat(user, "You cannot pad \the [src] with that.")
			return
		C.use(1)
		to_chat(user, "You add padding to \the [src].")
		add_padding(padding_type)
		return

	else if(W.is_wirecutter())
		if(!padding_material)
			to_chat(user, "\The [src] has no padding to remove.")
			return
		to_chat(user, "You remove the padding from \the [src].")
		playsound(src, W.tool_sound, 100, 1)
		remove_padding()

	else if(istype(W, /obj/item/grab))
		var/obj/item/grab/G = W
		var/mob/living/affecting = G.affecting
		if(has_buckled_mobs()) //Handles trying to buckle someone else to a chair when someone else is on it
			to_chat(user, "<span class='notice'>\The [src] already has someone buckled to it.</span>")
			return
		user.visible_message("<span class='notice'>[user] attempts to buckle [affecting] into \the [src]!</span>")
		if(do_after(user, 20, G.affecting))
			affecting.forceMove(loc)
			spawn(0)
				if(buckle_mob(affecting))
					affecting.visible_message(\
						"<span class='danger'>[affecting.name] is buckled to [src] by [user.name]!</span>",\
						"<span class='danger'>You are buckled to [src] by [user.name]!</span>",\
						"<span class='notice'>You hear metal clanking.</span>")
			qdel(W)
	else
		..()

/obj/structure/bed/proc/remove_padding()
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
		padding_material = null
	update_icon()

/obj/structure/bed/proc/add_padding(var/padding_type)
	padding_material = get_material_by_name(padding_type)
	update_icon()

/obj/structure/bed/proc/dismantle()
	material.place_sheet(get_turf(src))
	if(padding_material)
		padding_material.place_sheet(get_turf(src))

/obj/structure/bed/psych
	name = "psychiatrist's couch"
	desc = "For prime comfort during psychiatric evaluations."
	icon_state = "psychbed"
	base_icon = "psychbed"
	icon_dimension_y = 32

/obj/structure/bed/psych/Initialize(mapload)
	. = ..(mapload, "wood", "leather")

/obj/structure/bed/padded/Initialize(mapload)
	. = ..(mapload, "plastic", "cotton")

/obj/structure/bed/double
	name = "double bed"
	icon_state = "doublebed"
	base_icon = "doublebed"
	buckle_max_mobs = 2
	icon_dimension_y = 32

/obj/structure/bed/double/padded/Initialize(mapload)
	. = ..(mapload, "wood", "cotton")

/obj/structure/bed/double/padded/get_centering_pixel_y_offset(dir, atom/aligning)
	if(!aligning)
		return ..()
	if(!has_buckled_mobs())
		return ..()
	var/index = buckled_mobs.Find(aligning)
	if(!index)
		return ..()
	switch(index)
		if(1)
			return -6
		if(2)
			return 6
		if(3)
			return 3
		else
			return rand(-6, 6)

/*
 * Roller beds
 */
/obj/structure/bed/roller
	name = "roller bed"
	desc = "A portable bed-on-wheels made for transporting medical patients."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "rollerbed"
	base_icon_state = "rollerbed"
	anchored = FALSE
	surgery_odds = 75

	var/bedtype = /obj/structure/bed/roller
	var/rollertype = /obj/item/roller

/obj/structure/bed/roller/adv
	name = "advanced roller bed"
	icon_state = "rollerbedadv"
	base_icon_state = "rollerbedadv"
	bedtype = /obj/structure/bed/roller/adv
	rollertype = /obj/item/roller/adv

/obj/structure/bed/roller/Moved(atom/old_loc, movement_dir/*, forced, list/old_locs, momentum_change = TRUE*/)
	. = ..()
	if(has_gravity())
		playsound(src, 'sound/effects/roll.ogg', 100, TRUE)
	//! Behold shitecode to make the our victim not flop like a fish.
	for(var/mob/living/M in buckled_mobs)
		if(M.buckled == src)
			M.dir = buckle_dir

/obj/structure/bed/roller/mob_buckled(mob/M, flags, mob/user, semantic)
	. = ..()
	set_density(TRUE)
	icon_state = "[base_icon_state]_up"
	//Push them up from the normal lying position
	M.dir = buckle_dir // So they always face the right way, "upwards"
	M.set_pixel_y(6)

/obj/structure/bed/roller/mob_unbuckled(mob/M, flags, mob/user, semantic)
	. = ..()
	set_density(FALSE)
	icon_state = base_icon_state
	// Reset our transforms.
	M.set_pixel_x(0)
	M.set_pixel_y(0)

/obj/structure/bed/roller/doLocationTransitForceMove(atom/destination)
	var/list/old_buckled = buckled_mobs?.Copy()
	. = ..()
	if(old_buckled)
		for(var/mob/M in old_buckled)
			buckle_mob(M, BUCKLE_OP_FORCE)

/obj/structure/bed/roller/update_icon()
	return

/obj/structure/bed/roller/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_wrench() || istype(W,/obj/item/stack) || W.is_wirecutter())
		return
	else if(istype(W,/obj/item/roller_holder))
		if(has_buckled_mobs())
			for(var/A in buckled_mobs)
				user_unbuckle_mob(A, user)
		else
			visible_message("[user] collapses \the [src.name].")
			new rollertype(get_turf(src))
			spawn(0)
				qdel(src)
		return
	..()

/obj/item/roller
	name = "roller bed"
	desc = "A collapsed roller bed that can be carried around."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "folded_rollerbed"
	slot_flags = SLOT_BACK
	w_class = ITEMSIZE_LARGE
	var/rollertype = /obj/item/roller
	var/bedtype = /obj/structure/bed/roller
	drop_sound = 'sound/items/drop/axe.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'

/obj/item/roller/attack_self(mob/user)
	var/obj/structure/bed/roller/R = new bedtype(user.loc)
	R.add_fingerprint(user)
	qdel(src)

/obj/item/roller/attackby(obj/item/W as obj, mob/user as mob)

	if(istype(W,/obj/item/roller_holder))
		var/obj/item/roller_holder/RH = W
		if(!RH.held)
			to_chat(user, "<span class='notice'>You collect the roller bed.</span>")
			forceMove(RH)
			RH.held = src
			return

	..()

/obj/item/roller/adv
	name = "advanced roller bed"
	desc = "A high-tech, compact version of the regular roller bed."
	icon_state = "folded_rollerbedadv"
	w_class = ITEMSIZE_NORMAL
	rollertype = /obj/item/roller/adv
	bedtype = /obj/structure/bed/roller/adv

/obj/item/roller_holder
	name = "roller bed rack"
	desc = "A rack for carrying a collapsed roller bed."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "rollerbed"
	var/obj/item/roller/held

/obj/item/roller_holder/Initialize(mapload)
	. = ..()
	held = new /obj/item/roller(src)

/obj/item/roller_holder/attack_self(mob/user as mob)

	if(!held)
		to_chat(user, "<span class='notice'>The rack is empty.</span>")
		return

	to_chat(user, "<span class='notice'>You deploy the roller bed.</span>")
	var/obj/structure/bed/roller/R = new held.bedtype(user.loc)
	R.add_fingerprint(user)
	qdel(held)
	held = null


/obj/structure/bed/roller/Move()
	..()
	if(has_buckled_mobs())
		for(var/A in buckled_mobs)
			var/mob/living/L = A

			if(L.buckled == src)
				L.forceMove(loc)

/obj/structure/bed/roller/mob_buckled(mob/M, flags, mob/user, semantic)
	. = ..()
	density = TRUE
	icon_state = "[initial(icon_state)]_up"

/obj/structure/bed/roller/mob_unbuckled(mob/M, flags, mob/user, semantic)
	. = ..()
	if(has_buckled_mobs())
		return
	density = FALSE
	icon_state = "[initial(icon_state)]"
	update_icon()

/obj/structure/bed/roller/OnMouseDropLegacy(over_object, src_location, over_location)
	if((over_object == usr && (in_range(src, usr) || usr.contents.Find(src))))
		if(!ishuman(usr))
			return 0
		if(has_buckled_mobs())
			return 0
		visible_message("[usr] collapses \the [src.name].")
		new rollertype(get_turf(src))
		spawn(0)
			qdel(src)
		return 0
	return ..()

/datum/category_item/catalogue/anomalous/precursor_a/alien_bed
	name = "Precursor Alpha Object - Resting Contraption"
	desc = "This appears to be a relatively long and flat object, with the top side being made of \
	an soft material, giving it very similar characteristics to an ordinary bed. If this object was \
	designed to act as a bed, this carries several implications for whatever species had built it, such as;\
	<br><br>\
	Being capable of experiencing comfort, or at least being able to suffer from some form of fatigue.<br>\
	Developing while under the influence of gravitational forces, to be able to 'lie' on the object.<br>\
	Being within a range of sizes in order for the object to function as a bed. Too small, and the species \
	would be unable to reach the top of the object. Too large, and they would have little room to contact \
	the top side of the object.<br>\
	<br><br>\
	As a note, the size of this object appears to be within the bounds for an average human to be able to \
	rest comfortably on top of it."
	value = CATALOGUER_REWARD_EASY

/obj/structure/bed/alien
	name = "resting contraption"
	desc = "Whatever species designed this must've enjoyed relaxation as well. Looks vaguely comfy."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_bed)
	icon = 'icons/obj/abductor.dmi'
	icon_state = "bed"

/obj/structure/bed/alien/update_icon()
	return // Doesn't care about material or anything else.

/obj/structure/bed/alien/attackby(obj/item/W, mob/user)
	return // No deconning.
