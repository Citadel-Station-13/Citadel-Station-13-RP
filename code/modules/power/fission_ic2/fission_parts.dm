#define COMPONENT_GAS_EFF 0.125


/obj/structure/reactor_frame
	name = "reactor frame
	desc = "A heavy steel frame with electrical and pneumatic conduits for support and control of reactor equipment."
	allow_unanchor = TRUE
	var/datum/ic2_core/our_reactor

/obj/structure/reactor_frame/dynamic_tool_functions(obj/item/I, mob/user)
	. = ..()
	if(allow_unanchor)
		.[TOOL_WRENCH] = anchored? "anchor" : "unanchor"

/obj/structure/reactor_frame/dynamic_tool_image(function, hint)
	switch(function)
		if(TOOL_WRENCH)
			return anchored? dyntool_image_backward(TOOL_WRENCH) : dyntool_image_forward(TOOL_WRENCH)
	return ..()

/obj/structure/reactor_frame/wrench_act(obj/item/I, mob/user, flags, hint)
	if(!allow_unanchor)
		to_chat(user, SPAN_NOTICE("You can't unsecure the [name] in its current state! Try turning off the reactor first."))
		return ..()
	if(use_wrench(I, user, delay = 4 SECONDS))
		user.visible_message(SPAN_NOTICE("[user] [anchored? "fastens [src] to the ground" : "unfastens [src] from the ground"]."), range = MESSAGE_RANGE_CONSTRUCTION)
		return TRUE
	return ..()

/obj/structure/reactor_component
	name = "reactor part"
	desc = "Basetype of /reactor_component/, should not exist"
	allow_unanchor = TRUE

	var/heat = 0 //heat is measured in ahu
	var/max_temp = 1000 //stuff melts at different temperatures based on what it is, default is 1000

	var/pulse_count = 0
	var/pulses_in_last_tick = 0

	var/heat_dissipation = 0 //how much heat we obliterate from the universe each tick, handled in reactor_component/handle_heat
	var/transfer_heat_to_environment = FALSE //if we transfer heat to the ambient gas mix instead of obliterating it (assuming heat_dissipation is greater than 1)
	var/reactor_mode_based_enviroheat = FALSE
	var/reactor_heat_pull = 0 //how much heat we pull from the reactor into ourselves per tick

	var/durability = -1 //durablity. ticks down for certain components
	var/list/adjacent_components //updated on reactor reconfigure
	var/datum/ic2_core/our_reactor

/obj/structure/reactor_component/dynamic_tool_functions(obj/item/I, mob/user)
	. = ..()
	if(allow_unanchor)
		.[TOOL_WRENCH] = anchored? "anchor" : "unanchor"

/obj/structure/reactor_component/dynamic_tool_image(function, hint)
	switch(function)
		if(TOOL_WRENCH)
			return anchored? dyntool_image_backward(TOOL_WRENCH) : dyntool_image_forward(TOOL_WRENCH)
	return ..()

/obj/structure/reactor_component/wrench_act(obj/item/I, mob/user, flags, hint)
	if(!allow_unanchor)
		to_chat(user, SPAN_NOTICE("You can't unsecure the [name] in its current state! Try turning off the reactor first."))
		return ..()
	if(use_wrench(I, user, delay = 4 SECONDS))
		user.visible_message(SPAN_NOTICE("[user] [anchored? "fastens [src] to the ground" : "unfastens [src] from the ground"]."), range = MESSAGE_RANGE_CONSTRUCTION)
		return TRUE
	return ..()

/obj/structure/reactor_component/proc/update_neighbors()
	adjacent_components = list()
	for(var/dir2check in list(NORTH,SOUTH,EAST,WEST))
		var/foundloc = get_step(src,dir2check)
		for(var/obj/structure/reactor_component/foundcomponent in foundloc)
			adjacent_components += foundcomponent
			break


/obj/structure/reactor_component/proc/send_pulse()
	for(var/obj/structure/reactor_component/neighbor in adjacent_components)
		neighbor.recieve_pulse(pulse_count)

/obj/structure/reactor_component/proc/recieve_pulse(var/pulse_amt)
	pulses_in_last_tick += pulse_amt
	return

/obj/structure/reactor_component/proc/do_heat_tick()
	if(reactor_heat_pull != 0) //todo: make this good
		var/heat_pull_amt
		if(reactor_heat_pull) //if positive pull (i.e we PULL heat)
			if(reactor.heat < reactor_heat_pull)
				heat_pull_amt = reactor.heat
		else //if NEGATIVE pull (i.e we PUSH heat)
			if(heat < (reactor_heat_pull * -1))
				heat_pull_amt = -heat
		reactor.heat -= heat_pull_amt
		heat += heat_pull_amt
	if(transfer_heat_to_environment)
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		var/datum/gas_mixture/removed = env.remove(COMPONENT_GAS_EFF * env.total_moles)
		var/datum/gas_mixture/env = T.return_air()
		removed.adjust_thermal_energy(heat_dissipation)
		env.merge(removed)
	heat -= heat_dissipation


/obj/structure/reactor_component/fuelrod
	name = "reactor fuel rod"
	desc = "A reactor fuel rod."

/obj/structure/reactor_component/heatvent
	name = "reactor heat vent"
	desc = "A reactor heat vent. Vents heat to the atmosphere."
	heat_dissipation = 6

/obj/structure/reactor_component/heat_exchanger
	name = "heat exchanger"
	desc = "A reactor heat exchanger. Attempts to equalize heat in adjacent reactor components and the reactor itself."
	var/component_heat_exchange = 12
	var/core_heat_exchange = 4

/obj/structure/reactor_component/heat_exchanger/do_heat_tick()
	var/list/components_to_hex
	if(component_heat_exchange)
		for(var/obj/structure/reactor_component/RC in adjacent_components)
			components_to_hex[RC] = RC.heat / RC.max_temp
		components_to_hex = insertion_sort(components_to_hex, associative = TRUE)
		for(var/obj/structure/reactor_component/RC in components_to_hex)




#undef COMPONENT_GAS_EFF
