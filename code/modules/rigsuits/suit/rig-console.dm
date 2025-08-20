//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// TODO: finish this system

// /obj/item/rig/proc/request_console()
// 	RETURN_TYPE(/datum/rig_console)
// 	if(isnull(console))
// 		console = new(src)
// 	return console

// /obj/item/rig/proc/console_query(effective_control_flags, username)
// 	return list(
// 		"activate" = "Engage the hardsuit's systems and bind it to its wearer.",
// 		"deactivate" = "Disengage the hardsuit's systems and unbinds it from its wearer",
// 	)

// /**
//  * @return list(text, log text override)
//  */
// /obj/item/rig/proc/console_process(effective_control_flags, username, command, list/arguments)
// 	switch(command)
// 		if("activate")
// 			activation_sequence()
// 			return list("activating...", "<active 1>")
// 		if("deactivate")
// 			deactivation_sequence()
// 			return list("deactivating...", "<active 0>")
// 	return list("unknown command", "<invalid>")
