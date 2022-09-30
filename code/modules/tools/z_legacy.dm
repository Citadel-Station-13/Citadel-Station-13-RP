//! these wrappers are used for things that still check tools on attackby()
//! new usages are prohibited.

/*
 *	Assorted tool procs, so any item can emulate any tool, if coded
*/
/obj/item/proc/is_screwdriver()
	return tool_behaviour() == TOOL_SCREWDRIVER

/obj/item/proc/is_wrench()
	return tool_behaviour() == TOOL_WRENCH

/obj/item/proc/is_crowbar()
	return tool_behaviour() == TOOL_CROWBAR

/obj/item/proc/is_wirecutter()
	return tool_behaviour() == TOOL_WIRECUTTER

/obj/item/proc/is_multitool()
	return tool_behaviour() == TOOL_MULTITOOL

/obj/item/proc/is_welder()
	return tool_behaviour() == TOOL_WELDER
