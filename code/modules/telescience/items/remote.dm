//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/obj/item/bluespace_remote
	name = "bluespace remote"
	desc = "A prototype remote utilizing a mixture of subspace communications and a powered bluespace beacon to control a far away teleporter."
	#warn sprite

	/// linked controller
	var/obj/machinery/teleporter_controller/controller
	/// autolink controller id
	var/controller_autolink_id

	/// starting cell type
	var/cell_type = /obj/item/cell/device/weapon
	/// power cell
	var/obj/item/cell/cell

/obj/item/bluespace_remote/Initialize(mapload)
	. = ..()
	init_cell_slot_easy_tool()
	#warn impl autolink

/obj/item/bluespace_remote/Destroy()
	#warn unlink
	return ..()

#warn impl all

/obj/item/bluespace_remote/get_cell()
	return cell

/obj/item/bluespace_remote/director
	name = "telescience remote"
	desc = "A highly experimental teleporter remote. Unlike more standard variants, this one \
	has an inbuilt signal booster and solver and is pre-linked to the installation's telescience suite. \
	You really, really shouldn't lose this."
	#warn sprite?
	#warn impl
