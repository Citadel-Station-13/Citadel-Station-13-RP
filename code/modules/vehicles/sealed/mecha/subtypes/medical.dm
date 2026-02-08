/obj/vehicle/sealed/mecha/medical
	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 0,
		VEHICLE_MODULE_SLOT_HULL = 2,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
		VEHICLE_MODULE_SLOT_UTILITY = 4,
	)

	move_sound = 'sound/mecha/mechmove01.ogg'

	cargo_capacity = 1

	comp_armor = /obj/item/vehicle_component/plating/mecha_armor/lightweight

/obj/vehicle/sealed/mecha/medical/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	if(isPlayerLevel(T.z))
		new /obj/item/vehicle_tracking_beacon(src)
