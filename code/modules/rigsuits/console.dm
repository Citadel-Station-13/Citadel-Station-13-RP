//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/rig/proc/console_query(mob/user)
	return list(
		"activate" = "Engage the hardsuit's systems and bind it to its wearer.",
		"deactivate" = "Disengage the hardsuit's systems and unbinds it from its wearer",
	)

/obj/item/rig/proc/console_process(mob/user, command, list/arguments)
	switch(command)
		if("activate")
			#warn impl
		if("deactivate")
			#warn impl
	return list("unknown command", "<invalid>")
