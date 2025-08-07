/obj/vehicle/sealed/mecha/medical
	max_hull_equip = 1
	max_weapon_equip = 0
	max_utility_equip = 2
	max_universal_equip = 1
	max_special_equip = 1

	stomp_sound = 'sound/mecha/mechmove01.ogg'

	cargo_capacity = 1

	starting_components = list(
		/obj/item/vehicle_component/hull,
		/obj/item/vehicle_component/actuator,
		/obj/item/vehicle_component/armor/lightweight,
		/obj/item/vehicle_component/gas,
		/obj/item/vehicle_component/electrical
		)

/obj/vehicle/sealed/mecha/medical/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	if(isPlayerLevel(T.z))
		new /obj/item/vehicle_tracking_beacon(src)

/*	// One horrific bastardization of glorious inheritence dead. A billion to go. ~Mech
/obj/vehicle/sealed/mecha/medical/mechturn(direction)
	setDir(direction)
	playsound(src,'sound/mecha/mechmove01.ogg',40,1)
	return 1

/obj/vehicle/sealed/mecha/medical/mechstep(direction)
	var/result = step(src,direction)
	if(result)
		playsound(src,'sound/mecha/mechstep.ogg',25,1)
	return result

/obj/vehicle/sealed/mecha/medical/mechsteprand()
	var/result = step_rand(src)
	if(result)
		playsound(src,'sound/mecha/mechstep.ogg',25,1)
	return result
*/
