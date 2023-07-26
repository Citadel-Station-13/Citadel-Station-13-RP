#define COMPONENT_GAS_EFF 0.125



/obj/structure/reactor_component
	name = "reactor part"
	desc = "Basetype of /reactor_component/, should not exist"

	var/heat = 0 //heat is measured in ahu
	var/max_temp = 1000 //stuff melts at different temperatures based on what it is, default is 1000

	var/pulse_count = 0
	var/pulses_in_last_tick = 0

	var/heat_dissipation = 0 //how much heat we obliterate from the universe each tick, handled in reactor_component/handle_heat
	var/transfer_heat_to_environment = FALSE //if we transfer heat to the ambient gas mix instead of obliterating it (assuming heat_dissipation is greater than 1)
	var/reactor_heat_pull = 0 //how much heat we pull from the reactor into ourselves per tick

	var/durability = -1 //durablity. ticks down for certain components
	var/list/adjacent_components //updated on reactor reconfigure
	var/datum/ic2_core/our_reactor

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
	return

/obj/structure/reactor_component/proc/do_heat_tick(var/mult = 1)
	if(reactor_heat_pull) //todo: make this good
		var/delta_heat = our_reactor.heat
		our_reactor.heat = MAX(0, our_reactor.heat - reactor_heat_pull)
		delta_heat -= our_reactor.heat
		heat += delta_heat
	if(transfer_heat_to_environment)
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		var/datum/gas_mixture/removed = env.remove(COMPONENT_GAS_EFF * env.total_moles)
		var/datum/gas_mixture/env = T.return_air()
		removed.adjust_thermal_energy(heat_dissipation * mult)
		env.merge(removed)
	heat -= heat_dissipation * mult

adjust_thermal_energy
