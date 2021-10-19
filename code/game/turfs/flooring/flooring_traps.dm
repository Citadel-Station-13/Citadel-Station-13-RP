//This is an experimental turf type that functions as a step-trigger for traps. I'm starting this project without any idea what I'm actually doing here.

/turf/simulated/floor/trap
	name = "suspicious flooring"
	icon = 'icons/turf/flooring/trap.dmi'
	icon_state = "steel_dirty"
	var/frequency = 0
	var/tripped = 0


/turf/simulated/floor/trap/Entered(atom/A)
	if(isliving(A) && tripped == 0)
		var/mob/living/L = A
		if(L.hovering) // Flying things shouldn't trigger pressure plates.
			return ..()
		playsound(src, 'sound/machines/click.ogg', 50, 1)
		trigger()
	else
		return

/turf/simulated/floor/trap/proc/trigger(atom/A)
	tripped = 1
	to_chat(usr, "<span class='danger'>The floor shifts below you!</span>")
	update_icon()
	return

/turf/simulated/floor/trap/update_icon()
	if(tripped == 0)
		icon_state = "[initial(icon_state)]"
	else if (tripped == 1)
		icon_state = "[initial(icon_state)]_tripped"

/turf/simulated/floor/trap/attack_hand()
	if(tripped == 1)
		to_chat(usr, "<span class='notice'>You reset the triggered mechanism.</span>")
		tripped = 0
		update_icon()
	else if(tripped == 0)
		to_chat(usr, "<span class='danger'>You trigger the hidden mechanism!</span>")
		tripped = 1
		update_icon()

/*
/turf/simulated/floor/trap/attack_by()
*/

/*
//I guess the baseline trap will be a pitfall? Seems like a classic. Needs a lot of work.
/turf/simulated/floor/trap/proc/Trigger(atom/A)
	if(isliving(A))
		var/mob/living/L = A
		if(L.hovering) // Flying people are immune to falling down holes, generally.
			return ..()
		tripped = 1
		break_legs()
		update_icon()
	..()

/turf/simulated/floor/trap/proc/break_legs(mob/victim as mob)
	var/broken_legs = 0
	var/mob/living/carbon/human/target = victim
	var/obj/item/organ/external/left_leg = target.get_organ(BP_L_LEG)
	if(left_leg && left_leg.fracture())
		broken_legs++
	var/obj/item/organ/external/right_leg = target.get_organ(BP_R_LEG)
	if(right_leg && right_leg.fracture())
		broken_legs++
	if(!broken_legs)
		return ..()

Make an attack_by for planks that boards over and makes the trap safe.
Same for tiles to reset it.
*/
