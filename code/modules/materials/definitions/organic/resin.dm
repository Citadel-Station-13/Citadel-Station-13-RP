/datum/material/resin
	id = "xenoresin"
	name = "resin"
	icon_colour = "#261438"
	icon_base = 'icons/turf/walls/resin.dmi'
	dooropen_noise = 'sound/effects/attackblob.ogg'
	door_icon_base = "resin"
	icon_reinf = 'icons/turf/walls/reinforced_mesh.dmi'
	melting_point = T0C+300
	sheet_singular_name = "blob"
	sheet_plural_name = "blobs"
	conductive = 0
	explosion_resistance = 60
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 4, TECH_BLUESPACE = 4, TECH_BIO = 7)
	stack_type = /obj/item/stack/material/resin

/datum/material/resin/generate_recipes()
	. = ..()
	. += create_stack_recipe_datum(
		name = "resin nest",
		product = /obj/structure/bed/nest,
		exclusitivity = /obj/structure/bed,
		cost = 2,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "crude resin bandage",
		product = /obj/item/stack/medical/crude_pack,
		time = 2 SECONDS,
		cost = 1,
	)
	. += create_stack_recipe_datum(
		name = "resin membrane",
		product = /obj/effect/alien/resin/membrane,
		cost = 1,
		time = 2 SECONDS,
	)
	. += create_stack_recipe_datum(
		name = "resin node",
		product = /obj/effect/alien/weeds/node,
		cost = 1,
		time = 2 SECONDS,
	)

/datum/material/resin/can_open_material_door(var/mob/living/user)
	var/mob/living/carbon/M = user
	if(istype(M) && locate(/obj/item/organ/internal/xenos/hivenode) in M.internal_organs)
		return 1
	return 0

/datum/material/resin/wall_touch_special(var/turf/simulated/wall/W, var/mob/living/L)
	var/mob/living/carbon/M = L
	if(istype(M) && locate(/obj/item/organ/internal/xenos/hivenode) in M.internal_organs)
		to_chat(M, "<span class='alien'>\The [W] shudders under your touch, starting to become porous.</span>")
		playsound(W, 'sound/effects/attackblob.ogg', 50, 1)
		if(do_after(L, 5 SECONDS))
			spawn(2)
				playsound(W, 'sound/effects/attackblob.ogg', 100, 1)
				W.dismantle_wall()
		return 1
	return 0
