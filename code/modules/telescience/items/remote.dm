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

/obj/item/bluespace_remote/Initialize(mapload)
	. = ..()
	var/datum/object_system/cell_slot/cell_slot = init_cell_slot_easy_tool(cell_type)
	cell_slot.legacy_use_device_cells = FALSE
	if(controller_autolink_id)
		var/buffer = GLOB.telescience_linkage_buffers[controller_autolink_id]
		if(istype(buffer, /obj/machinery/teleporter_controller))
			var/obj/machinery/teleporter_controller/controller = buffer
			controller.auto_link_remote(src)
		else
			LAZYADD(GLOB.telescience_linkage_buffers[controller_autolink_id], src)

/obj/item/bluespace_remote/Destroy()
	unlink_controller()
	return ..()

/obj/item/bluespace_remote/proc/controller_linked(obj/machinery/teleporter_controller/controller)
	src.controller = controller

/obj/item/bluesapce_remote/proc/controller_unlinked(obj/machinery/teleporter_controller/controller)
	src.controller = null

/obj/item/bluespace_remote/proc/link_controller(obj/machinery/teleporter_controller/controller)
	unlink_controller()
	controller?.link_remote(src)

/obj/item/bluespace_remote/proc/unlink_controller()
	controller?.unlink_remote(src)

#warn impl all

/obj/item/bluespace_remote/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/obj/item/bluespace_remote/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/obj/item/bluespace_remote/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/obj/item/bluespace_remote/ui_module_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/datum/tgui_module/teleporter_control/ui_controller = controller?.request_ui_controller()
	.["control"] = ui_controller.data(user)
	. |= ui_controller.ui_module_data(arglist(args))

/obj/item/bluespace_remote/ui_module_static(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	var/datum/tgui_module/teleporter_control/ui_controller = controller?.request_ui_controller()
	.["control"] = ui_controller.static_data(user)
	. |= ui_controller.ui_module_static(arglist(args))

/obj/item/bluespace_remote/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BluespaceRemote")
		ui.open()

/obj/item/bluespace_remote/ui_module_act(action, list/params, datum/tgui/ui, id)
	. = ..()
	if(.)
		return
	var/datum/tgui_module/teleporter_control/ui_controller = controller?.request_ui_controller()
	return ui_controller.ui_module_act(arglist(args))

/obj/item/bluespace_remote/director
	name = "telescience remote"
	desc = "An experimental teleporter remote hard-wired into the research department's telescience suite via passive signal modulation. \
	Includes an inbuilt lensing beacon for emergency retrievals. You really, <b>really</b> shouldn't lose this."

	#warn sprite?
	#warn impl
