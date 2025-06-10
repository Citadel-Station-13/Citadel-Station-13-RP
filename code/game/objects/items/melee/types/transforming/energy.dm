/datum/passive_parry/melee/energy
	parry_frame = /datum/parry_frame/passive_block/energy

/datum/parry_frame/passive_block/energy
	parry_sfx = 'sound/weapons/blade1.ogg'

/obj/item/melee/transforming/energy
	damage_tier = 5
	atom_flags = NOCONDUCT | NOBLOODY
	active_via_overlay = TRUE

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

	passive_parry = /datum/passive_parry/melee/energy

	activation_sound = 'sound/weapons/saberon.ogg'
	deactivation_sound = 'sound/weapons/saberoff.ogg'

/obj/item/melee/transforming/energy/examine(mob/user, dist)
	. = ..()
	if(colorable)
		. += SPAN_NOTICE("Alt-click to recolor it.")

/obj/item/melee/transforming/energy/on_activate(datum/event_args/actor/actor, silent)
	. = ..()
	set_light(lrange, lpower, lcolor)

/obj/item/melee/transforming/energy/on_deactivate(datum/event_args/actor/actor, silent)
	. = ..()
	set_light(0)

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

/obj/item/melee/transforming/energy/toggle(datum/event_args/actor/actor, silent)
	if(use_cell)
		if((!bcell || bcell.charge < hitcost) && !active)
			if(!silent)
				actor.chat_feedback(
					"<span class='notice'>\The [src] does not seem to have power.</span>",
					target = src,
				)
			return FALSE
	return ..()

/obj/item/melee/transforming/energy/legacy_mob_melee_hook(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	. = ..()
	if(active && use_cell)
		if(!use_charge(hitcost))
			set_activation(FALSE)
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
			set_activation(FALSE)
			update_icon()
			return
	return ..()

/obj/item/melee/transforming/energy/get_cell(inducer)
	return bcell

/obj/item/melee/transforming/energy/build_active_overlay()
	var/image/creating = ..()
	if(rainbow)
		creating.icon_state += "-rainbow"
	else
		creating.color = lcolor
	return creating

/obj/item/melee/transforming/energy/build_active_worn_overlay()
	var/image/creating = ..()
	if(rainbow)
		creating.icon_state += "-rainbow"
	else
		creating.color = lcolor
	return creating

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
		update_icon()
	return ..()

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
