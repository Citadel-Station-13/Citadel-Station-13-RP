//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

#warn circuit

/obj/machinery/teleporter/bluespace_pad
	name = "bluespace projection pad"
	desc = "A pad specially built to contain a projected confinement field."
	#warn sprite

	/// linked consoles
	var/list/obj/machinery/computer/teleporter/consoles
	/// linked remotes
	var/list/obj/item/bluespace_remote/remotes

	/// active field
	var/obj/effect/bluespace_field/field

/obj/machinery/teleporter/bluespace_pad/Destroy()
	if(field)
		QDEL_NULL(field)
	#warn impl
	return ..()

/obj/machinery/teleporter/bluespace_pad/proc/generate_field()

#warn impl all
