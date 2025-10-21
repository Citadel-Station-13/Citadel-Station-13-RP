/obj/vehicle/sealed/mecha/combat/phazon
	name = "Phazon"
	desc = "A sleek exosuit with unnaturally pronounced curves."
	icon_state = "phazon"
	initial_icon = "phazon"

	base_movement_speed = 5
	comp_armor = /obj/item/vehicle_component/plating/armor/alien
	comp_hull = /obj/item/vehicle_component/plating/hull/durable

	dir_in = 1 //Facing North.
	step_energy_drain = 3
	integrity = 200		//God this is low
	integrity_max = 200		//Don't forget to update the /old variant if  you change this number.
	deflect_chance = 30
	damage_absorption = list("brute"=0.7,"fire"=0.7,"bullet"=0.7,"laser"=0.7,"energy"=0.7,"bomb"=0.7)
	max_temperature = 25000
	wreckage = /obj/effect/decal/mecha_wreckage/phazon
	add_req_access = 1
	//operation_req_access = list()
	internal_damage_threshold = 25
	force = 15
	max_equip = 4

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 3,
		VEHICLE_MODULE_SLOT_HULL = 3,
		VEHICLE_MODULE_SLOT_SPECIAL = 3,
		VEHICLE_MODULE_SLOT_UTILITY = 6,
		VEHICLE_MODULE_SLOT_UNIVERSAL = 5,
	)

	encumbrance_gap = 2

	cloak_possible = TRUE
	phasing_possible = TRUE
	switch_dmg_type_possible = TRUE

/obj/vehicle/sealed/mecha/combat/phazon/equipped
	modules = list(
		/obj/item/vehicle_module/legacy/tool/rcd,
		/obj/item/vehicle_module/legacy/gravcatapult,
	)

/obj/vehicle/sealed/mecha/combat/phazon/get_commands()
	var/output = {"<div class='wr'>
						<div class='header'>Special</div>
						<div class='links'>
						<a href='?src=\ref[src];phasing=1'><span id="phasing_command">[phasing?"Dis":"En"]able phasing</span></a><br>
						<a href='?src=\ref[src];switch_damtype=1'>Change melee damage type</a><br>
						</div>
						</div>
						"}
	output += ..()
	return output

//Meant for random spawns.
/obj/vehicle/sealed/mecha/combat/phazon/old
	desc = "An exosuit which can only be described as 'WTF?'. This one is particularly worn looking and likely isn't as sturdy."

/obj/vehicle/sealed/mecha/combat/phazon/old/Initialize(mapload)
	. = ..()
	integrity = 25
	integrity_max = 150	//Just slightly worse.
	cell.charge = rand(0, (cell.charge/2))
