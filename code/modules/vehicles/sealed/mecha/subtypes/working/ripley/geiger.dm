/obj/vehicle/sealed/mecha/working/ripley/geiger
	name = "APLU \"Geiger\""
	desc = "You can't beat the classics."
	icon_state = "ripley-old"
	initial_icon = "ripley-old"
	max_temperature = 5000
	integrity = 150
	integrity_max = 150
	internal_damage_threshold = 50

	show_pilot = TRUE
	pilot_lift = 5

	icon_scale_x = 1
	icon_scale_y = 1

/obj/effect/decal/mecha_wreckage/ripley/geiger
	name = "Lightweight APLU wreckage"
	icon_state = "ripley-broken-old"

/obj/effect/decal/mecha_wreckage/ripley/geiger/New()
	..()
	var/list/parts = list(
		/obj/item/vehicle_part/geiger_torso,
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
