//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* WELCOME TO THE SEVENTH CIRCLE OF WEBDEV HELL
/// For efficiency, rigs will internally track and cache what needs to update.
/// We heavily abuse the TGUI modules system to selectively update data
/// with the module system's 2-deep reducer.

/obj/item/rig/proc/ui_queue()
	#warn impl

/obj/item/rig/proc/ui_queue_piece(datum/component/rig_piece/piece)
	#warn impl

/obj/item/rig/proc/ui_queue_component(obj/item/rig_component/)
	CRASH("not implemented")

/obj/item/rig/proc/ui_queue_module(obj/item/rig_module/module)
	CRASH("not implemented")

/obj/item/rig/proc/ui_queue_reflists()
	#warn impl

/obj/item/rig/proc/ui_queue_everything()
	#warn impl

/obj/item/rig/proc/ui_flush()
	#warn impl


#warn impl
