//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/rig/proc/console_query(effective_control_flags, username)
	return list(
		"activate" = "Engage the hardsuit's systems and bind it to its wearer.",
		"deactivate" = "Disengage the hardsuit's systems and unbinds it from its wearer",
	)

/**
 * @return list(text, log text override)
 */
/obj/item/rig/proc/console_process(effective_control_flags, username, command, list/arguments)
	switch(command)
		if("activate")
			activation_sequence()
		if("deactivate")
			deactivation_sequence()
	return list("unknown command", "<invalid>")
