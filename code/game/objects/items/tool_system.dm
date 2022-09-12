/obj/item
	/// static tool behavior
	var/tool_behaviour = NONE
	/// static tool speed - multiplies delay (e.g. 0.5 for twixe as fast)
	var/tool_speed = 1
	/// static tool quality
	var/tool_quality = TOOL_QUALITY_DEFAULT
	#warn switch system?
	/// override for dynamic tool support - varedit only
	VAR_PRIVATE/list/dynamic_tool_override

/*
 *	Assorted tool procs, so any item can emulate any tool, if coded
*/
/obj/item/proc/is_screwdriver()
	return FALSE

/obj/item/proc/is_wrench()
	return FALSE

/obj/item/proc/is_crowbar()
	return FALSE

/obj/item/proc/is_wirecutter()
	return FALSE

/obj/item/proc/is_cable_coil()
	return FALSE

/obj/item/proc/is_multitool()
	return FALSE

/obj/item/proc/is_welder()
	return FALSE
