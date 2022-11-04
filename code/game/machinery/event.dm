/*
These machines are designed for event usage as constructable objectives.
They serve no purpose (currently), as that is beyond the scope of my intent in designing them.
The goal here is to create esoteric or niche, specialized machines that follow the standard construction process, but produce a functionally useless machine.
*/

/*
//Colony Event Items
- Magma Pump
- Magma Reservoir
*/

//Magma Pump Actual

/obj/machinery/magma_pump
	name = "magma pump"
	desc = "This advanced pump draws magma from subterranean reservoirs and diverts it. Its extremely hardy materials make it difficult to disrupt, once in action."
	icon = 'icons/obj/machines/event.dmi'
	icon_state = "pump"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 1
	active_power_usage = 5
	var/on = FALSE

/obj/machinery/magma_pump/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/stock_parts/capacitor/hyper(src)
	component_parts += new /obj/item/stock_parts/capacitor/hyper(src)
	component_parts += new /obj/item/stock_parts/scanning_module/hyper(src)
	component_parts += new /obj/item/stock_parts/motor(src)
	component_parts += new /obj/item/stock_parts/motor(src)
	component_parts += new /obj/item/stock_parts/motor(src)
	component_parts += new /obj/item/stock_parts/motor(src)
	component_parts += new /obj/item/stock_parts/motor(src)
	component_parts += new /obj/item/stock_parts/gear(src)
	component_parts += new /obj/item/stock_parts/gear(src)
	component_parts += new /obj/item/stock_parts/gear(src)
	component_parts += new /obj/item/stock_parts/gear(src)
	component_parts += new /obj/item/stock_parts/gear(src)
	component_parts += new /obj/item/stock_parts/console_screen(src)
	component_parts += new /obj/item/stack/material/glass/phoronrglass (src, 2)
	component_parts += new /obj/item/stack/material/durasteel(src, 5)

	RefreshParts()

/obj/machinery/magma_pump/legacy_ex_act(severity)
	switch(severity)
		if(1)
			//SN src = null
			qdel(src)
			return
		if(2)
			if(prob(50))
				//SN src = null
				qdel(src)
				new /obj/structure/broken_pump(src)
				return
		if(3)
			if(prob(25))
				qdel(src)
				new /obj/structure/broken_pump(src)
		else
	return

/obj/machinery/magma_pump/attack_hand(mob/user)
	interact(user)

/obj/machinery/magma_pump/interact(mob/user)
	if(on)
		visible_message("You start closing the valves on \the [src].", "[usr] starts closing the valves on \the [src].")
		if(do_after(user, 15))
			on = FALSE
			user.visible_message( \
				SPAN_NOTICE("[user] closes the valves of \the [src]."), \
				SPAN_NOTICE("You close the valves of \the [src]."))
			update_icon()
	else
		visible_message( \
			SPAN_NOTICE("You start opening the valves on the \the [src]."), \
			SPAN_NOTICE("[usr] starts opening the valves on \the [src]."))

		if(do_after(user, 15))
			on = TRUE
			user.visible_message( \
				SPAN_NOTICE("[user] opens the valves of \the [src]."), \
				SPAN_NOTICE("You open the valves of \the [src]."))

			update_icon()
	return

/obj/machinery/magma_pump/update_icon()
	overlays.Cut()
	if(on)
		set_light(3, 3, "#FFCC00")
		src.icon_state = "[icon_state]_1"
	else
		set_light(0)
		src.icon_state = initial(icon_state)

/obj/structure/broken_pump
	name = "broken pump"
	desc = "This pump has been damaged by a devastating explosion. It is beyond salvaging, but it might be dismantled still."
	icon = 'icons/obj/machines/event.dmi'
	icon_state = "pump_broken"
	density = TRUE
	anchored = TRUE
	var/sliced = FALSE
	var/gutted = FALSE

/obj/structure/broken_pump/attackby(obj/item/I as obj, mob/user)
	if(istype(I, /obj/item/weldingtool) && !sliced)
		var/obj/item/weldingtool/W = I
		to_chat(user, SPAN_NOTICE("You begin cutting through the exterior plating of \the [src]."))
		if(do_after(user,30) || W.remove_fuel(5, user))
			playsound(src.loc, 'sound/items/Welder2.ogg', 50, TRUE)
			var/turf/T = get_turf(src)
			new /obj/item/stack/material/durasteel(T)
			sliced = TRUE
			update_icon()
		else
			return
	if(istype(I, /obj/item/tool/crowbar) && sliced)
		var/turf/T = get_turf(src)
		to_chat(user, SPAN_NOTICE("You begin prying out any salvageable components from \the [src]."))
		playsound(src.loc, 'sound/items/Crowbar.ogg', 50, TRUE)
		if(do_after(user, 30))
			switch(rand(1,10))
				if(1 to 2)
					new /obj/item/circuitboard/magma_pump(T)
				if(3 to 4)
					new /obj/item/stack/material/durasteel(T)
				if(5 to 7)
					new /obj/item/stack/material/steel(T)
				if(8 to 10)
					new /obj/item/stack/cable_coil(T)
			gutted = 1
			update_icon()
		else
			return
	if(istype(I, /obj/item/weldingtool) && gutted)
		var/obj/item/weldingtool/W = I
		to_chat(user, SPAN_NOTICE("You begin deconstructing the housing of \the [src]."))
		if(do_after(user,30) || W.remove_fuel(5, user))
			playsound(src.loc, 'sound/items/Welder2.ogg', 50, TRUE)
			var/turf/T = get_turf(src)
			new /obj/item/frame(T)
			qdel(src)
		else
			return

/obj/structure/broken_pump/update_icon()
	if(sliced)
		icon_state = "pump_sliced"
	if(gutted)
		icon_state = "pump_gutted"
	else
		icon_state = "pump_broken"

//Magma Reservoir Actual

/obj/machinery/magma_reservoir
	name = "magma pump"
	desc = "A hardy backflow reservoir where the pumps store magma and magma until it can be diverted. Its extremely hardy materials make it difficult to disrupt, once in action."
	icon = 'icons/obj/machines/event.dmi'
	icon_state = "reservoir"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 1
	active_power_usage = 5
	var/on = FALSE

/obj/machinery/magma_reservoir/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/stock_parts/capacitor/hyper(src)
	component_parts += new /obj/item/stock_parts/capacitor/hyper(src)
	component_parts += new /obj/item/stock_parts/scanning_module/hyper(src)
	component_parts += new /obj/item/stock_parts/matter_bin/hyper(src)
	component_parts += new /obj/item/stock_parts/matter_bin/hyper(src)
	component_parts += new /obj/item/stock_parts/matter_bin/hyper(src)
	component_parts += new /obj/item/stock_parts/matter_bin/hyper(src)
	component_parts += new /obj/item/stock_parts/matter_bin/hyper(src)
	component_parts += new /obj/item/stock_parts/motor(src)
	component_parts += new /obj/item/stock_parts/motor(src)
	component_parts += new /obj/item/stock_parts/console_screen(src)
	component_parts += new /obj/item/stack/material/glass/phoronrglass (src, 5)
	component_parts += new /obj/item/stack/material/durasteel(src, 5)

	RefreshParts()

/obj/machinery/magma_reservoir/legacy_ex_act(severity)
	switch(severity)
		if(1)
			//SN src = null
			qdel(src)
			return
		if(2)
			if(prob(50))
				//SN src = null
				qdel(src)
				new /obj/structure/broken_reservoir(src)
				return
		if(3)
			if(prob(25))
				qdel(src)
				new /obj/structure/broken_reservoir(src)
		else
	return

/obj/machinery/magma_reservoir/attack_hand(mob/user)
	interact(user)

/obj/machinery/magma_reservoir/interact(mob/user)
	if(on)
		visible_message( \
			SPAN_NOTICE("You start the draining sequence for \the [src].", \
			SPAN_NOTICE("[usr] starts the draining sequence for \the [src]."))

		if(do_after(user, 15))
			on = FALSE
			user.visible_message( \
				SPAN_NOTICE("[user] finishes the draining sequence for \the [src]."), \
				SPAN_NOTICE("You finish the draining sequence for \the [src]."))
			update_icon()
	else
		visible_message( \
			SPAN_NOTICE("You start the filling sequence for \the [src]."), \
			SPAN_NOTICE("[usr] starts the filling sequence for the [src]."))

		if(do_after(user, 15))
			on = TRUE
			user.visible_message(
				SPAN_NOTICE("[user] completes the fill sequence of \the [src]."), \
				SPAN_NOTICE("You complete the fill sequence of \the [src]."))
			update_icon()
	return

/obj/machinery/magma_reservoir/update_icon()
	overlays.Cut()
	if(on)
		set_light(3, 3, "#FFCC00")
		src.icon_state = "[icon_state]_1"
	else
		set_light(0)
		src.icon_state = initial(icon_state)

/obj/structure/broken_reservoir
	name = "broken reservoir"
	desc = "This reservoir has been shattered by a devastating explosion. It is beyond salvaging, but it might be dismantled still."
	icon = 'icons/obj/machines/event.dmi'
	icon_state = "reservoir_broken"
	density = TRUE
	anchored = TRUE
	var/sliced = FALSE
	var/gutted = FALSE

/obj/structure/broken_reservoir/attackby(obj/item/I as obj, mob/user)
	if(istype(I, /obj/item/weldingtool) && !sliced)
		var/obj/item/weldingtool/W = I
		to_chat(user, SPAN_NOTICE("You begin cutting through the thick glass of the [src]."))
		if(do_after(user,30) || W.remove_fuel(5, user))
			playsound(src.loc, 'sound/items/Welder2.ogg', 50, TRUE)
			var/turf/T = get_turf(src)
			new /obj/item/stack/material/glass/phoronrglass(T, 2)
			sliced = TRUE
			update_icon()
		else
			return
	if(istype(I, /obj/item/tool/crowbar) && sliced)
		var/turf/T = get_turf(src)
		to_chat(user, SPAN_NOTICE("You begin prying out any salvageable components from \the [src]."))
		playsound(src.loc, 'sound/items/Crowbar.ogg', 50, TRUE)
		if(do_after(user, 30))
			switch(rand(1,10))
				if(1 to 2)
					new /obj/item/circuitboard/magma_reservoir(T)
				if(3 to 4)
					new /obj/item/stack/material/durasteel(T)
				if(5 to 7)
					new /obj/item/stack/material/steel(T)
				if(8 to 10)
					new /obj/item/stack/cable_coil(T)
			gutted = TRUE
			update_icon()
		else
			return
	if(istype(I, /obj/item/weldingtool) && gutted)
		var/obj/item/weldingtool/W = I
		to_chat(user, SPAN_NOTICE("You begin deconstructing the housing of \the [src]."))
		if(do_after(user,30) || W.remove_fuel(5, user))
			playsound(src.loc, 'sound/items/Welder2.ogg', 50, TRUE)
			var/turf/T = get_turf(src)
			new /obj/item/frame(T)
			qdel(src)
		else
			return

/obj/structure/broken_reservoir/update_icon()
	if(sliced)
		icon_state = "reservoir_sliced"
	if(gutted)
		icon_state = "reservoir_gutted"
	else
		icon_state = "reservoir_broken"
