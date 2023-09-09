/obj/map_helper/conveyor
	name = "use a subtype!"
	icon = 'icons/misc/map_helpers.dmi'
	plane = 20 //I dunno just high.
	alpha = 170

	//The device we're setting up
	var/my_device
	var/my_device_type = /obj/machinery/conveyor
	//Most things have a radio tag of some sort that needs adjusting
	var/id_tag

/obj/map_helper/conveyor/Initialize(mapload)
	..()
	my_device = locate(my_device_type) in get_turf(src)
	if(!my_device)
		TO_WORLD("<b><font color='red'>WARNING:</font><font color='black'>conveyor helper '[name]' couldn't find what it wanted at: X:[x] Y:[y] Z:[z]</font></b>")
	else
		setup()
	return INITIALIZE_HINT_QDEL

/obj/map_helper/conveyor/Destroy()
	my_device = null
	return ..()


/obj/map_helper/conveyor/proc/setup()
	return //Stub for subtypes

/obj/map_helper/conveyor/belt
	name = "Rename me Jerry!"
	icon_state = "belt"
	my_device_type = /obj/machinery/conveyor

/obj/map_helper/conveyor/belt/setup()
	var/obj/machinery/conveyor/my_belt = my_device
	my_belt.tag = id_tag
	my_belt.name = name



/obj/map_helper/conveyor/lever
	name = "Rename me Jerry!"
	icon_state = "lever"
	my_device_type = /obj/machinery/conveyor_switch

/obj/map_helper/conveyor/lever/setup()
	var/obj/machinery/conveyor_switch/my_switch = my_device
	my_switch.tag = id_tag
	my_switch.name = name
