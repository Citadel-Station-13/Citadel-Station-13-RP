/**********************Unloading unit**************************/

/obj/machinery/mineral/unloading_machine
	name = "unloading machine"
	icon = 'icons/obj/machines/mining_machines_vr.dmi'
	icon_state = "unloader"
	density = 1
	anchored = 1.0
	speed_process = TRUE
	var/obj/machinery/mineral/input = null
	var/obj/machinery/mineral/output = null

/obj/machinery/mineral/unloading_machine/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

// wip - why isn't this dirs instead?!
/obj/machinery/mineral/unloading_machine/LateInitialize()
	for(var/dir in GLOB.cardinal)
		input = locate(/obj/machinery/mineral/input, get_step(src, dir))
		if(input)
			break
	for(var/dir in GLOB.cardinal)
		output = locate(/obj/machinery/mineral/output, get_step(src, dir))
		if(output)
			break

/obj/machinery/mineral/unloading_machine/process(delta_time)
	if(output && input)
		if(length(output.loc.contents) > 100)		// let's not!
			return
		var/obj/structure/ore_box/O = locate() in input.loc
		if(O)
			for(var/i in 1 to 50)
				if(!O.deposit(output.loc))
					break
		var/obj/item/I
		for(var/i in 1 to 50)
			I = locate() in input.loc
			if(!I)
				break
			I.forceMove(output.loc)
