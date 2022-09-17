//! these wrappers are used for things that still check tools on attackby()
//! new usages are prohibited.

/*
 *	Assorted tool procs, so any item can emulate any tool, if coded
*/
/obj/item/proc/is_screwdriver()
	return tool_check(TOOL_SCREWDRIVER)

/obj/item/proc/is_wrench()
	return tool_check(TOOL_WRENCH)

/obj/item/proc/is_crowbar()
	return tool_check(TOOL_CROWBAR)

/obj/item/proc/is_wirecutter()
	return tool_check(TOOL_WIRECUTTER)

/obj/item/proc/is_multitool()
	return tool_check(TOOL_MULTITOOL)

/obj/item/proc/is_welder()
	return tool_check(TOOL_WELDER)
