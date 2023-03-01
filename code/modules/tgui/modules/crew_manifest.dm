/datum/tgui_module_old/crew_manifest
	name = "Crew Manifest"
	tgui_id = "CrewManifest"

/datum/tgui_module_old/crew_manifest/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	var/list/data = ..()
	if(data_core)
		data_core.get_manifest_list()
	data["manifest"] = GLOB.PDA_Manifest
	return data

/datum/tgui_module_old/crew_manifest/robot
/datum/tgui_module_old/crew_manifest/robot/ui_state(mob/user, datum/tgui_module/module)
	return GLOB.self_state
