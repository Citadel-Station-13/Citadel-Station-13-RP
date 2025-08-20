//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Bindings for a pickaxe.
 */
/obj/item/rig_module/basic/pickaxe
	impl_click = TRUE
	/// automatically mounts and sets everything
	var/lazy_automount_path = /obj/item/pickaxe

#warn impl

/obj/item/rig_module/basic/pickaxe/plasma_cutter
	lazy_automount_path = /obj/item/pickaxe/plasmacutter

/obj/item/rig_module/basic/pickaxe/diamond_drill
	lazy_automount_path = /obj/item/pickaxe/diamonddrill
