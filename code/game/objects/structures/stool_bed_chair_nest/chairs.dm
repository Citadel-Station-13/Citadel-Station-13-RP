/obj/structure/bed/chair //YES, chairs are a type of bed, which are a type of stool. This works, believe me. -Pete //TODO: Not this.
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon = 'icons/obj/furniture_vr.dmi' // Using Eris furniture //TODO: Ew how about not.
	icon_state = "chair"
	color = "#666666"
	base_icon = "chair"
	buckle_dir = 0
	buckle_lying = 0 //force people to sit up in chairs when buckled
	icon_dimension_y = 32
	var/picked_up_item = /obj/item/material/twohanded/folded_metal_chair
	var/propelled = 0 // Check for fire-extinguisher-driven chairs
	var/stacked_size = 0

/obj/structure/bed/chair/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/bed/chair/LateInitialize()
	. = ..()
	update_layer()

/obj/structure/bed/chair/OnMouseDrop(atom/over, mob/user)
	. = ..()
	if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
		return
	if(!user.has_hands())
		return
	if(!picked_up_item)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	if(over != user) // they're not dragging us to them
		return CLICKCHAIN_DO_NOT_PROPAGATE
	if(!IS_CONSCIOUS(user)) // todo: mobility flags
		return CLICKCHAIN_DO_NOT_PROPAGATE
	if(!Adjacent(over, FALSE)) // they're not adjacent
		return CLICKCHAIN_DO_NOT_PROPAGATE
	if(has_buckled_mobs())
		to_chat(user, SPAN_NOTICE("You cannot fold the chair while someone is buckled to it!"))
		return CLICKCHAIN_DO_NOT_PROPAGATE
	if(stacked_size)
		to_chat(user, SPAN_NOTICE("You cannot fold a chair while its stacked!"))
		return CLICKCHAIN_DO_NOT_PROPAGATE
	var/obj/item/material/twohanded/folded_metal_chair/C = new picked_up_item
	if(!user.put_in_hands(C))
		to_chat(user, SPAN_NOTICE("You need a free hand to fold up the chair."))
		qdel(C)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	to_chat(user, SPAN_NOTICE("You fold up the chair."))
	playsound(src, 'sound/machines/crate_close.ogg', 20, 1)
	qdel(src)
	return CLICKCHAIN_DO_NOT_PROPAGATE

/obj/structure/bed/chair/attack_hand(mob/user)
	if(!stacked_size)
		return ..()
	var/obj/item/material/twohanded/folded_metal_chair/F = new(loc)
	user.put_in_active_hand(F)
	to_chat(user, SPAN_NOTICE("You take a chair off the stack."))
	stacked_size--
	update_overlays()
	playsound(src, 'sound/items/drop/toolbox.ogg', 20, 1)
	if(!stacked_size)
		layer = OBJ_LAYER
		can_buckle = TRUE
		density = FALSE
	return CLICKCHAIN_DO_NOT_PROPAGATE

/obj/structure/bed/chair/attackby(obj/item/I, mob/user)
	if(!padding_material && istype(I, /obj/item/assembly/shock_kit) && !stacked_size)
		var/obj/item/assembly/shock_kit/SK = I
		if(!SK.status)
			to_chat(user, SPAN_NOTICE("\The [SK] is not ready to be attached!"))
			return
		if(!user.attempt_void_item_for_installation(SK))
			return
		var/obj/structure/bed/chair/e_chair/E = new (loc, material.name)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		E.setDir(dir)
		E.part = SK
		SK.forceMove(E)
		SK.master = E
		qdel(src)

	if(istype(I, /obj/item/tool/wrench) && stacked_size)
		to_chat(user, SPAN_NOTICE("You'll need to unstack the chairs before you can take one apart."))
		return FALSE
	if(istype(I, /obj/item/material/twohanded/folded_metal_chair) && picked_up_item)
		if(locate(/mob/living) in loc)
			to_chat(user, SPAN_NOTICE("There's someone in the way!"))
			return FALSE
		qdel(I)
		stacked_size++
		playsound(src, 'sound/effects/metal_close.ogg', 20, 1)
		update_overlays()

		if(stacked_size == 1)
			layer = ABOVE_MOB_LAYER
			can_buckle = FALSE
			density = TRUE
			return FALSE

		if(stacked_size > 8)
			to_chat(user, SPAN_WARNING("The stack of chairs looks unstable!"))
			if(prob(sqrt(50 * stacked_size)))
				stack_collapse()
				return FALSE
		return FALSE

	return ..()

/obj/structure/bed/chair/user_buckle_mob()
	if(stacked_size)
		return FALSE
	return ..()

/obj/structure/bed/chair/attack_tk(mob/user)
	if(has_buckled_mobs())
		..()
	else
		rotate_clockwise()
	return

/obj/structure/bed/chair/mob_buckled(mob/M, flags, mob/user, semantic)
	. = ..()
	update_icon()

/obj/structure/bed/chair/mob_unbuckled(mob/M, flags, mob/user, semantic)
	. = ..()
	update_icon()

/obj/structure/bed/chair/update_icon()
	..()
	if(has_buckled_mobs() && padding_material)
		var/cache_key = "[base_icon]-armrest-[padding_material.name]"
		if(isnull(stool_cache[cache_key]))
			var/image/I = image(icon, "[base_icon]_armrest")
			I.layer = MOB_LAYER + 0.1
			I.plane = MOB_PLANE
			I.color = padding_material.icon_colour
			stool_cache[cache_key] = I
		add_overlay(stool_cache[cache_key])

/obj/structure/bed/chair/proc/update_layer()
	if(src.dir == NORTH)
		plane = MOB_PLANE
		layer = MOB_LAYER + 0.1
	else
		reset_plane_and_layer()

/obj/structure/bed/chair/setDir()
	..()
	update_layer()
	if(has_buckled_mobs())
		for(var/A in buckled_mobs)
			var/mob/living/L = A
			L.setDir(dir)

/obj/structure/bed/chair/verb/rotate_clockwise()
	set name = "Rotate Chair Clockwise"
	set category = "Object"
	set src in oview(1)

	if(!usr || !isturf(usr.loc))
		return
	if(usr.stat || usr.restrained())
		return
	if(ismouse(usr) || (isobserver(usr) && !config_legacy.ghost_interaction))
		return

	src.setDir(turn(src.dir, 270))

/obj/structure/bed/chair/proc/stack_collapse()
	visible_message(SPAN_DANGER("The stack of chairs collapses!!!"))
	var/turf/starting_turf = get_turf(src)
	playsound(starting_turf, 'sound/effects/metal_chair_crash.ogg', 30, 1, 30)
	var/list/turf/candidates = range(min(7, round(stacked_size / 2)), starting_turf) - starting_turf
	for(var/i in 1 to stacked_size)
		var/obj/structure/bed/chair/C = new /obj/structure/bed/chair(starting_turf)
		var/turf/target_turf = pick(candidates)
		C.pixel_x = rand(-8, 8)
		C.pixel_y = rand(-8, 8)
		C.throw_at(target_turf, rand(2, 5), 1, null)
	stacked_size = 0
	var/obj/item/material/twohanded/folded_metal_chair/I = new picked_up_item(starting_turf)
	I.throw_at(starting_turf, 1, 1)
	qdel(src)

/obj/structure/bed/chair/update_overlays()
	overlays.Cut()
	if(!stacked_size)
		name = initial(name)
		desc = initial(desc)
		return ..()
	name = "stack of folding chairs"
	desc = "There seems to be [stacked_size + 1] in the stack, wow!"
	icon_state = base_icon
	var/next_x = 0
	var/next_y = 0
	for(var/i in 1 to stacked_size)
		var/image/I = image(icon = icon, icon_state = icon_state)
		I.dir = dir
		switch(dir)
			if(NORTH)
				next_y += 2
			if(SOUTH)
				next_y += 2
			if(EAST)
				next_y += 3
				next_x += 1
			if(WEST)
				next_y += 3
				next_x -= 1
		I.pixel_x = next_x
		I.pixel_y = next_y + (stacked_size > 8? pick(1, -1) : 0)
		overlays += I
	color = material.icon_colour
	return ..()

/obj/structure/bed/chair/shuttle
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon_state = "shuttle_chair"
	color = null
	base_icon = "shuttle_chair"
	applies_material_colour = 0
	picked_up_item = null

// Leaving this in for the sake of compilation.
/obj/structure/bed/chair/comfy
	desc = "It's a chair. It looks comfy."
	icon_state = "comfychair_preview"
	picked_up_item = null

/obj/structure/bed/chair/comfy/brown/Initialize(mapload, newmaterial)
	return ..(mapload, "steel", "leather")

/obj/structure/bed/chair/comfy/red/Initialize(mapload, newmaterial)
	return ..(mapload, "steel", "carpet")

/obj/structure/bed/chair/comfy/teal/Initialize(mapload, newmaterial)
	return ..(mapload, "steel", "teal")

/obj/structure/bed/chair/comfy/black/Initialize(mapload, newmaterial)
	return ..(mapload, "steel", "black")

/obj/structure/bed/chair/comfy/green/Initialize(mapload, newmaterial)
	return ..(mapload, "steel", "green")

/obj/structure/bed/chair/comfy/purp/Initialize(mapload, newmaterial)
	return ..(mapload, "steel", "purple")

/obj/structure/bed/chair/comfy/blue/Initialize(mapload, newmaterial)
	return ..(mapload, "steel", "blue")

/obj/structure/bed/chair/comfy/beige/Initialize(mapload, newmaterial)
	return ..(mapload, "steel", "beige")

/obj/structure/bed/chair/comfy/lime/Initialize(mapload, newmaterial)
	return ..(mapload, "steel", "lime")

/obj/structure/bed/chair/comfy/orange/Initialize(mapload, newmaterial)
	return ..(mapload, "steel", "orange")

/obj/structure/bed/chair/office
	anchored = FALSE
	picked_up_item = null

/obj/structure/bed/chair/office/update_icon()
	return

/obj/structure/bed/chair/office/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack) || W.is_wirecutter())
		return
	..()

/obj/structure/bed/chair/office/Bump(atom/A)
	..()
	if(!has_buckled_mobs())
		return

	if(propelled)
		for(var/a in buckled_mobs)
			var/mob/living/occupant = unbuckle_mob(a)

			var/def_zone = ran_zone()
			var/blocked = occupant.run_armor_check(def_zone, "melee")
			var/soaked = occupant.get_armor_soak(def_zone, "melee")
			occupant.throw_at_old(A, 3, propelled)
			occupant.apply_effect(6, STUN, blocked)
			occupant.apply_effect(6, WEAKEN, blocked)
			occupant.apply_effect(6, STUTTER, blocked)
			occupant.apply_damage(10, BRUTE, def_zone, blocked, soaked)
			playsound(src.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
			if(istype(A, /mob/living))
				var/mob/living/victim = A
				def_zone = ran_zone()
				blocked = victim.run_armor_check(def_zone, "melee")
				soaked = victim.get_armor_soak(def_zone, "melee")
				victim.apply_effect(6, STUN, blocked)
				victim.apply_effect(6, WEAKEN, blocked)
				victim.apply_effect(6, STUTTER, blocked)
				victim.apply_damage(10, BRUTE, def_zone, blocked, soaked)
			occupant.visible_message("<span class='danger'>[occupant] crashed into \the [A]!</span>")

/obj/structure/bed/chair/office/light
	icon_state = "officechair_white"

/obj/structure/bed/chair/office/dark
	icon_state = "officechair_dark"

// Chair types
/obj/structure/bed/chair/wood
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."
	icon_state = "wooden_chair"
	picked_up_item = null

/obj/structure/bed/chair/wood/update_icon()
	return

/obj/structure/bed/chair/wood/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack) || W.is_wirecutter())
		return
	..()

/obj/structure/bed/chair/wood/Initialize(mapload, material_key)
	return ..(mapload, "wood")

/obj/structure/bed/chair/wood/wings
	icon_state = "wooden_chair_wings"


//sofa

/obj/structure/bed/chair/sofa
	name = "sofa"
	desc = "It's a sofa. You sit on it. Possibly with someone else."
	icon = 'icons/obj/sofas.dmi'
	base_icon = "sofamiddle"
	icon_state = "sofamiddle"
	applies_material_colour = 1
	var/sofa_material = "carpet"
	picked_up_item = null

/obj/structure/bed/chair/sofa/update_icon()
	if(applies_material_colour && sofa_material)
		var/datum/material/color_material = get_material_by_name(sofa_material)
		color = color_material.icon_colour

		if(sofa_material == "carpet")
			name = "red [initial(name)]"
		else
			name = "[sofa_material] [initial(name)]"

/obj/structure/bed/chair/update_layer()
	// Corner east/west should be on top of mobs, any other state's north should be.
	if((icon_state == "sofacorner" && ((dir & EAST) || (dir & WEST))) || (icon_state != "sofacorner" && (dir & NORTH)))
		plane = MOB_PLANE
		layer = MOB_LAYER + 0.1
	else
		reset_plane_and_layer()

/obj/structure/bed/chair/sofa/left
	icon_state = "sofaend_left"
	base_icon = "sofaend_left"

/obj/structure/bed/chair/sofa/right
	icon_state = "sofaend_right"
	base_icon = "sofaend_right"

/obj/structure/bed/chair/sofa/corner
	icon_state = "sofacorner"
	base_icon = "sofacorner"

//color variations

/obj/structure/bed/chair/sofa
	sofa_material = "black"

/obj/structure/bed/chair/sofa/brown
	sofa_material = "leather"

/obj/structure/bed/chair/sofa/red
	sofa_material = "carpet"

/obj/structure/bed/chair/sofa/teal
	sofa_material = "teal"

/obj/structure/bed/chair/sofa/black
	sofa_material = "black"

/obj/structure/bed/chair/sofa/green
	sofa_material = "green"

/obj/structure/bed/chair/sofa/purp
	sofa_material = "purple"

/obj/structure/bed/chair/sofa/blue
	sofa_material = "blue"

/obj/structure/bed/chair/sofa/beige
	sofa_material = "beige"

/obj/structure/bed/chair/sofa/lime
	sofa_material = "lime"

/obj/structure/bed/chair/sofa/yellow
	sofa_material = "yellow"

/obj/structure/bed/chair/sofa/orange
	sofa_material = "orange"

//sofa directions

/obj/structure/bed/chair/sofa/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/brown/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/brown/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/brown/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/teal/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/teal/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/teal/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/black/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/black/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/black/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/red/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/red/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/red/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/green/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/green/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/green/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/purp/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/purp/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/purp/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/blue/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/blue/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/blue/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/beige/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/beige/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/beige/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/lime/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/lime/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/lime/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/yellow/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/yellow/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/yellow/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/sofa/orange/left
	icon_state = "sofaend_left"

/obj/structure/bed/chair/sofa/orange/right
	icon_state = "sofaend_right"

/obj/structure/bed/chair/sofa/orange/corner
	icon_state = "sofacorner"

/obj/structure/bed/chair/pew
	name = "pew"
	desc = "It's a wooden bench. You sit on it. Possibly with someone else."
	icon = 'icons/obj/sofas.dmi'
	base_icon = "pewmiddle"
	icon_state = "pewmiddle"
	picked_up_item = null


/obj/structure/bed/chair/pew/Initialize(mapload, new_material)
	. = ..(mapload)
	if(!new_material)
		new_material = MAT_WOOD
	material = get_material_by_name(new_material)
	update_icon()

/obj/structure/bed/chair/pew/left
	icon_state = "pewend_left"
	base_icon = "pewend_left"

/obj/structure/bed/chair/pew/right
	icon_state = "pewend_right"
	base_icon = "pewend_right"

//Apidean Chairs!
/obj/structure/bed/chair/apidean
	name = "\improper Apidean throne"
	desc = "This waxy chair is designed to allow creatures with insectoid abdomens to lounge comfortably. Typically reserved for the Apidean upper class."
	icon_state = "queenthrone"
	base_icon = "queenthrone"
	picked_up_item = null

/obj/structure/bed/chair/apidean/Initialize(mapload, new_material)
	. = ..(mapload, "wax", null)

//Wax Stools for Bees! I've put it here because it shouldn't inherit stool properties.
/obj/structure/bed/chair/apidean_stool
	name = "\improper Apidean stool"
	desc = "A specially crafted stool made out of hardened wax. Often found on Apidean colonies and vessels."
	icon_state = "stool_apidean"
	base_icon = "stool_apidean"
	picked_up_item = null

/obj/structure/bed/chair/apidean_stool/Initialize(mapload, new_material)
	. = ..(mapload, "wax", null)

/obj/structure/bed/chair/post
	name = "tying post"
	desc = "A primitive post used to leash beasts of burden or riding mounts to one place."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "horsepost"
	base_icon = "horsepost"
	picked_up_item = null

/obj/structure/bed/chair/post/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack) || W.is_wirecutter())
		return
	..()

/obj/structure/bed/chair/post/Initialize(mapload, new_material)
	. = ..(mapload, "bone", null)

/obj/item/material/twohanded/folded_metal_chair //used for when someone picks up the chair
	name = "metal folding chair"
	desc = "A metal folding chair, probably could be turned into a seat by anyone with half a braincell working."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "folding_chair0"
	base_icon = "folding_chair"
	attack_verb = list("bashed", "battered", "chaired")
	force = 1
	throw_force = 3
	sharp = null
	edge = 0
	w_class = ITEMSIZE_LARGE
	force_wielded = 10
	hitsound = 'sound/effects/metal_chair_slam.ogg'
	pickup_sound = 'sound/items/pickup/axe.ogg'
	drop_sound = 'sound/effects/metal_chair_clang.ogg'
	var/placed_object = /obj/structure/bed/chair

/obj/item/material/twohanded/folded_metal_chair/afterattack(atom/target, mob/user, proximity)
	if(!isturf(target)) // not turf
		return ..()
	if(!proximity) // not adjacent
		return ..()
	if(target.density) // is dense
		return ..()
	var/turf/T = target
	for(var/atom/movable/AM as anything in T.contents) // no typecheck
		if(AM.density || istype(AM, /obj/structure/bed))
			to_chat(user, SPAN_WARNING("You can't unfold the chair here, [AM] blocks the way."))
			return
	var/obj/O = new placed_object(T)
	playsound(src, 'sound/machines/closet_open.ogg', 20, 1)
	O.setDir(user.dir)
	qdel(src)
	return CLICKCHAIN_DO_NOT_PROPAGATE // terminate click handling

/obj/item/material/twohanded/folded_metal_chair/throw_impacted(atom/A, datum/thrownthing/TT)
	playsound(src, 'sound/effects/metal_chair_slam.ogg', 50, 1)
	return ..()
