/obj/machinery/computer/cloning
	name = "cloning control console"
	icon_keyboard = "med_key"
	icon_screen = "dna"
	light_color = "#315ab4"
	circuit = /obj/item/circuitboard/cloning
	req_access = list(ACCESS_COMMAND_BRIDGE) //Only used for record deletion right now.
	var/menu = 1 //Which menu screen to display
	var/loading = 0 // Nice loading text

/obj/machinery/computer/cloning/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/data[0]

	var/records_list_ui[0]
	for(var/datum/dna2/record/R in records)
		records_list_ui[++records_list_ui.len] = list("ckey" = R.ckey, "name" = R.dna.real_name)

	var/pods_list_ui[0]
	for(var/obj/machinery/resleeving/body_printer/pod in pods)
		pods_list_ui[++pods_list_ui.len] = list("pod" = pod, "biomass" = pod.get_biomass())

	if(pods)
		data["pods"] = pods_list_ui
	else
		data["pods"] = null

	if(records)
		data["records"] = records_list_ui
	else
		data["records"] = null

	if(active_record)
		data["activeRecord"] = list("ckey" = active_record.ckey, "real_name" = active_record.dna.real_name, \
									"ui" = active_record.dna.uni_identity, "se" = active_record.dna.struc_enzymes)
	else
		data["activeRecord"] = null

	data["menu"] = menu
	data["connected"] = scanner
	data["podsLen"] = pods.len
	data["loading"] = loading
	if(!scanner.occupant)
		scantemp = ""
	data["scantemp"] = scantemp
	data["occupant"] = scanner.occupant
	data["locked"] = scanner.locked
	data["diskette"] = diskette
	data["temp"] = temp

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "cloning.tmpl", src.name, 400, 450)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(5)
