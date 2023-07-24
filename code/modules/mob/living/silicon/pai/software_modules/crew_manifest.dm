/datum/pai_software/crew_manifest
	name = "Crew Manifest"
	ram_cost = 5
	id = "manifest"
	toggle = 0

/datum/pai_software/crew_manifest/on_nano_ui_interact(mob/living/silicon/pai/user, datum/nanoui/ui=null, force_open=1)
	data_core.get_manifest_list()

	var/data[0]
	// This is dumb, but NanoUI breaks if it has no data to send
	data["manifest"] = GLOB.PDA_Manifest

	ui = SSnanoui.try_update_ui(user, user, id, ui, data, force_open)
	if(!ui)
		// Don't copy-paste this unless you're making a pAI software module!
		ui = new(user, user, id, "crew_manifest.tmpl", "Crew Manifest", 450, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
