/obj/vehicle/sealed/mecha/medical/odysseus
	desc = "These exosuits are developed and produced by Vey-Med. (&copy; All rights reserved)."
	name = "Odysseus"
	catalogue_data = list(
		/datum/category_item/catalogue/technology/odysseus,
		/datum/category_item/catalogue/information/organization/vey_med
		)
	icon_state = "odysseus"
	initial_icon = "odysseus"
	step_in = 2
	max_temperature = 15000
	integrity = 70
	integrity_max = 70
	wreckage = /obj/effect/decal/mecha_wreckage/odysseus
	internal_damage_threshold = 35
	deflect_chance = 15
	step_energy_drain = 6
	var/obj/item/clothing/glasses/hud/integrity/mech/hud

	icon_scale_x = 1.2
	icon_scale_y = 1.2

/obj/vehicle/sealed/mecha/medical/odysseus/Initialize(mapload)
	. = ..()
	hud = new /obj/item/clothing/glasses/hud/integrity/mech(src)

/obj/vehicle/sealed/mecha/medical/odysseus/moved_inside(var/mob/living/carbon/human/H as mob)
	if(..())
		if(H.glasses)
			occupant_message("<font color='red'>[H.glasses] prevent you from using [src] [hud]</font>")
		else
			H.glasses = hud
			H.recalculate_vis()
		return 1
	else
		return 0

/obj/vehicle/sealed/mecha/medical/odysseus/mob_exit(mob/exiting, silent, randomstep)
	. = ..()
	if(!.)
		return
	if(ishuman(exiting))
		var/mob/living/carbon/human/H = exiting
		if(H.glasses == hud)
			H.glasses = null
			H.recalculate_vis()

//TODO - Check documentation for client.eye and client.perspective...
/obj/item/clothing/glasses/hud/integrity/mech
	name = "Integrated Medical Hud"

/obj/vehicle/sealed/mecha/medical/odysseus/loaded/Initialize(mapload)
	. = ..()
	var/obj/item/mecha_parts/mecha_equipment/ME = new /obj/item/mecha_parts/mecha_equipment/tool/sleeper
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/sleeper
	ME.attach(src)
	ME = new /obj/item/mecha_parts/mecha_equipment/tool/syringe_gun
	ME.attach(src)

//Meant for random spawns.
/obj/vehicle/sealed/mecha/medical/odysseus/old
	desc = "An aging combat exosuit utilized by many corporations. Originally developed to combat hostile alien lifeforms. This one is particularly worn looking and likely isn't as sturdy."

/obj/vehicle/sealed/mecha/medical/odysseus/old/Initialize(mapload)
	. = ..()
	integrity = 25
	integrity_max = 50	//Just slightly worse.
	cell.charge = rand(0, (cell.charge/2))
