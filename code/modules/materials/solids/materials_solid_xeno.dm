/datum/material/solid/diona
	name = "biomass"
	uid = "solid_xeno_diona"
	color = null
	stack_type = null
	integrity = 600
	wall_icon = 'icons/turf/walls/diona.dmi'
	wall_reinf_icon = null

/datum/material/solid/diona/place_dismantled_product()
	return

/datum/material/solid/diona/place_dismantled_girder(turf/target)
	spawn_diona_nymph(target)


/datum/material/solid/resin
	name = "resin"
	uid = "solid_xeno_resin"
	color = "#261438"
	wall_icon = 'icons/turf/walls/resin.dmi'
	dooropen_noise = 'sound/effects/attackblob.ogg'
	door_icon_base = "resin"
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'
	melting_point = T0C+300
	sheet_singular_name = "blob"
	sheet_plural_name = "blobs"
	conductive = 0
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 4, TECH_BLUESPACE = 4, TECH_BIO = 7)
	stack_type = /obj/item/stack/material/resin

/datum/material/solid/resin/can_open_material_door(var/mob/living/user)
	var/mob/living/carbon/M = user
	if(istype(M) && locate(/obj/item/organ/internal/xenos/hivenode) in M.internal_organs)
		return 1
	return 0

/datum/material/solid/resin/wall_touch_special(var/turf/simulated/wall/W, var/mob/living/L)
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


/datum/material/solid/resin/hybrid
	name = "resin compound"
	uid = "solid_xeno_resin_hybrid"
	color = "#321a49"
	wall_icon = 'icons/turf/walls/resin.dmi'
	dooropen_noise = 'sound/effects/attackblob.ogg'
	door_icon_base = "resin"
	wall_reinf_icon = 'icons/turf/walls/reinf_mesh.dmi'
	melting_point = T0C+200//we melt faster this isnt a building material you wanna built engines from
	sheet_singular_name = "bar"
	sheet_plural_name = "bars"
	conductive = 0
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	stack_type = /obj/item/stack/material/hybrid_resin


/obj/item/stack/material/hybrid_resin
	name = "resin compound"
	icon_state = "sheet-resin"
	default_type = "resin compound"
	no_variants = TRUE
	apply_colour = TRUE
	pass_color = TRUE
	strict_color_stacking = TRUE

/datum/material/solid/resin/hybrid/generate_recipes()
	recipes = list()
	recipes += new/datum/stack_recipe("[display_name] door", /obj/structure/simple_door/hybrid_resin, 10, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] barricade", /obj/effect/alien/hybrid_resin/wall, 5, time = 5 SECONDS, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] nest", /obj/structure/bed/hybrid_nest, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("crude [display_name] bandage", /obj/item/stack/medical/crude_pack, 1, time = 2 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] membrane", /obj/effect/alien/hybrid_resin/membrane, 1, time = 2 SECONDS, pass_stack_color = TRUE)
