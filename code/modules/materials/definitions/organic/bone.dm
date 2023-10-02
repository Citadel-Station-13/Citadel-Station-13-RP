/datum/material/bone
	id = "bone"
	name = "bone"
	icon_colour = "#e6dfc8"
	stack_type = /obj/item/stack/material/bone
	icon_base = 'icons/turf/walls/stone_wall.dmi'
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'
	melting_point = T0C+300
	sheet_singular_name = "fragment"
	sheet_plural_name = "fragments"
	conductive = 0
	explosion_resistance = 60
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 4, TECH_BLUESPACE = 4, TECH_BIO = 7)
	door_icon_base = "stone"
	table_icon_base = "stone"

/datum/material/bone/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(
		name = "bone roofing tile",
		product = /obj/item/stack/tile/roofing/bone,
		cost = 3,
		amount = 4,
	)
	// todo: refactor, this just decons into fucking steel
	. += create_stack_recipe_datum(
		name = "bone table frame",
		product = /obj/structure/table,
		cost = 1,
		time = 1 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "bone crate",
		product = /obj/structure/closet/crate/ashlander,
		cost = 5,
		time = 3 SECONDS,
	)
	. += create_stack_recipe_datum(category = "statues", name = "bone statue", product = /obj/structure/statue/bone, cost = 15, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "skull statue", product = /obj/structure/statue/bone/skull, cost = 15, time = 2 SECONDS)
	. += create_stack_recipe_datum(category = "statues", name = "half-skull statue", product = /obj/structure/statue/bone/skull/half, cost = 15, time = 2 SECONDS)

/datum/material/bone/wall_touch_special(var/turf/simulated/wall/W, var/mob/living/L)
	var/mob/living/carbon/M = L
	if(istype(M) && L.mind.isholy)
		to_chat(M, "<span class = 'notice'>\The [W] shudders under your touch, starting to become porous.</span>")
		playsound(W, 'sound/effects/attackblob.ogg', 50, 1)
		if(do_after(L, 5 SECONDS))
			spawn(2)
				playsound(W, 'sound/effects/attackblob.ogg', 100, 1)
				W.dismantle_wall()
		return 1
	return 0
