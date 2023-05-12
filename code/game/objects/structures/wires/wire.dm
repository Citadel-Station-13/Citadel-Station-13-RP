/obj/structure/wire
	name = "wirenet joint"
	desc = "the abstract concept of a network cable"

	/// our network
	var/datum/wirenet/network
	/// joined / attempt to have joined?
	var/joined = FALSE
	/// connections
	var/list/datum/wirenet_connection/connections
	/// are we a junction?
	var/is_junction = FALSE

/obj/structure/wire/Initialize(mapload)
	join()
	return ..()

/obj/structure/wire/Destroy()
	leave()
	return ..()

/obj/structure/wire/proc/join()

/obj/structure/wire/proc/leave()

/obj/structure/wire/proc/adjacent_wires()
	return list()

/obj/structure/wire/proc/auto_rebuild()
	if(!isnull(network))
		return
	rebuild()

/obj/structure/wire/proc/rebuild()
	CRASH("base rebuild called on wire")
