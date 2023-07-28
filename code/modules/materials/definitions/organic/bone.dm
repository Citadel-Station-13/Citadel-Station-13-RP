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
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 4, TECH_BLUESPACE = 4, TECH_BIO = 7)
	door_icon_base = "stone"
	table_icon_base = "stone"

	relative_integrity = 0.75
	relative_weight = 0.75
	relative_density = 1
	relative_conductivity = 0.1
	relative_permeability = 0.07
	relative_reactivity = 1
	regex_this_hardness = MATERIAL_RESISTANCE_MODERATE
	toughness = MATERIAL_RESISTANCE_MODERATE
	refraction = MATERIAL_RESISTANCE_NONE
	absorption = MATERIAL_RESISTANCE_MODERATE
	nullification = MATERIAL_RESISTANCE_NONE

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
