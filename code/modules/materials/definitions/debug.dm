// Mostly for debugging table connections
// This file is not #included in the .dme.

/datum/material/debug
	name = "debugium"
	id = "debug"

	stack_type = /obj/item/stack/material/debug
	icon_base = "debug"
	icon_reinf = "rdebug"
	icon_colour = "#FFFFFF"

/obj/item/stack/material/debug
	name = "debugium"
	icon = 'icons/obj/tables.dmi'
	icon_state = "debugium"
	default_type = "debugium"

/obj/structure/table/debug/Initialize(mapload)
	. = ..()
	material = get_material_by_name("debugium")
