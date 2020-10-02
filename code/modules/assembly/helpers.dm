/proc/isassembly(O)
	if(istype(O, /obj/item/assembly))
		return 1
	return FALSE

/proc/isigniter(O)
	if(istype(O, /obj/item/assembly/igniter))
		return 1
	return FALSE

/proc/isinfared(O)
	if(istype(O, /obj/item/assembly/infra))
		return 1
	return FALSE

/proc/isprox(O)
	if(istype(O, /obj/item/assembly/prox_sensor))
		return 1
	return FALSE

/proc/issignaler(O)
	if(istype(O, /obj/item/assembly/signaler))
		return 1
	return FALSE

/proc/istimer(O)
	if(istype(O, /obj/item/assembly/timer))
		return 1
	return FALSE

/*
Name:	IsSpecialAssembly
Desc:	If true is an object that can be attached to an assembly holder but is a special thing like a phoron can or door
*/

/obj/proc/IsSpecialAssembly()
	return FALSE

/*
Name:	IsAssemblyHolder
Desc:	If true is an object that can hold an assemblyholder object
*/
/obj/proc/IsAssemblyHolder()
	return FALSE
