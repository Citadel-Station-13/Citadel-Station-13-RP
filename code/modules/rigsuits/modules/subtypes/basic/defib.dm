//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/rig_module/basic/defib

	var/obj/item/shockpaddles/internal_paddles

/obj/item/rig_module/basic/defib/Initialize(mapload)
	. = ..()
	internal_paddles = new /obj/item/shockpaddles/standalone

/obj/item/rig_module/basic/defib/Destroy()
	QDEL_NULL(internal_paddles)
	return ..()

#warn impl
