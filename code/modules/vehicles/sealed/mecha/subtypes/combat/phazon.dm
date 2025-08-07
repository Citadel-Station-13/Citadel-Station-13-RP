/obj/vehicle/sealed/mecha/combat/phazon
	name = "Phazon"
	desc = "A sleek exosuit with unnaturally pronounced curves."
	icon_state = "phazon"
	initial_icon = "phazon"
	step_in = 1
	dir_in = 1 //Facing North.
	step_energy_drain = 3
	integrity = 200		//God this is low
	integrity_max = 200		//Don't forget to update the /old variant if  you change this number.
	deflect_chance = 30
	damage_absorption = list("brute"=0.7,"fire"=0.7,"bullet"=0.7,"laser"=0.7,"energy"=0.7,"bomb"=0.7)
	max_temperature = 25000
	infra_luminosity = 3
	wreckage = /obj/effect/decal/mecha_wreckage/phazon
	add_req_access = 1
	//operation_req_access = list()
	internal_damage_threshold = 25
	force = 15
	max_equip = 4

	max_hull_equip = 3
	max_weapon_equip = 3
	max_utility_equip = 3
	max_universal_equip = 3
	max_special_equip = 4

	encumbrance_gap = 2

	starting_components = list(
		/obj/item/vehicle_component/hull/durable,
		/obj/item/vehicle_component/actuator,
		/obj/item/vehicle_component/armor/alien,
		/obj/item/vehicle_component/gas,
		/obj/item/vehicle_component/electrical
		)

	cloak_possible = TRUE
	phasing_possible = TRUE
	switch_dmg_type_possible = TRUE

/obj/vehicle/sealed/mecha/combat/phazon/equipped/Initialize(mapload)
	. = ..()
	starting_equipment = list(
		/obj/item/vehicle_module/tool/rcd,
		/obj/item/vehicle_module/gravcatapult
		)
	return

/* Leaving this until we are really sure we don't need it for reference.
/obj/vehicle/sealed/mecha/combat/phazon/Bump(var/atom/obstacle)
	if(phasing && get_charge()>=phasing_energy_drain)
		spawn()
			if(can_phase)
				can_phase = FALSE
				flick("[initial_icon]-phase", src)
				src.loc = get_step(src,src.dir)
				src.use_power(phasing_energy_drain)
				sleep(step_in*3)
				can_phase = TRUE
	else
		. = ..()
	return
*/


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
