/obj/vehicle/sealed/mecha/working/ripley
	name = "APLU \"Ripley\""
	desc = "Armored Power Loader Unit. The workhorse of the exosuit world."
	description_fluff = "The Armored Power Loader Unit, more commonly referred to as the 'Ripley', is a tried and tested exosuit model. Often described as the workhorse of the Frontier, the Ripley was originally designed for industrial use. The APLU is a second generation improvement of the original PLU. The APLU possesses a fully enclosed cockpit enabling it to work in vacuum. The APLU retains the PLU's rugged design and resilience, and is frequently employed in mining, construction, and cargo transport capacities. Coming in at just under 9'(2.7m) tall, the APLU cockpit is cramped, requiring its pilot to stand upright and move in conjunction with the exosuit."
	icon_state = "ripley"
	initial_icon = "ripley"
	base_movement_speed = 2.75
	max_temperature = 20000
	integrity = 200
	integrity_max = 200		//Don't forget to update the /old variant if  you change this number.
	wreckage = /obj/effect/decal/mecha_wreckage/ripley
	cargo_capacity = 10

	icon_scale_x = 1.2
	icon_scale_y = 1.2

	comp_hull = /obj/item/vehicle_component/plating/hull/durable
	comp_armor = /obj/item/vehicle_component/plating/armor/mining

	modules_intrinsic = list(
		/obj/item/vehicle_module/lazy/legacy/tool/orescanner,
	)

/obj/effect/decal/mecha_wreckage/ripley
	name = "Ripley wreckage"
	icon_state = "ripley-broken"

/obj/effect/decal/mecha_wreckage/ripley/New()
	..()
	var/list/parts = list(
		/obj/item/vehicle_part/ripley_torso,
		/obj/item/vehicle_part/ripley_left_arm,
		/obj/item/vehicle_part/ripley_right_arm,
		/obj/item/vehicle_part/ripley_left_leg,
		/obj/item/vehicle_part/ripley_right_leg,
	)
	for(var/i=0;i<2;i++)
		if(!!length(parts) && prob(40))
			var/part = pick(parts)
			welder_salvage += part
			parts -= part

//! misc subtypes !//

/obj/vehicle/sealed/mecha/working/ripley/mining
	desc = "An old, dusty mining ripley."
	name = "APLU \"Miner\""

/obj/vehicle/sealed/mecha/working/ripley/mining/Initialize(mapload)
	LAZYINITLIST(modules)
	if(prob(25))
		modules += /obj/item/vehicle_module/lazy/legacy/tool/drill/diamonddrill
	else
		modules += /obj/item/vehicle_module/lazy/legacy/tool/drill
	modules += /obj/item/vehicle_module/lazy/legacy/tool/hydraulic_clamp
	return ..()

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
