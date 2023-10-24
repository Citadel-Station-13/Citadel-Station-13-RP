/*
 * Wirecutters
 */
/obj/item/tool/wirecutters
	name = "wirecutters"
	desc = "This cuts wires."
	icon = 'icons/obj/tools.dmi'
	icon_state = "cutters"
	item_state = "cutters"
	slot_flags = SLOT_BELT
	tool_behaviour = TOOL_WIRECUTTER
	damage_force = 6
	throw_speed = 2
	throw_range = 9
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 1, TECH_ENGINEERING = 1)
	materials = list(MAT_STEEL = 80)
	attack_verb = list("pinched", "nipped")
	hitsound = 'sound/items/wirecutter.ogg'
	tool_sound = 'sound/items/wirecutter.ogg'
	drop_sound = 'sound/items/drop/wirecutter.ogg'
	pickup_sound = 'sound/items/pickup/wirecutter.ogg'
	sharp = 1
	edge = 1
	tool_speed = 1
	var/random_color = TRUE

/obj/item/tool/wirecutters/Initialize(mapload)
	. = ..()
	if(random_color)
		switch(pick("red","yellow","green","blue"))
			if ("red")
				icon_state = "cutters"
				item_state = "cutters"
			if ("yellow")
				icon_state = "cutters_yellow"
				item_state = "cutters_yellow"
			if ("green")
				icon_state = "cutters_green"
				item_state = "cutters_green"
			if ("blue")
				icon_state = "cutters_blue"
				item_state = "cutters_blue"

/obj/item/tool/wirecutters/attack_mob(mob/target, mob/user, clickchain_flags, list/params, mult, target_zone, intent)
	var/mob/living/carbon/C = target
	if(istype(C) && user.a_intent == INTENT_HELP && (C.handcuffed) && (istype(C.handcuffed, /obj/item/handcuffs/cable)))
		usr.visible_message("\The [usr] cuts \the [C]'s restraints with \the [src]!",\
		"You cut \the [C]'s restraints with \the [src]!",\
		"You hear cable being cut.")
		qdel(C.handcuffed)
		return
	return ..()

/obj/item/tool/wirecutters/bone
	name = "primitive wirecutters"
	desc = "Dull wirecutters knapped from bone."
	icon_state = "cutters_bone"
	tool_speed = 1.25
	random_color = FALSE

/obj/item/tool/wirecutters/brass
	name = "brass wirecutters"
	desc = "Brass plated wirecutters that never seem to lose their edge."
	icon_state = "cutters_brass"
	tool_speed = 0.75
	random_color = FALSE

/obj/item/tool/wirecutters/clockwork
	name = "clockwork wirecutters"
	desc = "An antiquated pair of wirecutters, fashioned out of extremely dense brass."
	icon = 'icons/obj/clockwork.dmi'
	icon_state = "cutters_clock"
	tool_speed = 0.1
	random_color = FALSE

/obj/item/tool/wirecutters/clockwork/examine(mob/user, dist)
	. = ..()
	. += SPAN_NEZBERE("The blades are utterly dull and impotent when placed against flesh, yet cuts with an unreasonable, almost murderously sharp edge when set upon wires and metal sheets.")

/datum/category_item/catalogue/anomalous/precursor_a/alien_wirecutters
	name = "Precursor Alpha Object - Wire Seperator"
	desc = "An object appearing to have a tool shape. It has two handles, and two \
	sides which are attached to each other in the center. At the end on each side \
	is a sharp cutting edge, made from a seperate material than the rest of the \
	tool.\
	<br><br>\
	This tool appears to serve the same purpose as conventional wirecutters, due \
	to how similar the shapes are. If so, this implies that the creators of this \
	object also may utilize flexible cylindrical strands of metal to transmit \
	energy and signals, just as humans do."
	value = CATALOGUER_REWARD_EASY

/obj/item/tool/wirecutters/alien
	name = "alien wirecutters"
	desc = "Extremely sharp wirecutters, made out of a silvery-green metal."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_wirecutters)
	icon = 'icons/obj/abductor.dmi'
	icon_state = "cutters"
	tool_speed = 0.1
	origin_tech = list(TECH_MATERIAL = 5, TECH_ENGINEERING = 4)
	random_color = FALSE

/obj/item/tool/wirecutters/cyborg
	name = "wirecutters"
	desc = "This cuts wires.  With science."
	tool_sound = 'sound/items/jaws_cut.ogg'
	tool_speed = 0.5

/obj/item/tool/wirecutters/RIGset
	name = "integrated wirecutters"
	desc = "If you're seeing this, someone did a dum-dum."
	tool_sound = 'sound/items/jaws_cut.ogg'
	tool_speed = 0.7

/obj/item/tool/wirecutters/hybrid
	name = "strange wirecutters"
	desc = "This cuts wires.  With <span class='alien'>Science!</span>"
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_wirecutters)
	icon_state = "hybcutters"
	w_class = ITEMSIZE_NORMAL
	weight = ITEM_WEIGHT_HYBRID_TOOLS
	origin_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3, TECH_PHORON = 2)
	attack_verb = list("pinched", "nipped", "warped", "blasted")
	tool_sound = 'sound/effects/stealthoff.ogg'
	tool_speed = 0.4
	reach = 2


/obj/item/tool/wirecutters/power
	name = "jaws of life"
	desc = "A set of jaws of life, compressed through the magic of science. It's fitted with a cutting head."
	icon_state = "jaws_cutter"
	item_state = "jawsoflife"
	origin_tech = list(TECH_MATERIAL = 2, TECH_ENGINEERING = 2)
	materials = list(MAT_METAL=150, MAT_SILVER=50)
	tool_sound = 'sound/items/jaws_cut.ogg'
	damage_force = 15
	tool_speed = 0.25
	random_color = FALSE
	var/obj/item/tool/crowbar/power/counterpart = null

/obj/item/tool/wirecutters/power/Initialize(mapload, no_counterpart = TRUE)
	. = ..()
	if(!counterpart && no_counterpart)
		counterpart = new(src, FALSE)
		counterpart.counterpart = src

/obj/item/tool/wirecutters/power/Destroy()
	if(counterpart)
		counterpart.counterpart = null // So it can qdel cleanly.
		QDEL_NULL(counterpart)
	return ..()

/obj/item/tool/wirecutters/power/attack_self(mob/user)
	. = ..()
	if(.)
		return
	playsound(get_turf(user), 'sound/items/change_jaws.ogg', 50, 1)
	user.temporarily_remove_from_inventory(src, INV_OP_FORCE | INV_OP_SHOULD_NOT_INTERCEPT | INV_OP_SILENT)
	if(!user.put_in_active_hand(counterpart))
		counterpart.forceMove(get_turf(user))
	forceMove(counterpart)
	to_chat(user, "<span class='notice'>You attach the pry jaws to [src].</span>")

/obj/item/tool/wirecutters/crystal
	name = "crystalline shears"
	desc = "A crystalline shearing tool of an alien make."
	icon_state = "crystal_wirecutter"
	item_state = "crystal_tool"
	icon = 'icons/obj/crystal_tools.dmi'
	materials = list(MATERIAL_CRYSTAL = 1250)
	tool_speed = 0.2

/obj/item/tool/wirecutters/crystal/Initialize()
	. = ..()
	icon_state = initial(icon_state)
	item_state = initial(item_state)
