//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/rig_module/item_mount/single/defib_paddles

/obj/item/rig_module/item_mount/single/defib_paddles/Initialize(mapload)
	. = ..()
	internal_paddles = new /obj/item/shockpaddles/standalone

/obj/item/rig_module/item_mount/single/defib_paddles/Destroy()
	QDEL_NULL(internal_paddles)
	return ..()

#warn impl
