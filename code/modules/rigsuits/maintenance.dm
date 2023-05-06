/datum/rig_maint_panel
	/// host rig
	var/obj/item/rig/host

/datum/rig_maint_panel/New(obj/item/rig/rig)
	host = rig

/datum/rig_maint_panel/Destroy()
	host = null
	if(host.maint_panel == src)
		host.maint_panel = null
	return ..()

/datum/rig_maint_panel/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/datum/rig_maint_panel/ui_host(mob/user, datum/tgui_module/module)
	return host

/datum/rig_maint_panel/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/datum/rig_maint_panel/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/datum/rig_maint_panel/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(isnull(ui))
		ui = new(user, src, "RigMaintenance")

#warn impl
