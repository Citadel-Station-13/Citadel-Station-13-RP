//Place traps here. Crossbow trap as basis?

obj/machinery/trap
	name = "strange area"
	desc = "The dust hangs strangely in the air here."
	icon = 'icons/turf/flooring/trap.dmi'
	icon_state = "trap_frame"
	anchored = 1 //About time someone fixed this.
	density = 0
	var/trap_floor_type = /turf/simulated/floor/water/acid
	var/tripped = FALSE

obj/machinery/trap/proc/trip()
	if(tripped)
		return
	if(!tripped)
		tripped = TRUE
		fire()

obj/machinery/trap/proc/fire()
	update_icon()
	visible_message("<span class='danger'>The floor crumbles away!</span>")
	playsound(src, 'sound/effects/slosh.ogg', 100, 1)
	var/turf/deploy_location = get_turf(src)
	deploy_location.ChangeTurf(trap_floor_type)

obj/machinery/trap/update_icon()
	if(!tripped)
		icon_state = "[initial(icon_state)]"
	else if (tripped)
		icon_state = "[initial(icon_state)]_visible"

/*
Ideas:
Punji trap that does brute to feet.
Knee breaking trap.
Classic pitfall trap (teleports?)
Crossbow shooting wall trap.
Etc.
*/
