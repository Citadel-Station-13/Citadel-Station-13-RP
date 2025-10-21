/datum/armor/vehicle/mecha/combat/durand

/obj/vehicle/sealed/mecha/combat/durand
	desc = "An aging combat exosuit utilized by many corporations. Originally developed to combat hostile alien lifeforms."
	name = "Durand"
	icon_state = "durand"
	initial_icon = "durand"

	armor_type = /datum/armor/vehicle/mecha/combat/durand
	integrity = /obj/vehicle/sealed/mecha/combat::integrity
	integrity_max = /obj/vehicle/sealed/mecha/combat::integrity_max
	base_movement_speed = 2.5

	comp_hull = /obj/item/vehicle_component/plating/hull/durable
	comp_armor = /obj/item/vehicle_component/plating/armor/military

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 2,
		VEHICLE_MODULE_SLOT_HULL = 3,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
		VEHICLE_MODULE_SLOT_UTILITY = 4,
		VEHICLE_MODULE_SLOT_UNIVERSAL = 3,
	)
	modules_intrinsic = list(
		/obj/item/vehicle_module/personal_shield/deflector/durand,
	)

	dir_in = 1 //Facing North.
	deflect_chance = 20
	damage_absorption = list("brute"=0.5,"fire"=1.1,"bullet"=0.65,"laser"=0.85,"energy"=0.9,"bomb"=0.8)
	max_temperature = 30000
	force = 40
	wreckage = /obj/effect/decal/mecha_wreckage/durand

	damage_minimum = 15			//Big stompy
	minimum_penetration = 25

	icon_scale_x = 1.5
	icon_scale_y = 1.5

//Meant for random spawns.
/obj/vehicle/sealed/mecha/combat/durand/old
	desc = "An aging combat exosuit utilized by many corporations. Originally developed to combat hostile alien lifeforms. This one is particularly worn looking and likely isn't as sturdy."

/obj/vehicle/sealed/mecha/combat/durand/old/Initialize(mapload)
	. = ..()
	integrity = 25
	integrity_max = 250	//Just slightly worse.
	cell.charge = rand(0, (cell.charge/2))
