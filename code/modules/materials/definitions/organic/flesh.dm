/datum/material/flesh
	id = "flesh"
	name = "flesh"
	icon_colour = "#35343a"
	dooropen_noise = 'sound/effects/attackblob.ogg'
	door_icon_base = "fleshclosed"
	melting_point = T0C+300
	sheet_singular_name = "glob"
	sheet_plural_name = "globs"
	conductive = 0
	explosion_resistance = 60
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 8, TECH_PHORON = 4, TECH_BLUESPACE = 4, TECH_BIO = 7)

/datum/material/flesh
	id = "flesh"
	name = "flesh"
	display_name = "chunk of flesh"
	icon_colour = "#dd90aa"
	sheet_singular_name = "meat"
	sheet_plural_name = "meats"
	integrity = 1200
	melting_point = 6000
	explosion_resistance = 200
	hardness = 500
	weight = 500

/datum/material/flesh/can_open_material_door(var/mob/living/user)
	var/mob/living/carbon/M = user
	if(istype(M))
		return 1
	return 0

/datum/material/flesh/wall_touch_special(var/turf/simulated/wall/W, var/mob/living/L)
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
