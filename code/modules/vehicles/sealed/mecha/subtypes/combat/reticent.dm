/datum/armor/vehicle/mecha/combat/reticent
	melee = 0.45

/obj/vehicle/sealed/mecha/combat/reticent
	name = "Reticent"
	desc = "Designed in response to the H.O.N.K., Reticent models are close combat powerhouses designed to rapidly and quietly ambush slower foes."
	icon_state = "reticent"
	initial_icon = "reticent"
	dir_in = 1 //Facing North.
	integrity = 180
	integrity_max = 180			//Don't forget to update the /old variant if  you change this number.

	armor = /datum/armor/vehicle/mecha/combat/reticent
	base_movement_speed = 3.33
	comp_armor = /obj/item/vehicle_component/plating/armor/marshal
	comp_hull = /obj/item/vehicle_component/plating/hull/lightweight

	max_temperature = 25000
	wreckage = /obj/effect/decal/mecha_wreckage/reticent
	internal_damage_threshold = 35

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 2,
		VEHICLE_MODULE_SLOT_HULL = 2,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
		VEHICLE_MODULE_SLOT_UTILITY = 2,
	)

	overload_possible = 1

	icon_scale_x = 1.35
	icon_scale_y = 1.35

	stomp_sound = 'sound/effects/suitstep1.ogg'
	swivel_sound = 'sound/effects/suitstep2.ogg'

/obj/vehicle/sealed/mecha/combat/reticent/reticence
	name = "Reticence"
	desc = "The current flagship mecha of Le Rien. The Reticence trades some speed for durability, but remains formidable. It is not commercially available."
	icon_state = "reticence"
	initial_icon = "reticence"
	integrity = 350
	integrity_max = 350
	base_movement_speed = 3
	deflect_chance = 40
	damage_absorption = list("brute"=0.8,"fire"=0.6,"bullet"=0.5,"laser"=0.65,"energy"=0.6,"bomb"=0.8)
	max_temperature = 45000
	overload_coeff = 1
	wreckage = /obj/effect/decal/mecha_wreckage/reticent/reticence
	step_energy_drain = 5

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 2,
		VEHICLE_MODULE_SLOT_HULL = 3,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
		VEHICLE_MODULE_SLOT_UTILITY = 4,
	)

/obj/vehicle/sealed/mecha/combat/reticent/reticence/equipped
	modules = list(
		/obj/item/vehicle_module/lazy/legacy/weapon/whisperblade,
		/obj/item/vehicle_module/lazy/legacy/weapon/infernoblade,
		/obj/item/vehicle_module/lazy/legacy/omni_shield/reticence,
		/obj/item/vehicle_module/lazy/legacy/cloak,
	)

/obj/vehicle/sealed/mecha/combat/reticent/reticence/add_cell(var/obj/item/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new(src)
	cell.charge = 30000
	cell.maxcharge = 30000
