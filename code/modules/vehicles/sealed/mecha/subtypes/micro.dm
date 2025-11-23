/obj/vehicle/sealed/mecha/micro
	icon = 'icons/mecha/micro.dmi'
	force = 10 //still a robot
	anchored = 0 //light enough to push and pull, but you still can't just walk past them. Like people on non-help.
	opacity = 0 //small enough to see around, like people.
	internal_damage_threshold = 50

	integrity = 0.75 * /obj/vehicle/sealed/mecha::integrity
	integrity_max = 0.75 * /obj/vehicle/sealed/mecha::integrity_max
	comp_armor_relative_thickness = 0.2 * /obj/vehicle/sealed/mecha::comp_armor_relative_thickness
	comp_hull_relative_thickness = 0.2 * /obj/vehicle/sealed/mecha::comp_hull_relative_thickness

	module_slots = list(
		VEHICLE_MODULE_SLOT_WEAPON = 1,
		VEHICLE_MODULE_SLOT_SPECIAL = 1,
		VEHICLE_MODULE_SLOT_HULL = 2,
		VEHICLE_MODULE_SLOT_UTILITY = 4,
	)
	module_classes_allowed = VEHICLE_MODULE_CLASS_MICRO

	var/size_requirement = 0.7

// override move_inside() so only micro crew can use them

/obj/vehicle/sealed/mecha/micro/mob_can_enter(mob/entering, datum/event_args/actor/actor, silent, suppressed)
	var/mob/living/carbon/C = entering
	if (C.size_multiplier > size_requirement)
		to_chat(C, "<span class='warning'>You can't fit in this suit!</span>")
		return FALSE
	else
		return ..()

/obj/vehicle/sealed/mecha/micro/move_inside_passenger()
	var/mob/living/carbon/C = usr
	if (C.size_multiplier > size_requirement)
		to_chat(C, "<span class='warning'>You can't fit in this suit!</span>")
		return
	else
		..()

// override move/turn procs so they play more appropriate sounds. Placeholder sounds for now, but mechmove04 at least sounds like tracks for the poleat.

/obj/vehicle/sealed/mecha/micro/mechturn(direction)
	setDir(direction)
	playsound(src,'sound/mecha/mechmove03.ogg',40,1)
	return 1

/obj/vehicle/sealed/mecha/micro/mechstep(direction)
	var/result = step(src,direction)
	if(result)
		playsound(src,'sound/mecha/mechmove04.ogg',40,1)
	return result

/obj/vehicle/sealed/mecha/micro/mechsteprand()
	var/result = step_rand(src)
	if(result)
		playsound(src,'sound/mecha/mechmove04.ogg',40,1)
	return result

/obj/effect/decal/mecha_wreckage/micro
	icon = 'icons/mecha/micro.dmi'

