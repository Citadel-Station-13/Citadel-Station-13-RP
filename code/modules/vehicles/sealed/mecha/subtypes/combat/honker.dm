/datum/armor/vehicle/mecha/combat/honker

/obj/vehicle/sealed/mecha/combat/honker
	name = "H.O.N.K."
	desc = "The H.O.N.K. mecha is sometimes crafted by deranged Roboticists with a grudge, and is illegal in thirty six different sectors."
	icon_state = "honker"
	initial_icon = "honker"

	armor_type = /datum/armor/vehicle/mecha/combat/honker
	integrity = /obj/vehicle/sealed/mecha/combat::integrity * (5 / 6)
	integrity_max = /obj/vehicle/sealed/mecha/combat::integrity_max * (5 / 6)
	base_movement_speed = 3.75

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 1,
		VEHICLE_MODULE_SLOT_HULL = 2,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
		VEHICLE_MODULE_SLOT_UTILITY = 2,
	)

	comp_armor = /obj/item/vehicle_component/plating/armor/marshal
	comp_hull = /obj/item/vehicle_component/plating/hull/durable

	dir_in = 1 //Facing North.
	deflect_chance = 15
	damage_absorption = list("brute"=0.75,"fire"=1,"bullet"=0.8,"laser"=0.7,"energy"=0.85,"bomb"=1)
	max_temperature = 25000
	wreckage = /obj/effect/decal/mecha_wreckage/honker
	internal_damage_threshold = 35

	icon_scale_x = 1.35
	icon_scale_y = 1.35

/datum/armor/vehicle/mecha/combat/honker/cluwne

/obj/vehicle/sealed/mecha/combat/honker/cluwne
	name = "C.L.U.W.N.E."
	desc = "The C.L.U.W.N.E. mecha is an up-armored cousin of the H.O.N.K. mech. Still in service on the borders of Scaena Globus, this unit is not typically commercially available."
	icon = 'icons/mecha/mecha_vr.dmi'
	icon_state = "cluwne"
	initial_icon = "cluwne"

	armor_type = /datum/armor/vehicle/mecha/combat/honker/cluwne
	integrity = /obj/vehicle/sealed/mecha/combat/honker::integrity * 1.45
	integrity_max = /obj/vehicle/sealed/mecha/combat/honker::integrity_max * 1.45
	base_movement_speed = 3

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 2,
		VEHICLE_MODULE_SLOT_HULL = 3,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
		VEHICLE_MODULE_SLOT_UTILITY = 3,
	)

	deflect_chance = 25
	damage_absorption = list("brute"=0.6,"fire"=0.8,"bullet"=0.6,"laser"=0.5,"energy"=0.65,"bomb"=0.8)
	max_temperature = 45000
	overload_coeff = 1
	wreckage = /obj/effect/decal/mecha_wreckage/honker/cluwne
	step_energy_drain = 5

/obj/vehicle/sealed/mecha/combat/honker/cluwne/equipped
	modules = list(
		/obj/item/vehicle_module/lazy/legacy/weapon/honker,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/missile_rack/grenade/banana,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/scattershot,
		/obj/item/vehicle_module/toggled/energy_relay,
		/obj/item/vehicle_module/lazy/legacy/teleporter,
	)

/obj/vehicle/sealed/mecha/combat/honker/cluwne/add_cell(var/obj/item/cell/C=null)
	if(C)
		C.forceMove(src)
		cell = C
		return
	cell = new(src)
	cell.charge = 30000
	cell.maxcharge = 30000
