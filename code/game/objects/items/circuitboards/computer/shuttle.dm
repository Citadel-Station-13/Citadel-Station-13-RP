#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

//
// Shuttle control console. Board tries to auto-link the computer if built on a shuttle.
//
/obj/item/circuitboard/shuttle_console
	origin_tech = list(TECH_DATA = 3)
	var/shuttle_category = null	// Shuttle datum's category must exactly equal this to auto-detect
	var/shuttle_tag = null		// If set, link constructed console to this shuttle. If null, auto-detect.

/obj/item/circuitboard/shuttle_console/after_deconstruct(atom/A)
	. = ..()
	if(!istype(A, /obj/machinery/computer/shuttle_control))
		return
	var/obj/machinery/computer/shuttle_control/C = A
	shuttle_tag = C.shuttle_tag
	if(shuttle_tag)
		name = T_BOARD("[shuttle_tag] control console")

// Try to auto-link the shuttle computer if it is constructed on a shuttle (and not pre-programmed)
/obj/item/circuitboard/shuttle_console/after_construct(atom/A)
	. = ..()
	if(!istype(A, /obj/machinery/computer/shuttle_control))
		return
	var/obj/machinery/computer/shuttle_control/C = A
	if(!shuttle_tag)
		shuttle_tag = auto_detect_shuttle(C) // We don't have a preset tag, so lets try to auto-link.
	if(shuttle_tag && C.set_shuttle_tag(shuttle_tag))
		log_and_message_admins("[key_name_admin(usr)] built a [C] for [shuttle_tag] at [ADMIN_COORDJMP(C)]")
		C.ping("[C] auto-links with shuttle [shuttle_tag]")

// Return shuttle_tag of shuttle of current area
/obj/item/circuitboard/shuttle_console/proc/auto_detect_shuttle(obj/machinery/computer/shuttle_control/M)
	var/area/A = get_area(M)
	if(!A || !(A in SSshuttle.shuttle_areas))
		return	// Definately not on a shuttle
	for(var/shuttle_name in SSshuttle.shuttles)
		var/datum/shuttle/S = SSshuttle.shuttles[shuttle_name]
		if(A in S.find_childfree_areas())
			// Found the owning shuttle! Return it if its a valid type
			return (S.category == shuttle_category) ? S.name : null

// Overmap shuttle console.
/obj/item/circuitboard/shuttle_console/explore
	name = T_BOARD("long range shuttle control console")
	build_path = /obj/machinery/computer/shuttle_control/explore
	origin_tech = list(TECH_DATA = 3, TECH_BLUESPACE = 4)
	shuttle_category = /datum/shuttle/autodock/overmap

// Multi-shuttle console
/obj/item/circuitboard/shuttle_console/multi
	name = T_BOARD("multi-route shuttle control console")
	build_path = /obj/machinery/computer/shuttle_control/multi
	shuttle_category = /datum/shuttle/autodock/multi

// Basic "ferry" shuttle console
/obj/item/circuitboard/shuttle_console/ferry
	name = T_BOARD("basic shuttle control console")
	build_path = /obj/machinery/computer/shuttle_control
	shuttle_category = /datum/shuttle/autodock/ferry
