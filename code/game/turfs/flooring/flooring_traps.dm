//This is an experimental turf type that functions as a step-trigger for traps. I'm starting this project without any idea what I'm actually doing here.

/turf/simulated/floor/trap
	name = "suspicious flooring"
	icon = 'icons/turf/flooring/trap.dmi'
	icon_state = "steel_dirty"
	var/tripped = FALSE
	var/message = "trip"
	var/id = "trap_debug_controller"

/turf/simulated/floor/trap/Entered(atom/A)
	if(isliving(A) && !tripped)
		var/mob/living/L = A
		if(L.hovering) // Flying things shouldn't trigger pressure plates.
			return ..()
		trigger()
	else
		return

/turf/simulated/floor/trap/proc/trigger()
	tripped = TRUE
	visible_message("<span class='danger'>You hear a click nearby!</span>")
	update_icon()
	playsound(src, 'sound/machines/click.ogg', 50, 1)
	SimpleNetworkSend(id, "trip")
	return

/turf/simulated/floor/trap/update_icon()
	if(!tripped)
		icon_state = "[initial(icon_state)]"
	else if (tripped)
		icon_state = "[initial(icon_state)]_tripped"

/turf/simulated/floor/trap/attack_hand()
	if(tripped)
		to_chat(usr, "<span class='notice'>You reset the triggered mechanism.</span>")
		tripped = 0
		update_icon()
	else if(!tripped)
		to_chat(usr, "<span class='danger'>You trigger the hidden mechanism!</span>")
		trigger()

/turf/simulated/floor/trap/delayed
	name = "suspicious flooring"
	var/delay = 5

/turf/simulated/floor/trap/delayed/trigger()
	spawn(src.delay)
		tripped = TRUE
		visible_message("<span class='danger'>You hear a click nearby!</span>")
		update_icon()
		playsound(src, 'sound/machines/click.ogg', 50, 1)
		SimpleNetworkSend(id, "trip")
		return

//Types
/turf/simulated/floor/trap/plating
	icon_state = "plating"

/turf/simulated/floor/trap/steel
	icon_state = "steel"

/turf/simulated/floor/trap/dark
	icon_state = "dark"

/turf/simulated/floor/trap/white
	icon_state = "white"

/turf/simulated/floor/trap/freezer
	icon_state = "freezer"

/turf/simulated/floor/trap/steel_grid
	icon_state = "steel_grid"

/turf/simulated/floor/trap/techmaint
	icon_state = "techmaint"

/turf/simulated/floor/trap/asteroidfloor
	icon_state = "asteroidfloor"

/turf/simulated/floor/trap/crystal
	icon_state = "crystal"

/turf/simulated/floor/trap/cult
	icon_state = "cult"

/turf/simulated/floor/trap/wmarble
	icon_state = "lightmarble"

/turf/simulated/floor/trap/bmarble
	icon_state = "darkmarble"

/turf/simulated/floor/trap/silver
	icon_state = "silver"

/turf/simulated/floor/trap/gold
	icon_state = "gold"

/turf/simulated/floor/trap/phoron
	icon_state = "phoron"

/turf/simulated/floor/trap/uranium
	icon_state = "uranium"

/turf/simulated/floor/trap/diamond
	icon_state = "diamond"

/turf/simulated/floor/trap/wood
	icon_state = "wood"

/turf/simulated/floor/trap/sifwood
	icon_state = "sifwood"

//Delayed
/turf/simulated/floor/trap/delayed/plating
	icon_state = "plating"

/turf/simulated/floor/trap/delayed/steel
	icon_state = "steel"

/turf/simulated/floor/trap/delayed/dark
	icon_state = "dark"

/turf/simulated/floor/trap/delayed/white
	icon_state = "white"

/turf/simulated/floor/trap/delayed/freezer
	icon_state = "freezer"

/turf/simulated/floor/trap/delayed/steel_grid
	icon_state = "steel_grid"

/turf/simulated/floor/trap/delayed/techmaint
	icon_state = "techmaint"

/turf/simulated/floor/trap/delayed/asteroidfloor
	icon_state = "asteroidfloor"

/turf/simulated/floor/trap/delayed/crystal
	icon_state = "crystal"

/turf/simulated/floor/trap/delayed/cult
	icon_state = "cult"

/turf/simulated/floor/trap/delayed/wmarble
	icon_state = "lightmarble"

/turf/simulated/floor/trap/delayed/bmarble
	icon_state = "darkmarble"

/turf/simulated/floor/trap/delayed/silver
	icon_state = "silver"

/turf/simulated/floor/trap/delayed/gold
	icon_state = "gold"

/turf/simulated/floor/trap/delayed/uranium
	icon_state = "uranium"

/turf/simulated/floor/trap/delayed/phoron
	icon_state = "phoron"

/turf/simulated/floor/trap/delayed/diamond
	icon_state = "diamond"

/turf/simulated/floor/trap/delayed/wood
	icon_state = "wood"

/turf/simulated/floor/trap/delayed/sifwood
	icon_state = "sifwood"

//Lavaland Subtypes
/turf/simulated/floor/trap/lavaland
	initial_gas_mix = ATMOSPHERE_ID_LAVALAND

/turf/simulated/floor/trap/plating/lavaland
	initial_gas_mix = ATMOSPHERE_ID_LAVALAND

/turf/simulated/floor/trap/steel/lavaland
	initial_gas_mix = ATMOSPHERE_ID_LAVALAND

/turf/simulated/floor/trap/wood/lavaland
	initial_gas_mix = ATMOSPHERE_ID_LAVALAND

/turf/simulated/floor/trap/delayed/lavaland
	initial_gas_mix = ATMOSPHERE_ID_LAVALAND

/turf/simulated/floor/trap/delayed/steel/lavaland
	initial_gas_mix = ATMOSPHERE_ID_LAVALAND

/turf/simulated/floor/trap/delayed/plating/lavaland
	initial_gas_mix = ATMOSPHERE_ID_LAVALAND

/turf/simulated/floor/trap/delayed/wood/lavaland
	initial_gas_mix = ATMOSPHERE_ID_LAVALAND


/*

/turf/simulated/floor/trap/attack_by()

Get dir for plank placement

*/
