/datum/passive_parry/melee/energy
	parry_frame = /datum/parry_frame/passive_block/energy

/datum/parry_frame/passive_block/energy
	parry_sfx = 'sound/weapons/blade1.ogg'

#warn icon state as -active
/obj/item/melee/transforming/energy
	armor_penetration = 50
	atom_flags = NOCONDUCT | NOBLOODY
	var/lrange = 2
	var/lpower = 2
	var/lcolor = "#0099FF"
	var/colorable = FALSE
	var/rainbow = FALSE
	// If it uses energy.
	var/use_cell = FALSE
	var/hitcost = 120
	var/obj/item/cell/bcell = null
	var/cell_type = /obj/item/cell/device
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_melee.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_melee.dmi',
			)

	passive_parry = /datum/passive_parry/melee/energy

	activation_sound = 'sound/weapons/saberon.ogg'
	deactivation_sound = 'sound/weapons/saberoff.ogg'

/obj/item/melee/transforming/energy/proc/activate(mob/living/user)
	if(active)
		return
	active = 1
	if(rainbow)
		item_state = "[icon_state]_blade_rainbow"
	else
		item_state = "[icon_state]_blade"
	throw_force = active_throw_force
	set_light(lrange, lpower, lcolor)
	to_chat(user, "<span class='notice'>Alt-click to recolor it.</span>")

/obj/item/melee/transforming/energy/proc/deactivate(mob/living/user)
	if(!active)
		return
	item_state = "[icon_state]"
	embed_chance = initial(embed_chance)
	throw_force = initial(throw_force)
	update_icon()
	set_light(0,0)

#warn parse all

/obj/item/melee/transforming/energy/proc/use_charge(var/cost)
	if(active)
		if(bcell)
			if(bcell.checked_use(cost))
				return 1
			else
				return 0
	return null

/obj/item/melee/transforming/energy/examine(mob/user, dist)
	. = ..()
	if(use_cell)
		if(bcell)
			. += "<span class='notice'>The blade is [round(bcell.percent())]% charged.</span>"
		if(!bcell)
			. += "<span class='warning'>The blade does not have a power source installed.</span>"

/obj/item/melee/transforming/energy/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(use_cell)
		if((!bcell || bcell.charge < hitcost) && !active)
			to_chat(user, "<span class='notice'>\The [src] does not seem to have power.</span>")
			return

	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	if (active)
		if ((MUTATION_CLUMSY in user.mutations) && prob(50))
			user.visible_message("<span class='danger'>\The [user] accidentally cuts [TU.himself] with \the [src].</span>",\
			"<span class='danger'>You accidentally cut yourself with \the [src].</span>")
			var/mob/living/carbon/human/H = ishuman(user)? user : null
			H.take_random_targeted_damage(brute = 5, burn = 5)
		deactivate(user)
	else
		activate(user)

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return

/obj/item/melee/transforming/energy/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	. = ..()
	if(active && use_cell)
		if(!use_charge(hitcost))
			deactivate(user)
			visible_message("<span class='notice'>\The [src]'s blade flickers, before deactivating.</span>")

/obj/item/melee/transforming/energy/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/multitool) && colorable && !active)
		if(!rainbow)
			rainbow = TRUE
		else
			rainbow = FALSE
		to_chat(user, "<span class='notice'>You manipulate the color controller in [src].</span>")
		update_icon()
	if(use_cell)
		if(istype(W, cell_type))
			if(!bcell)
				if(!user.attempt_insert_item_for_installation(W, src))
					return
				bcell = W
				to_chat(user, "<span class='notice'>You install a cell in [src].</span>")
				update_icon()
			else
				to_chat(user, "<span class='notice'>[src] already has a cell.</span>")
		else if(W.is_screwdriver() && bcell)
			bcell.update_icon()
			bcell.forceMove(get_turf(loc))
			bcell = null
			to_chat(user, "<span class='notice'>You remove the cell from \the [src].</span>")
			deactivate()
			update_icon()
			return
	return ..()

/obj/item/melee/transforming/energy/get_cell(inducer)
	return bcell

/obj/item/melee/transforming/energy/update_icon()
	. = ..()
	var/mutable_appearance/blade_overlay = mutable_appearance(icon, "[icon_state]_blade")
	blade_overlay.color = lcolor
	color = lcolor
	if(rainbow)
		blade_overlay = mutable_appearance(icon, "[icon_state]_blade_rainbow")
		blade_overlay.color = "FFFFFF"
		color = "FFFFFF"
	cut_overlays()		//So that it doesn't keep stacking overlays non-stop on top of each other
	if(active)
		add_overlay(blade_overlay)
	if(istype(usr,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = usr
		H.update_inv_l_hand()
		H.update_inv_r_hand()

/obj/item/melee/transforming/energy/AltClick(mob/living/user)
	if(!colorable) //checks if is not colorable
		return
	if(!in_range(src, user))	//Basic checks to prevent abuse
		return
	if(user.incapacitated() || !istype(user))
		to_chat(user, "<span class='warning'>You can't do that right now!</span>")
		return

	if(alert("Are you sure you want to recolor your blade?", "Confirm Recolor", "Yes", "No") == "Yes")
		var/energy_color_input = input(usr,"","Choose Energy Color",lcolor) as color|null
		if(energy_color_input)
			lcolor = "#[sanitize_hexcolor(energy_color_input)]"
			color = lcolor
			deactivate()
		update_icon()
	. = ..()

// todo: no inhand!
// /obj/item/melee/transforming/energy/spear
// 	name = "energy spear"
// 	desc = "Concentrated energy forming a sharp tip at the end of a long rod."
// 	icon_state = "espear"
// 	armor_penetration = 75
// 	sharp = 1
// 	edge = 1
// 	damage_force = 5
// 	throw_force = 10
// 	throw_speed = 7
// 	throw_range = 11
// 	reach = 2
// 	w_class = WEIGHT_CLASS_BULKY
// 	active_damage_force = 25
// 	active_throw_force = 30
// 	active_weight_class = WEIGHT_CLASS_HUGE
// 	colorable = TRUE
// 	lcolor = "#800080"

// 	passive_parry = /datum/passive_parry/melee/energy{
// 		parry_chance_default = 50
// 	}

// /obj/item/melee/transforming/energy/spear/activate(mob/living/user)
// 	if(!active)
// 		to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")
// 	..()
// 	attack_verb = list("jabbed", "stabbed", "impaled")
// 	AddComponent(/datum/component/jousting)

// /obj/item/melee/transforming/energy/spear/deactivate(mob/living/user)
// 	if(active)
// 		to_chat(user, "<span class='notice'>\The [src] deactivates!</span>")
// 	..()
// 	attack_verb = list("whacked", "beat", "slapped", "thonked")
// 	DelComponent(/datum/component/jousting)
