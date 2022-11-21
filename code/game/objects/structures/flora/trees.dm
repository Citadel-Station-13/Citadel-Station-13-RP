/**********
 *! Trees *
 **********/
//Can *you* speak their language?
/obj/structure/flora/tree
	name = "tree"
	desc = "A large tree."
	density = TRUE
	pixel_x = -16
	plane = ABOVE_GAME_PLANE
	layer = FLY_LAYER

	/// Used for stumps.
	var/base_state = null
	/// Used for chopping down trees.
	var/health = 200
	var/max_health = 200
	/// How much to shake the tree when struck.  Larger trees should have smaller numbers or it looks weird.
	var/shake_animation_degrees = 4
	/// What you get when chopping this tree down.  Generally it will be a type of wood.
	var/obj/item/stack/material/product = null
	/// How much of a stack you get, if the above is defined.
	var/product_amount = 10
	/// If true, suspends damage tracking and most other effects.
	var/is_stump = FALSE
	/// If true, the tree cannot die.
	var/indestructable = FALSE

	// drag_slowdown = 1.5
	// product_types = list(/obj/item/grown/log/tree = 1)
	// harvest_amount_low = 6
	// harvest_amount_high = 10
	// harvest_message_low = "You manage to gather a few logs from the tree."
	// harvest_message_med = "You manage to gather some logs from the tree."
	// harvest_message_high = "You manage to get most of the wood from the tree."
	// harvest_verb = "chop"
	// harvest_verb_suffix = "s down"
	// delete_on_harvest = TRUE
	// flora_flags = FLORA_HERBAL | FLORA_WOODEN


/obj/structure/flora/tree/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/seethrough, get_seethrough_map())


/// Return a see_through_map, examples in seethrough.dm
/obj/structure/flora/tree/proc/get_seethrough_map()
	return SEE_THROUGH_MAP_DEFAULT


/obj/structure/flora/tree/update_transform()
	var/matrix/M = matrix()
	M.Scale(icon_scale_x, icon_scale_y)
	M.Translate(0, 16*(icon_scale_y-1))
	animate(src, transform = M, time = 10)

/obj/structure/flora/tree/can_harvest(obj/item/I)
	. = FALSE
	if(!is_stump && harvest_tool && istype(I, harvest_tool) && harvest_loot && harvest_loot.len && harvest_count < max_harvests)
		. = TRUE
	return .


/obj/structure/flora/tree/attackby(obj/item/W, mob/living/user)
	if(can_harvest(W))
		..(W, user)
		return

	if(!istype(W))
		return ..()

	if(is_stump)
		if(istype(W,/obj/item/shovel))
			if(do_after(user, 5 SECONDS))
				visible_message("<span class='notice'>\The [user] digs up \the [src] stump with \the [W].</span>")
				qdel(src)
		return

	visible_message("<span class='danger'>\The [user] hits \the [src] with \the [W]!</span>")

	var/damage_to_do = W.force
	if(!W.sharp && !W.edge)
		damage_to_do = round(damage_to_do / 4)
	if(damage_to_do > 0)
		if(W.sharp && W.edge)
			playsound(get_turf(src), 'sound/effects/woodcutting.ogg', 50, 1)
		else
			playsound(get_turf(src), W.hitsound, 50, 1)
		if(damage_to_do > 5 && !indestructable)
			adjust_health(-damage_to_do)
		else
			to_chat(user, "<span class='warning'>\The [W] is ineffective at harming \the [src].</span>")

	hit_animation()
	user.setClickCooldown(user.get_attack_speed(W))
	user.do_attack_animation(src)


/// Shakes the tree slightly, more or less stolen from lockers.
/obj/structure/flora/tree/proc/hit_animation()
	var/init_px = pixel_x
	var/shake_dir = pick(-1, 1)
	var/matrix/M = matrix()
	M.Scale(icon_scale_x, icon_scale_y)
	M.Translate(0, 16*(icon_scale_y-1))
	animate(src, transform=turn(M, shake_animation_degrees * shake_dir), pixel_x=init_px + 2*shake_dir, time=1)
	animate(transform=M, pixel_x=init_px, time=6, easing=ELASTIC_EASING)


/// Used when the tree gets hurt.
/obj/structure/flora/tree/proc/adjust_health(var/amount, var/damage_wood = FALSE)
	if(is_stump || indestructable)
		return

	// Bullets and lasers ruin some of the wood
	if(damage_wood && product_amount > 0)
		var/wood = initial(product_amount)
		product_amount -= round(wood * (abs(amount)/max_health))

	health = clamp( health + amount, 0,  max_health)
	if(health <= 0)
		die()
		return


/// Called when the tree loses all health, for whatever reason.
/obj/structure/flora/tree/proc/die()
	if(is_stump || indestructable)
		return

	if(product && product_amount) // Make wooden logs.
		var/obj/item/stack/material/M = new product(get_turf(src))
		M.amount = product_amount
		M.update_icon()
	visible_message("<span class='danger'>\The [src] is felled!</span>")
	playsound(get_turf(src), 'sound/effects/meteorimpact.ogg', 100 , FALSE, FALSE)
	stump()


/// Makes the tree into a mostly non-interactive stump.
/obj/structure/flora/tree/proc/stump()
	if(is_stump)
		return

	is_stump = TRUE
	density = FALSE
	name = "[name] stump"
	icon_state = "[base_state]_stump"
	overlays.Cut() // For the Sif tree and other future glowy trees.
	set_light(0)

/obj/structure/flora/tree/legacy_ex_act(severity)
	adjust_health(-(max_health / severity), TRUE)

/obj/structure/flora/tree/bullet_act(obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		adjust_health(-Proj.get_structure_damage(), TRUE)

/obj/structure/flora/tree/tesla_act(power, explosive)
	adjust_health(-power / 100, TRUE) // Kills most trees in one lightning strike.
	..()

/obj/structure/flora/tree/get_description_interaction()
	var/list/results = list()

	if(!is_stump)
		results += "[desc_panel_image("hatchet")]to cut down this tree into logs.  Any sharp and strong weapon will do."

	results += ..()

	return results

// Subtypes.

// Pine trees

/obj/structure/flora/tree/pine
	name = "pine tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"
	product = /obj/item/stack/material/log
	shake_animation_degrees = 3

/obj/structure/flora/tree/pine/style_2
	icon_state = "pine_2"
/obj/structure/flora/tree/pine/style_3
	icon_state = "pine_3"
/obj/structure/flora/tree/pine/style_random/Initialize(mapload)
	. = ..()
	icon_state = "pine_[rand(1, 3)]"


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

/obj/structure/flora/tree/pine/xmas/presents/attack_hand(mob/living/user)
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
	product = /obj/item/stack/material/log
	product_amount = 5
	health = 200
	max_health = 200
	pixel_x = 0

/obj/structure/flora/tree/palm/style_2
	icon_state = "palm_2"
/obj/structure/flora/tree/palm/style_random/Initialize(mapload)
	. = ..()
	icon_state = "palm_[rand(1, 2)]"

// Tree Stump
/obj/structure/flora/tree/stump
	name = "stump"
	desc = "This represents our promise to the crew, and the station itself, to cut down as many trees as possible." //running naked through the trees
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "tree_stump"
	density = FALSE
	// delete_on_harvest = TRUE
	// flora_flags = FLORA_WOODEN

// Dead trees

/obj/structure/flora/tree/dead
	desc = "A dead tree. How it died, you know not."
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree_1"
	product = /obj/item/stack/material/log
	product_amount = 5
	health = 200
	max_health = 200
	// flora_flags = FLORA_WOODEN

/obj/structure/flora/tree/dead/style_2
	icon_state = "tree_2"
/obj/structure/flora/tree/dead/style_3
	icon_state = "tree_3"
/obj/structure/flora/tree/dead/style_4
	icon_state = "tree_4"
/obj/structure/flora/tree/dead/style_5
	icon_state = "tree_5"
/obj/structure/flora/tree/dead/style_6
	icon_state = "tree_6"
/obj/structure/flora/tree/dead/style_random/Initialize(mapload)
	. = ..()
	icon_state = "tree_[rand(1, 6)]"


// Big jungle trees

/obj/structure/flora/tree/jungle
	icon = 'icons/obj/flora/jungletrees.dmi'
	icon_state = "tree1"
	product = /obj/item/stack/material/log
	product_amount = 20
	health = 800
	max_health = 800
	pixel_x = -48
	pixel_y = -16
	shake_animation_degrees = 2

/obj/structure/flora/tree/jungle/get_seethrough_map()
	return SEE_THROUGH_MAP_THREE_X_THREE

/obj/structure/flora/tree/jungle/style_2
	icon_state = "tree2"
/obj/structure/flora/tree/jungle/style_3
	icon_state = "tree3"
/obj/structure/flora/tree/jungle/style_4
	icon_state = "tree4"
/obj/structure/flora/tree/jungle/style_5
	icon_state = "tree5"
/obj/structure/flora/tree/jungle/style_6
	icon_state = "tree6"
/obj/structure/flora/tree/jungle/style_random/Initialize(mapload)
	. = ..()
	icon_state = "tree[rand(1, 6)]"

// Small jungle trees

/obj/structure/flora/tree/jungle/small
	icon = 'icons/obj/flora/jungletreesmall.dmi'
	icon_state = "tree1"
	product = /obj/item/stack/material/log
	product_amount = 10
	health = 400
	max_health = 400
	pixel_y = 0
	pixel_x = -32

/obj/structure/flora/tree/jungle/small/get_seethrough_map()
	return SEE_THROUGH_MAP_THREE_X_TWO

/obj/structure/flora/tree/jungle/small/style_2
	icon_state = "tree2"
/obj/structure/flora/tree/jungle/small/style_3
	icon_state = "tree3"
/obj/structure/flora/tree/jungle/small/style_4
	icon_state = "tree4"
/obj/structure/flora/tree/jungle/small/style_5
	icon_state = "tree5"
/obj/structure/flora/tree/jungle/small/style_6
	icon_state = "tree6"
/obj/structure/flora/tree/jungle/small/style_random/Initialize(mapload)
	. = ..()
	icon_state = "tree[rand(1, 6)]"

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
	icon_state = "tree_sif1"
	product = /obj/item/stack/material/log/sif
	catalogue_data = list(/datum/category_item/catalogue/flora/sif_tree)
	randomize_size = TRUE

	harvest_tool = /obj/item/material/knife
	max_harvests = 2
	min_harvests = -4
	harvest_loot = list(
		/obj/item/reagent_containers/food/snacks/siffruit = 5,
	)

	var/light_shift = 1

/obj/structure/flora/tree/sif/style_2
	icon_state = "tree_sif2"
	light_shift = 2
/obj/structure/flora/tree/sif/style_3
	icon_state = "tree_sif3"
	light_shift = 3
/obj/structure/flora/tree/sif/style_4
	icon_state = "tree_sif4"
	light_shift = 4
/obj/structure/flora/tree/sif/style_5
	icon_state = "tree_sif5"
	light_shift = 5
/obj/structure/flora/tree/sif/style_6
	icon_state = "tree_sif6"
	light_shift = 6
/obj/structure/flora/tree/sif/style_random/Initialize(mapload)
	light_shift = rand(1, 6)
	icon_state = "tree_sif[light_shift]"
	return ..()

/obj/structure/flora/tree/sif/Initialize(mapload)
	. = ..()
	update_icon()

/obj/structure/flora/tree/sif/update_icon()
	set_light(5 - light_shift, 1, "#33ccff")	// 5 variants, missing bulbs. 5th has no bulbs, so no glow.
	var/image/glow = image(icon = icon, icon_state = "[icon_state]_glow")
	glow.plane = ABOVE_LIGHTING_PLANE
	overlays = list(glow)
