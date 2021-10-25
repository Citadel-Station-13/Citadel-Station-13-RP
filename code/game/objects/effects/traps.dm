//Place traps here. Crossbow trap as basis?

/obj/effect/trap
	name = "strange area"
	desc = "The dust hangs strangely in the air here."
	icon = 'icons/turf/flooring/trap.dmi'
	icon_state = "trap_frame"
	anchored = 1 //About time someone fixed this.
	density = 0
	//invisibility = INVISIBILITY_MAXIMUM  - Commented this invis variant out due to balancing issues/its blocking of warning text and effect icons.
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/trap_floor_type = /turf/simulated/floor/water/acid
	var/tripped = FALSE
	var/id = "trap_debug_controller"

/obj/effect/trap/Initialize()
	. = ..()
	RegisterSimpleNetwork(id)

/obj/effect/trap/SimpleNetworkReceive(id, message, list/data, datum/sender)
	. = ..()
	trip()

/obj/effect/trap/proc/trip()
	if(tripped)
		return
	if(!tripped)
		tripped = TRUE
		fire()

/obj/effect/trap/proc/fire()
	update_icon()
	visible_message("<span class='danger'>The floor crumbles away!</span>")
	playsound(src, 'sound/effects/slosh.ogg', 100, 1)
	var/turf/deploy_location = get_turf(src)
	deploy_location.ChangeTurf(trap_floor_type)

/obj/effect/trap/update_icon()
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
Spinning blade traps.
Etc.
*/
