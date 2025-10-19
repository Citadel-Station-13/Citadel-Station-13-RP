/obj/vehicle/sealed/mecha/working
	internal_damage_threshold = 60

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 0,
		VEHICLE_MODULE_SLOT_HULL = 2,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
		VEHICLE_MODULE_SLOT_UTILITY = 4,
		VEHICLE_MODULE_SLOT_UNIVERSAL = 2,
	)

/obj/vehicle/sealed/mecha/working/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	if(isPlayerLevel(T.z))
		new /obj/item/vehicle_tracking_beacon(src)

/obj/vehicle/sealed/mecha/working/range_action(atom/target as obj|mob|turf)
	return
