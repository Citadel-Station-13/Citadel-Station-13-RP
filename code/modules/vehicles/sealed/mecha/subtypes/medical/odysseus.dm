/obj/vehicle/sealed/mecha/medical/odysseus
	name = "Odysseus"
	desc = "These exosuits are developed and produced by Vey-Med. (&copy; All rights reserved)."
	description_fluff = "The dominant medical exosuit on the modern market, the Odysseus is a Vey-Med product designed to incorporate other Vey-Med inventions - like the Sleeper - into a mobile frame. The Odysseus' focus on rescue operations in hazardous environments is augmented with some of the best agility ratings on the civilian market. In spite of its narrow profile, the Odysseus stands slightly taller than the APLU at 9.5'(3m). Capable of operating in vacuum as well as in most adverse weather conditions, the staying power of this mecha speaks volumes for its efficacy."
	catalogue_data = list(
		/datum/category_item/catalogue/technology/odysseus,
		/datum/category_item/catalogue/information/organization/vey_med
		)
	icon_state = "odysseus"
	initial_icon = "odysseus"

	base_movement_speed = 4.8

	occupant_huds = list(
		/datum/atom_hud/data/human/medical,
	)

	max_temperature = 15000
	integrity = 70
	integrity_max = 70
	wreckage = /obj/effect/decal/mecha_wreckage/odysseus
	internal_damage_threshold = 35

	icon_scale_x = 1.2
	icon_scale_y = 1.2

/obj/effect/decal/mecha_wreckage/odysseus
	name = "Odysseus wreckage"
	icon_state = "odysseus-broken"

/obj/effect/decal/mecha_wreckage/odysseus/New()
	..()
	var/list/parts = list(
		/obj/item/vehicle_part/odysseus_torso,
		/obj/item/vehicle_part/odysseus_head,
		/obj/item/vehicle_part/odysseus_left_arm,
		/obj/item/vehicle_part/odysseus_right_arm,
		/obj/item/vehicle_part/odysseus_left_leg,
		/obj/item/vehicle_part/odysseus_right_leg,
	)
	for(var/i=0;i<2;i++)
		if(!!length(parts) && prob(40))
			var/part = pick(parts)
			welder_salvage += part
			parts -= part

/obj/vehicle/sealed/mecha/medical/odysseus/equipped
	modules = list(
		/obj/item/vehicle_module/lazy/legacy/tool/sleeper,
		/obj/item/vehicle_module/lazy/legacy/tool/sleeper,
		/obj/item/vehicle_module/lazy/legacy/tool/syringe_gun,
	)

//Meant for random spawns.
/obj/vehicle/sealed/mecha/medical/odysseus/old
	desc = "An aging combat exosuit utilized by many corporations. Originally developed to combat hostile alien lifeforms. This one is particularly worn looking and likely isn't as sturdy."

/obj/vehicle/sealed/mecha/medical/odysseus/old/Initialize(mapload)
	. = ..()
	integrity = 25
	integrity_max = 50	//Just slightly worse.
	cell.charge = rand(0, (cell.charge/2))
