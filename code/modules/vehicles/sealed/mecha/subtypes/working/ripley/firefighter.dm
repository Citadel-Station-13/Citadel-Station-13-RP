/obj/vehicle/sealed/mecha/working/ripley/firefighter
	desc = "Standard APLU chassis was refitted with additional thermal protection and cistern."
	name = "APLU \"Firefighter\""
	icon_state = "firefighter"
	initial_icon = "firefighter"
	max_temperature = 65000
	integrity = 1.35 * /obj/vehicle/sealed/mecha/working/ripley::integrity
	integrity_max = 1.35 * /obj/vehicle/sealed/mecha/working/ripley::integrity_max
	floodlight_range = 8
	wreckage = /obj/effect/decal/mecha_wreckage/ripley/firefighter

/obj/effect/decal/mecha_wreckage/ripley/firefighter
	name = "Firefighter wreckage"
	icon_state = "firefighter-broken"

/obj/effect/decal/mecha_wreckage/ripley/firefighter/New()
	..()
	var/list/parts = list(
		/obj/item/vehicle_part/ripley_torso,
		/obj/item/vehicle_part/ripley_left_arm,
		/obj/item/vehicle_part/ripley_right_arm,
		/obj/item/vehicle_part/ripley_left_leg,
		/obj/item/vehicle_part/ripley_right_leg,
		/obj/item/clothing/suit/fire,
	)
	for(var/i=0;i<2;i++)
		if(!!length(parts) && prob(40))
			var/part = pick(parts)
			welder_salvage += part
			parts -= part
