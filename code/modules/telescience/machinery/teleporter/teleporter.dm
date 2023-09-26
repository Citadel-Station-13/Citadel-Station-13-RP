//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/machinery/teleporter
	#warn sprite

	/// linked controller
	var/obj/machinery/teleporter_controller/controller
	/// autolink controller id - normal link checks are still done
	var/controller_autolink_id

/obj/machinery/teleporter/Initialize(mapload)
	#warn impl
	return ..()

/obj/machinery/teleporter/Destroy()
	unlink_controller()
	return ..()

/obj/machinery/teleporter/proc/link_controller(obj/machinery/teleporter_controller/controller)
	#warn impl

/obj/machinery/teleporter/proc/unlink_controller()
	#warn impl
