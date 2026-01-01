//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//! these wrappers are used for things that still check tools on attackby()
//! new usages are prohibited.

/*
 *	Assorted tool procs, so any item can emulate any tool, if coded
*/
/obj/item/proc/is_screwdriver()
	return tool_behavior() == TOOL_SCREWDRIVER

/obj/item/proc/is_wrench()
	return tool_behavior() == TOOL_WRENCH

/obj/item/proc/is_crowbar()
	return tool_behavior() == TOOL_CROWBAR

/obj/item/proc/is_wirecutter()
	return tool_behavior() == TOOL_WIRECUTTER

/obj/item/proc/is_multitool()
	return tool_behavior() == TOOL_MULTITOOL

/obj/item/proc/is_welder()
	return tool_behavior() == TOOL_WELDER
