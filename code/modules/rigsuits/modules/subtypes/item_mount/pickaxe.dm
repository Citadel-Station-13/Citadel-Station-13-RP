//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Bindings for a pickaxe.
 */
/obj/item/rig_module/item_mount/single/pickaxe
	/// automatically mounts and sets everything
	lazy_automount_path = /obj/item/pickaxe

/obj/item/rig_module/item_mount/single/pickaxe/Initialize(mapload)
	. = ..()


#warn impl

/obj/item/rig_module/item_mount/single/pickaxe/plasma_cutter
	lazy_automount_path = /obj/item/pickaxe/plasmacutter

/obj/item/rig_module/item_mount/single/pickaxe/drill
	lazy_automount_path = /obj/item/pickaxe/drill

/obj/item/rig_module/item_mount/single/pickaxe/diamond_drill
	lazy_automount_path = /obj/item/pickaxe/diamonddrill
