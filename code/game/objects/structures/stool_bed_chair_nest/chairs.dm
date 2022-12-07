//TODO: REPATH TO /obj/structure/chair @Zandario
/obj/structure/bed/chair //YES, chairs are a type of bed, which are a type of stool. This works, believe me. -Pete //TODO: Not this.
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon = 'icons/obj/structures/furniture_vr.dmi' // Using Eris furniture //TODO: Ew how about not.
	icon_state = "chair_preview"
	base_icon_state = "chair"
	color = "#666666"
	buckle_dir = 0
	buckle_lying = 0 //force people to sit up in chairs when buckled
	icon_dimension_y = 32

	material = MAT_STEEL

	var/propelled = 0 // Check for fire-extinguisher-driven chairs

/obj/structure/bed/chair/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/bed/chair/LateInitialize()
	. = ..()
	update_layer()

/obj/structure/bed/chair/get_default_material()
	return MAT_STEEL

/obj/structure/bed/chair/attackby(obj/item/W, mob/user)
	..()
	if(!reinf_material && istype(W, /obj/item/assembly/shock_kit))
		var/obj/item/assembly/shock_kit/SK = W
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
	. = ..()
	if(has_buckled_mobs() && reinf_material)
		var/cache_key = "[base_icon_state]-armrest-[reinf_material.name]"
		if(isnull(stool_cache[cache_key]))
			var/image/I = image(icon, "[base_icon_state]_armrest")
			I.layer = MOB_LAYER + 0.1
			I.plane = MOB_PLANE
			I.color = reinf_material.color
			stool_cache[cache_key] = I
		overlays |= stool_cache[cache_key]

/obj/structure/bed/chair/proc/update_layer()
	if(src.dir == NORTH)
		plane = ABOVE_PLANE
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

/obj/structure/bed/chair/shuttle
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon_state = "shuttle_chair"
	color = null
	base_icon_state = "shuttle_chair"
	applies_material_color = 0

// Leaving this in for the sake of compilation.
/obj/structure/bed/chair/comfy
	name = "comfy chair"
	desc = "It's a chair. It looks comfy."
	icon_state = "comfychair_preview"

/obj/structure/bed/chair/comfy/brown
	reinf_material = /datum/material/solid/leather

/obj/structure/bed/chair/comfy/red
	reinf_material = /datum/material/solid/carpet

/obj/structure/bed/chair/comfy/teal
	reinf_material = /datum/material/solid/cloth/teal

/obj/structure/bed/chair/comfy/black
	reinf_material = /datum/material/solid/cloth/black

/obj/structure/bed/chair/comfy/green
	reinf_material = /datum/material/solid/cloth/green

/obj/structure/bed/chair/comfy/purple
	reinf_material = /datum/material/solid/cloth/purple

/obj/structure/bed/chair/comfy/blue
	reinf_material = /datum/material/solid/cloth/blue

/obj/structure/bed/chair/comfy/beige
	reinf_material = /datum/material/solid/cloth/beige

/obj/structure/bed/chair/comfy/lime
	reinf_material = /datum/material/solid/cloth/lime

/obj/structure/bed/chair/comfy/yellow
	reinf_material = /datum/material/solid/cloth/yellow

/obj/structure/bed/chair/office
	anchored = FALSE

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
			playsound(src.loc, 'sound/weapons/punch1.ogg', 50, TRUE, -1)
			if(istype(A, /mob/living))
				var/mob/living/victim = A
				def_zone = ran_zone()
				blocked = victim.run_armor_check(def_zone, "melee")
				soaked = victim.get_armor_soak(def_zone, "melee")
				victim.apply_effect(6, STUN, blocked)
				victim.apply_effect(6, WEAKEN, blocked)
				victim.apply_effect(6, STUTTER, blocked)
				victim.apply_damage(10, BRUTE, def_zone, blocked, soaked)
			occupant.visible_message(SPAN_DANGER("[occupant] crashed into \the [A]!"))

/obj/structure/bed/chair/office/light
	icon_state = "officechair_white"

/obj/structure/bed/chair/office/dark
	icon_state = "officechair_dark"

// Chair types
/obj/structure/bed/chair/wood
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."
	icon_state = "wooden_chair"
	material = MAT_WOOD


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


/obj/structure/bed/chair/pew
	name = "pew"
	desc = "It's a wooden bench. You sit on it. Possibly with someone else."
	icon = 'icons/obj/structures/sofas.dmi'
	base_icon_state = "pewmiddle"
	icon_state = "pewmiddle"
	material = MAT_WOOD


/obj/structure/bed/chair/pew/Initialize(mapload, new_material)
	. = ..(mapload)
	if(!new_material)
		new_material = MAT_WOOD
	material = GET_MATERIAL_REF(new_material)
	update_icon()

/obj/structure/bed/chair/pew/left
	icon_state = "pewend_left"
	base_icon_state = "pewend_left"

/obj/structure/bed/chair/pew/right
	icon_state = "pewend_right"
	base_icon_state = "pewend_right"

//Apidean Chairs!
/obj/structure/bed/chair/apidean
	name = "\improper Apidean throne"
	desc = "This waxy chair is designed to allow creatures with insectoid abdomens to lounge comfortably. Typically reserved for the Apidean upper class."
	icon_state = "queenthrone"
	base_icon_state = "queenthrone"
	material = MAT_WAX


//Wax Stools for Bees! I've put it here because it shouldn't inherit stool properties.
/obj/structure/bed/chair/apidean_stool
	name = "\improper Apidean stool"
	desc = "A specially crafted stool made out of hardened wax. Often found on Apidean colonies and vessels."
	icon_state = "stool_apidean"
	base_icon_state = "stool_apidean"
	material = MAT_WAX
