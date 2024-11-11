/client/proc/atmosscan()
	set category = "Mapping"
	set name = "Check Piping"
	set background = 1
	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return
	feedback_add_details("admin_verb","CP") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

	if(alert("WARNING: This command should not be run on a live server. Do you want to continue?", "Check Piping", "No", "Yes") == "No")
		return

	to_chat(usr, "Checking for disconnected pipes...", confidential = TRUE)
	//all plumbing - yes, some things might get stated twice, doesn't matter.
	for (var/obj/machinery/atmospherics/plumbing in GLOB.machines)
		if (plumbing.nodealert)
			to_chat(usr, "Unconnected [plumbing.name] located at [ADMIN_VERBOSEJMP(plumbing)]", confidential = TRUE)

	//Manifolds
	for (var/obj/machinery/atmospherics/pipe/manifold/pipe in GLOB.machines)
		if (!pipe.node1 || !pipe.node2 || !pipe.node3)
			to_chat(usr, "Unconnected [pipe.name] located at [ADMIN_VERBOSEJMP(pipe)]", confidential = TRUE)

	//Pipes
	for (var/obj/machinery/atmospherics/pipe/simple/pipe in GLOB.machines)
		if (!pipe.node1 || !pipe.node2)
			to_chat(usr, "Unconnected [pipe.name] located at [ADMIN_VERBOSEJMP(pipe)]", confidential = TRUE)

	to_chat(usr, "Checking for overlapping pipes...")
	next_turf:
		for(var/turf/T in world)
			for(var/dir in GLOB.cardinal)
				var/list/connect_types = list(1 = 0, 2 = 0, 3 = 0)
				for(var/obj/machinery/atmospherics/pipe in T)
					if(dir & pipe.initialize_directions)
						for(var/connect_type in pipe.connect_types)
							connect_types[connect_type] += 1
						if(connect_types[1] > 1 || connect_types[2] > 1 || connect_types[3] > 1)
							to_chat(usr, "Overlapping pipe ([pipe.name]) located at [ADMIN_VERBOSEJMP(pipe)]", confidential = TRUE)
							continue next_turf
	to_chat(usr, "Done", confidential = TRUE)

/client/proc/powerdebug()
	set category = "Mapping"
	set name = "Check Power"
	if(!src.holder)
		to_chat(src, "Only administrators may use this command.")
		return
	feedback_add_details("admin_verb","CPOW") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	var/list/results = list()

	for (var/datum/powernet/PN in powernets)
		if (!PN.nodes || !PN.nodes.len)
			if(PN.cables && (PN.cables.len > 1))
				var/obj/structure/cable/C = PN.cables[1]
				results += "Powernet with no nodes! (number [PN.number]) - example cable at [ADMIN_VERBOSEJMP(C)]"

		if (!PN.cables || (PN.cables.len < 10))
			if(PN.cables && (PN.cables.len > 1))
				var/obj/structure/cable/C = PN.cables[1]
				results += "Powernet with fewer than 10 cables! (number [PN.number]) - example cable at [ADMIN_VERBOSEJMP(C)]"
	to_chat(usr, "[results.Join("\n")]", confidential = TRUE)
