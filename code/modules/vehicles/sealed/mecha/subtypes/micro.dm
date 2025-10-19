/obj/vehicle/sealed/mecha/micro
	icon = 'icons/mecha/micro.dmi'
	force = 10 //still a robot
	anchored = 0 //light enough to push and pull, but you still can't just walk past them. Like people on non-help.
	opacity = 0 //small enough to see around, like people.
	step_energy_drain = 2 // They're light and small. A compact is gonna get better MPG than a truck.
	module_classes_allowed = VEHICLE_MODULE_CLASS_MICRO
	internal_damage_threshold = 50
	maint_access = 0

	damage_absorption = list("brute"=1,"fire"=1,"bullet"=1,"laser"=1,"energy"=1,"bomb"=1)
	damage_minimum = 0				//Incoming damage lower than this won't actually deal damage. Scrapes shouldn't be a real thing.
	minimum_penetration = 0		//Incoming damage won't be fully applied if you don't have at least 20. Almost all AP clears this.

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

