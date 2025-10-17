/obj/vehicle/sealed/mecha/medical
	max_hull_equip = 1
	max_weapon_equip = 0
	max_utility_equip = 2
	max_universal_equip = 1
	max_special_equip = 1

	stomp_sound = 'sound/mecha/mechmove01.ogg'

	cargo_capacity = 1

	comp_armor = /obj/item/vehicle_component/armor/lightweight

/obj/vehicle/sealed/mecha/medical/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	if(isPlayerLevel(T.z))
		new /obj/item/vehicle_tracking_beacon(src)
