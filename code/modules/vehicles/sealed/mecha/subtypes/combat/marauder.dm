/obj/vehicle/sealed/mecha/combat/marauder
	desc = "Heavy-duty, combat exosuit, developed after the Durand model. Rarely found among civilian populations."
	name = "Marauder"
	catalogue_data = list(/datum/category_item/catalogue/technology/marauder)
	icon_state = "marauder"
	initial_icon = "marauder"

	base_movement_speed = 2.5
	integrity = /obj/vehicle/sealed/mecha/combat::integrity * 1.35
	integrity_max = /obj/vehicle/sealed/mecha/combat::integrity_max * 1.35

	comp_armor = /obj/item/vehicle_component/plating/armor/military
	comp_hull = /obj/item/vehicle_component/plating/hull/durable

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 3,
		VEHICLE_MODULE_SLOT_HULL = 3,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
		VEHICLE_MODULE_SLOT_UTILITY = 4,
	)

	deflect_chance = 25
	damage_absorption = list("brute"=0.5,"fire"=0.7,"bullet"=0.45,"laser"=0.6,"energy"=0.7,"bomb"=0.7)
	max_temperature = 60000
	wreckage = /obj/effect/decal/mecha_wreckage/marauder
	add_req_access = 0
	internal_damage_threshold = 25
	force = 45
	mech_faction = MECH_FACTION_NT

	smoke_possible = TRUE
	zoom_possible = TRUE
	thrusters_possible = TRUE

	icon_scale_x = 1.5
	icon_scale_y = 1.5

/obj/vehicle/sealed/mecha/combat/marauder/equipped
	modules = list(
		/obj/item/vehicle_module/lazy/legacy/weapon/energy/pulse,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/missile_rack/explosive,
		/obj/item/vehicle_module/toggled/energy_relay,
		/obj/item/vehicle_module/personal_shield/structural_field/hyperkinetic,
	)

//Meant for random spawns.
/obj/vehicle/sealed/mecha/combat/marauder/old
	desc = "Heavy-duty, combat exosuit, developed after the Durand model. Rarely found among civilian populations. This one is particularly worn looking and likely isn't as sturdy."

	integrity = /obj/vehicle/sealed/mecha/combat::integrity * 0.75
	integrity_max = /obj/vehicle/sealed/mecha/combat::integrity_max * 0.75

/obj/vehicle/sealed/mecha/combat/marauder/old/Initialize(mapload)
	. = ..()
	cell.charge = rand(0, (cell.charge/2))

/obj/vehicle/sealed/mecha/combat/marauder/seraph
	desc = "Heavy-duty, command-type exosuit. This is a custom model, utilized only by high-ranking military personnel."
	name = "Seraph"
	catalogue_data = list(/datum/category_item/catalogue/technology/seraph)
	icon_state = "seraph"
	initial_icon = "seraph"

	base_movement_speed = 3
	integrity = /obj/vehicle/sealed/mecha/combat/marauder::integrity * 1.25
	integrity_max = /obj/vehicle/sealed/mecha/combat/marauder::integrity_max * 1.25

	wreckage = /obj/effect/decal/mecha_wreckage/seraph
	internal_damage_threshold = 20
	force = 55

/obj/vehicle/sealed/mecha/combat/marauder/seraph/equipped
	modules = list(
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/scattershot,
		/obj/item/vehicle_module/lazy/legacy/weapon/ballistic/missile_rack/explosive,
		/obj/item/vehicle_module/toggled/energy_relay,
		/obj/item/vehicle_module/personal_shield/structural_field/hyperkinetic,
		/obj/item/vehicle_module/lazy/legacy/teleporter,
	)

//Note that is the Mauler
/obj/vehicle/sealed/mecha/combat/marauder/mauler
	desc = "A stolen heavy-duty combat exosuit, developed off of the existing Marauder model."
	name = "Mauler"
	icon_state = "mauler"
	initial_icon = "mauler"
	wreckage = /obj/effect/decal/mecha_wreckage/mauler
	mech_faction = MECH_FACTION_SYNDI
