/obj/vehicle/sealed/mecha/combat/marauder
	desc = "Heavy-duty, combat exosuit, developed after the Durand model. Rarely found among civilian populations."
	name = "Marauder"
	catalogue_data = list(/datum/category_item/catalogue/technology/marauder)
	icon_state = "marauder"
	initial_icon = "marauder"

	base_movement_speed = 2.5
	step_in = 5
	integrity = 350
	integrity_max = 350		//Don't forget to update the /old variant if  you change this number.
	deflect_chance = 25
	damage_absorption = list("brute"=0.5,"fire"=0.7,"bullet"=0.45,"laser"=0.6,"energy"=0.7,"bomb"=0.7)
	max_temperature = 60000
	infra_luminosity = 3
	operation_req_access = list(ACCESS_CENTCOM_ERT)
	wreckage = /obj/effect/decal/mecha_wreckage/marauder
	add_req_access = 0
	internal_damage_threshold = 25
	force = 45
	max_equip = 4
	mech_faction = MECH_FACTION_NT

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 3,
		VEHICLE_MODULE_SLOT_HULL = 3,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
		VEHICLE_MODULE_SLOT_UTILITY = 4,
		VEHICLE_MODULE_SLOT_UNIVERSAL = 3,
	)

	smoke_possible = 1
	zoom_possible = 1
	thrusters_possible = 1

	comp_armor = /obj/item/vehicle_component/plating/armor/military
	comp_hull = /obj/item/vehicle_component/plating/hull/durable

	icon_scale_x = 1.5
	icon_scale_y = 1.5

//To be kill ltr
/obj/vehicle/sealed/mecha/combat/marauder/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];toggle_thrusters=1'>Toggle thrusters</a><br>
						<a href='?src=\ref[src];toggle_zoom=1'>Toggle zoom mode</a><br>
						<a href='?src=\ref[src];smoke=1'>Smoke</a>
						</div>
						</div>
						"}
	output += ..()
	return output

//Meant for random spawns.
/obj/vehicle/sealed/mecha/combat/marauder/old
	desc = "Heavy-duty, combat exosuit, developed after the Durand model. Rarely found among civilian populations. This one is particularly worn looking and likely isn't as sturdy."

/obj/vehicle/sealed/mecha/combat/marauder/old/Initialize(mapload)
	. = ..()
	integrity = 25
	integrity_max = 300	//Just slightly worse.
	cell.charge = rand(0, (cell.charge/2))

/obj/vehicle/sealed/mecha/combat/marauder/equipped
	modules = list(
		/obj/item/vehicle_module/legacy/weapon/energy/pulse,
		/obj/item/vehicle_module/legacy/weapon/ballistic/missile_rack/explosive,
		/obj/item/vehicle_module/legacy/tesla_energy_relay,
		/obj/item/vehicle_module/personal_shield/structural_field/hyperkinetic,
	)

/obj/vehicle/sealed/mecha/combat/marauder/seraph
	desc = "Heavy-duty, command-type exosuit. This is a custom model, utilized only by high-ranking military personnel."
	name = "Seraph"
	catalogue_data = list(/datum/category_item/catalogue/technology/seraph)
	icon_state = "seraph"
	initial_icon = "seraph"
	operation_req_access = list(ACCESS_CENTCOM_ERT_LEAD)
	step_in = 3
	integrity = 450
	wreckage = /obj/effect/decal/mecha_wreckage/seraph
	internal_damage_threshold = 20
	force = 55

/obj/vehicle/sealed/mecha/combat/marauder/seraph/equipped
	modules = list(
		/obj/item/vehicle_module/legacy/weapon/ballistic/scattershot,
		/obj/item/vehicle_module/legacy/weapon/ballistic/missile_rack/explosive,
		/obj/item/vehicle_module/legacy/tesla_energy_relay,
		/obj/item/vehicle_module/personal_shield/structural_field/hyperkinetic,
		/obj/item/vehicle_module/legacy/teleporter,
	)

//Note that is the Mauler
/obj/vehicle/sealed/mecha/combat/marauder/mauler
	desc = "A stolen heavy-duty combat exosuit, developed off of the existing Marauder model."
	name = "Mauler"
	icon_state = "mauler"
	initial_icon = "mauler"
	operation_req_access = list(ACCESS_FACTION_SYNDICATE)
	wreckage = /obj/effect/decal/mecha_wreckage/mauler
	mech_faction = MECH_FACTION_SYNDI
