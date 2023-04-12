/datum/rig_console
	/// host rig
	var/obj/item/rig/host

/datum/rig_console/New(obj/item/rig/rig)
	host = rig

/datum/rig_console/Destroy()
	host = null
	if(host.console == src)
		host.console = null
	return ..()

/datum/rig_console/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/datum/rig_console/ui_host(mob/user, datum/tgui_module/module)
	return host

/datum/rig_console/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/datum/rig_console/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/datum/rig_console/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(isnull(ui))
		ui = new(user, src, "RigConsole")

#warn impl
