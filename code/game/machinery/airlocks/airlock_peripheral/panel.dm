//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

// todo: buildable

/obj/machinery/airlock_peripheral/panel
	name = "airlock panel"
	desc = "A control panel for an airlock, linked to its main controller."
	#warn sprite

#warn impl

/obj/machinery/airlock_peripheral/panel/on_controller_leave(obj/machinery/airlock_component/controller/controller)
	..()
	SStgui.close_uis(src)

/obj/machinery/airlock_peripheral/panel/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	hardmapped = TRUE
