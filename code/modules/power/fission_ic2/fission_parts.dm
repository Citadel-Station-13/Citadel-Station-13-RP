/obj/structure/reactor_component
	name = "reactor part"
	desc = "Basetype of /reactor_component/, should not exist"

	var/heat = 0 //heat is measured in ahu
	var/max_temp = 1000 //stuff melts at different temperatures based on what it is, default is 1000

	var/pulse_count = 0
	var/pulses_in_last_tick = 0

	var/heat_dissipation = 0 //how much heat we obliterate from the universe each tick, handled in reactor_component/handle_heat
	var/reactor_heat_pull = 0 //how much heat we pull from the reactor into ourselves per tick

	var/durability = -1 //durablity. ticks down for certain components
	var/list/adjacent_components //updated on reactor reconfigure

/obj/structure/reactor_component/update_neighbors
	adjacent_components = list()
	for(var/dir2check in list(NORTH,SOUTH,EAST,WEST))
		var/foundloc = get_step(src,dir2check)
		for(var/obj/structure/reactor_component/foundcomponent in foundloc)
			adjacent_components += foundcomponent
			break


/obj/structure/reactor_component/send_pulse()
	for(var/obj/structure/reactor_component/neighbor in adjacent_components)
		neighbor.recieve_pulse(pulse_count)

/obj/structure/reactor_component/recieve_pulse(var/pulse_amt)
	return



