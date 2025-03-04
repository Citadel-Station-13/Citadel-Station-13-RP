/obj/vehicle/sealed/mecha/working
	internal_damage_threshold = 60
	max_hull_equip = 1
	max_weapon_equip = 0
	max_utility_equip = 3
	max_universal_equip = 1
	max_special_equip = 1

/obj/vehicle/sealed/mecha/working/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	if(isPlayerLevel(T.z))
		new /obj/item/vehicle_tracking_beacon(src)

/obj/vehicle/sealed/mecha/working/range_action(atom/target as obj|mob|turf)
	return
