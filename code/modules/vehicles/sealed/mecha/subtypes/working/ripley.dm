/obj/vehicle/sealed/mecha/working/ripley
	desc = "Armored Power Loader Unit. The workhorse of the exosuit world."
	name = "APLU \"Ripley\""
	icon_state = "ripley"
	initial_icon = "ripley"
	base_movement_speed = 2.75
	step_energy_drain = 5
	max_temperature = 20000
	integrity = 200
	integrity_max = 200		//Don't forget to update the /old variant if  you change this number.
	wreckage = /obj/effect/decal/mecha_wreckage/ripley
	cargo_capacity = 10

	encumbrance_gap = 2

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
