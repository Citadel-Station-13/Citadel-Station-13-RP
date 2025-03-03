/obj/vehicle/sealed/mecha/working/ripley
	desc = "Armored Power Loader Unit. The workhorse of the exosuit world."
	name = "APLU \"Ripley\""
	icon_state = "ripley"
	initial_icon = "ripley"
	step_in = 5
	step_energy_drain = 5
	max_temperature = 20000
	integrity = 200
	integrity_max = 200		//Don't forget to update the /old variant if  you change this number.
	wreckage = /obj/effect/decal/mecha_wreckage/ripley
	cargo_capacity = 10
	var/obj/item/mining_scanner/orescanner

	minimum_penetration = 10

	encumbrance_gap = 2

	starting_components = list(
		/obj/item/vehicle_component/hull/durable,
		/obj/item/vehicle_component/actuator,
		/obj/item/vehicle_component/armor/mining,
		/obj/item/vehicle_component/gas,
		/obj/item/vehicle_component/electrical
		)

	icon_scale_x = 1.2
	icon_scale_y = 1.2

/obj/vehicle/sealed/mecha/working/ripley/Initialize(mapload)
	. = ..()
	orescanner = new /obj/item/mining_scanner

/obj/vehicle/sealed/mecha/working/ripley/verb/detect_ore()
	set category = "Exosuit Interface"
	set name = "Detect Ores"
	set src = usr.loc
	set popup_menu = 0

	orescanner.attack_self(usr)

//! misc subtypes !//

/obj/vehicle/sealed/mecha/working/ripley/deathripley
	desc = "OH SHIT IT'S THE DEATHSQUAD WE'RE ALL GONNA DIE"
	name = "DEATH-RIPLEY"
	icon_state = "deathripley"
	initial_icon = "deathripley"
	step_in = 2
	opacity=0
	lights_power = 60
	wreckage = /obj/effect/decal/mecha_wreckage/ripley/deathripley
	step_energy_drain = 0
	max_hull_equip = 1
	max_weapon_equip = 1
	max_utility_equip = 3
	max_universal_equip = 1
	max_special_equip = 1

/obj/vehicle/sealed/mecha/working/ripley/deathripley/Initialize(mapload)
	. = ..()
	var/obj/item/vehicle_module/ME = new /obj/item/vehicle_module/tool/hydraulic_clamp/safety
	ME.attach(src)
	return

/obj/vehicle/sealed/mecha/working/ripley/mining
	desc = "An old, dusty mining ripley."
	name = "APLU \"Miner\""

/obj/vehicle/sealed/mecha/working/ripley/mining/Initialize(mapload)
	. = ..()
	//Attach drill
	if(prob(25)) //Possible diamond drill... Feeling lucky?
		var/obj/item/vehicle_module/tool/drill/diamonddrill/D = new /obj/item/vehicle_module/tool/drill/diamonddrill
		D.attach(src)
	else
		var/obj/item/vehicle_module/tool/drill/D = new /obj/item/vehicle_module/tool/drill
		D.attach(src)

	//Attach hydrolic clamp
	var/obj/item/vehicle_module/tool/hydraulic_clamp/HC = new /obj/item/vehicle_module/tool/hydraulic_clamp
	HC.attach(src)
	for(var/obj/item/vehicle_tracking_beacon/B in src.contents)//Deletes the beacon so it can't be found easily
		qdel (B)

//Meant for random spawns.
/obj/vehicle/sealed/mecha/working/ripley/mining/old
	desc = "An old, dusty mining ripley."

/obj/vehicle/sealed/mecha/working/ripley/mining/old/Initialize(mapload)
	. = ..()
	integrity = 25
	integrity_max = 190	//Just slightly worse.
	cell.charge = rand(0, cell.charge)

/// Moved here from underdark_things.dm (cleaning up files)
//Mechbay
/obj/vehicle/sealed/mecha/working/ripley/abandoned/Initialize(mapload)
	. = ..()
	for(var/obj/item/vehicle_tracking_beacon/B in src.contents)	//Deletes the beacon so it can't be found easily
		qdel(B)
