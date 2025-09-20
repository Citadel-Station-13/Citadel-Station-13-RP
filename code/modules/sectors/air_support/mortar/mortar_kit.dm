//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// TODO: finish this file

/obj/item/mortar_kit
	name = "mortar kit"
	desc = "A collapsed kit that can be used to deploy a stationary mortar."
	// TODO: sprite

	/// mortar to create
	var/mortar_type = /obj/machinery/mortar

#warn impl

/obj/item/mortar_kit/basic
	mortar_type = /obj/machinery/mortar/basic
