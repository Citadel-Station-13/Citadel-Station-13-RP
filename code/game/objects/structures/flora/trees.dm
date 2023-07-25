//trees
/obj/structure/flora/tree
	name = "tree"
	anchored = 1
	density = 1
	pixel_x = -16
	plane = MOB_PLANE // You know what, let's play it safe.
	layer = ABOVE_MOB_LAYER

	integrity = 400
	integrity_max = 400

	var/shake_animation_degrees = 4	// How much to shake the tree when struck.  Larger trees should have smaller numbers or it looks weird.
	var/obj/item/stack/material/product = null	// What you get when chopping this tree down.  Generally it will be a type of wood.
	var/product_amount = 10 // How much of a stack you get, if the above is defined.
	var/is_stump = FALSE // If true, suspends damage tracking and most other effects.
	var/indestructable = FALSE // If true, the tree cannot die.

/obj/structure/flora/tree/Initialize(mapload)
	icon_state = choose_icon_state()

	return ..()

/obj/structure/flora/tree/update_transform()
	var/matrix/M = matrix()
	M.Scale(icon_scale_x, icon_scale_y)
	M.Translate(0, 16*(icon_scale_y-1))
	animate(src, transform = M, time = 10)

// Override this for special icons.
/obj/structure/flora/tree/proc/choose_icon_state()
	return icon_state

/obj/structure/flora/tree/can_harvest(var/obj/item/I)
	. = FALSE
	if(!is_stump && harvest_tool && istype(I, harvest_tool) && harvest_loot && harvest_loot.len && harvest_count < max_harvests)
		. = TRUE
	return .

/obj/structure/flora/tree/attackby(obj/item/I, mob/living/user, list/params, clickchain_flags, damage_multiplier)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(can_harvest(I))
		return ..(I, user)
	if(is_stump)
		if(istype(I,/obj/item/shovel))
			if(do_after(user, 5 SECONDS))
				visible_message("<span class='notice'>\The [user] digs up \the [src] stump with \the [I].</span>")
				qdel(src)
		return
	return ..()

/obj/structure/flora/tree/hitsound_melee(obj/item/I)
	if((I.damage_mode & DAMAGE_MODE_EDGE) && I.damage_force >= 5)
		return 'sound/effects/woodcutting.ogg'
	return ..()

// Shakes the tree slightly, more or less stolen from lockers.
/obj/structure/flora/tree/proc/hit_animation()
	var/init_px = pixel_x
	var/shake_dir = pick(-1, 1)
	var/matrix/M = matrix()
	M.Scale(icon_scale_x, icon_scale_y)
	M.Translate(0, 16*(icon_scale_y-1))
	animate(src, transform=turn(M, shake_animation_degrees * shake_dir), pixel_x=init_px + 2*shake_dir, time=1)
	animate(transform=M, pixel_x=init_px, time=6, easing=ELASTIC_EASING)

/obj/structure/flora/tree/inflict_atom_damage(damage, tier, flag, mode, attack_type, datum/weapon, gradual)
	. = ..()
	// ruins some of the wood if you use high power modes or types
	if(. > 5 && ((mode & (DAMAGE_MODE_ABLATING | DAMAGE_MODE_PIERCE | DAMAGE_MODE_SHRED)) || (flag == ARMOR_BOMB)))
		product_amount -= round((. * 0.5) / integrity_max * initial(product_amount))

/obj/structure/flora/tree/atom_break()
	. = ..()

	if(product && product_amount) // Make wooden logs.
		var/obj/item/stack/material/M = new product(get_turf(src))
		M.amount = product_amount
		M.update_icon()
	visible_message("<span class='danger'>\The [src] is felled!</span>")
	stump()

// Makes the tree into a mostly non-interactive stump.
/obj/structure/flora/tree/proc/stump()
	if(is_stump)
		return

	is_stump = TRUE
	density = FALSE
	icon_state = "[base_icon_state]_stump"
	cut_overlays() // For the Sif tree and other future glowy trees.
	set_light(0)

/obj/structure/flora/tree/legacy_ex_act(var/severity)
	adjust_health(-(max_health / severity), TRUE)

/obj/structure/flora/tree/bullet_act(var/obj/projectile/Proj)
	if(Proj.get_structure_damage())
		adjust_health(-Proj.get_structure_damage(), TRUE)

/obj/structure/flora/tree/tesla_act(power, explosive)
	adjust_health(-power / 100, TRUE) // Kills most trees in one lightning strike.
	..()

/obj/structure/flora/tree/get_description_interaction(mob/user)
	var/list/results = list()

	if(!is_stump)
		results += "[desc_panel_image("hatchet", user)]to cut down this tree into logs.  Any sharp and strong weapon will do."

	results += ..()

	return results

// Subtypes.

// Pine trees

/obj/structure/flora/tree/pine
	name = "pine tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"
	base_icon_state = "pine"
	product = /obj/item/stack/material/log
	shake_animation_degrees = 3

/obj/structure/flora/tree/pine/choose_icon_state()
	return "[base_icon_state]_[rand(1, 3)]"


/obj/structure/flora/tree/pine/xmas
	name = "xmas tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_c"

/obj/structure/flora/tree/pine/xmas/presents
	icon_state = "pinepresents"
	desc = "A wondrous decorated Christmas tree. It has presents!"
	indestructable = TRUE
	var/gift_type = /obj/item/a_gift
	var/list/ckeys_that_took = list()

/obj/structure/flora/tree/pine/xmas/presents/choose_icon_state()
	return "pinepresents"

/obj/structure/flora/tree/pine/xmas/presents/attack_hand(mob/user, list/params)
	. = ..()
	if(.)
		return
	if(!user.ckey)
		return

	if(ckeys_that_took[user.ckey])
		to_chat(user, SPAN_WARNING( "There are no presents with your name on."))
		return
	to_chat(user, SPAN_NOTICE("After a bit of rummaging, you locate a gift with your name on it!"))
	ckeys_that_took[user.ckey] = TRUE
	var/obj/item/G = new gift_type(src)
	user.put_in_hands(G)

// Palm trees

/obj/structure/flora/tree/palm
	icon = 'icons/obj/flora/palmtrees.dmi'
	icon_state = "palm1"
	base_icon_state = "palm"
	product = /obj/item/stack/material/log
	product_amount = 10
	health = 200
	max_health = 200
	pixel_x = 0

/obj/structure/flora/tree/palm/choose_icon_state()
	return "[base_icon_state][rand(1, 2)]"


// Dead trees

/obj/structure/flora/tree/dead
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree_1"
	base_icon_state = "tree"
	product = /obj/item/stack/material/log
	product_amount = 10
	integrity = 200
	integrity_max = 200

/obj/structure/flora/tree/dead/choose_icon_state()
	return "[base_icon_state]_[rand(1, 6)]"

// Small jungle trees

/obj/structure/flora/tree/jungle_small
	icon = 'icons/obj/flora/jungletreesmall.dmi'
	icon_state = "tree"
	base_icon_state = "tree"
	product = /obj/item/stack/material/log
	product_amount = 20
	integrity = 400
	integrity_max = 400
	pixel_x = -32

/obj/structure/flora/tree/jungle_small/choose_icon_state()
	return "[base_icon_state][rand(1, 6)]"

// Big jungle trees

/obj/structure/flora/tree/jungle
	icon = 'icons/obj/flora/jungletree.dmi'
	icon_state = "tree"
	base_icon_state = "tree"
	product = /obj/item/stack/material/log
	product_amount = 40
	integrity = 800
	integrity_max = 800
	pixel_x = -48
	pixel_y = -16
	shake_animation_degrees = 2

/obj/structure/flora/tree/jungle/choose_icon_state()
	return "[base_icon_state][rand(1, 6)]"

// Sif trees

/datum/category_item/catalogue/flora/sif_tree
	name = "Sivian Flora - Tree"
	desc = "The damp, shaded environment of Sif's most common variety of tree provides an ideal environment for a wide \
	variety of bioluminescent bacteria. The soft glow of the microscopic organisms in turn attracts several native microphagous \
	animals which act as an effective dispersal method. By this mechanism, new trees and bacterial colonies often sprout in \
	unison, having formed a symbiotic relationship over countless years of evolution.\
	<br><br>\
	Wood-like material can be obtained from this by cutting it down with a bladed tool."
	value = CATALOGUER_REWARD_TRIVIAL

/obj/structure/flora/tree/sif
	name = "glowing tree"
	desc = "It's a tree, except this one seems quite alien.  It glows a deep blue."
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree_sif"
	base_icon_state = "tree_sif"
	product = /obj/item/stack/material/log/sif
	catalogue_data = list(/datum/category_item/catalogue/flora/sif_tree)
	randomize_size = TRUE

	harvest_tool = /obj/item/material/knife
	max_harvests = 2
	min_harvests = -4
	harvest_loot = list(
		/obj/item/reagent_containers/food/snacks/siffruit = 5
		)

	var/light_shift = 0

/obj/structure/flora/tree/sif/choose_icon_state()
	light_shift = rand(0, 5)
	return "[base_icon_state][light_shift]"

/obj/structure/flora/tree/sif/Initialize(mapload)
	. = ..()
	update_icon()

/obj/structure/flora/tree/sif/update_icon()
	set_light(5 - light_shift, 1, "#33ccff")	// 5 variants, missing bulbs. 5th has no bulbs, so no glow.
	var/image/glow = image(icon = icon, icon_state = "[base_icon_state][light_shift]_glow")
	glow.plane = ABOVE_LIGHTING_PLANE
	add_overlay(glow)
