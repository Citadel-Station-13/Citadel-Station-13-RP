/obj/machinery/computer/resleeving
	name = "resleeving control console"
	desc = "A central controller for resleeving machinery."
	catalogue_data = list(
		/datum/category_item/catalogue/technology/resleeving,
	)
	icon_keyboard = "med_key"
	icon_screen = "dna"
	light_color = "#315ab4"
	circuit = /obj/item/circuitboard/resleeving_console

	/// all linked machines
	/// * lazy list
	var/list/obj/machinery/resleeving/linked_resleeving_machinery
	/// link range in tiles
	var/link_range = 4

	/// inserted mirror
	/// * used for body records
	var/obj/item/organ/internal/mirror/inserted_mirror
	/// inserted dna disk
	/// * used to print dna2 records (which should get refactored someday)
	var/obj/item/disk/data/inserted_disk

/obj/machinery/computer/resleeving/Initialize(mapload)
	. = ..()
	rescan_nearby_machines()

/obj/machinery/computer/resleeving/Destroy()
	for(var/obj/machinery/resleeving/linked as anything in linked_resleeving_machinery)
		unlink_resleeving_machine(linked)
	#warn drop mirror
	return ..()

/obj/machinery/computer/resleeving/drop_products(method, atom/where)
	. = ..()
	#warn drop mirror

/obj/machinery/computer/resleeving/proc/rescan_nearby_machines()
	for(var/obj/machinery/resleeving/maybe_in_range in GLOB.machines)
		if(maybe_in_range.z != src.z)
			continue
		if(get_dist(maybe_in_range, src) > link_range)
			continue
		if(maybe_in_range.linked_console)
			continue
		link_resleeving_machine(maybe_in_range)

/obj/machinery/computer/resleeving/proc/link_resleeving_machine(obj/machinery/resleeving/resleeving_machine)
	SHOULD_NOT_SLEEP(TRUE)
	return resleeving_machine.link_console(src)

/obj/machinery/computer/resleeving/proc/unlink_resleeving_machine(obj/machinery/resleeving/resleeving_machine)
	SHOULD_NOT_SLEEP(TRUE)
	if(resleeving_machine.linked_console != src)
		return TRUE
	return resleeving_machine.unlink_console()

/obj/machinery/computer/resleeving/proc/on_resleeving_machine_linked(obj/machinery/resleeving/resleeving_machine)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/obj/machinery/computer/resleeving/proc/on_resleeving_machine_unlinked(obj/machinery/resleeving/resleeving_machine)
	SHOULD_CALL_PARENT(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/obj/machinery/computer/resleeving/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "")
		#warn ui
		ui.open()

/obj/machinery/computer/resleeving/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	switch(action)
		if("relink")
		if("printBody")
			var/printer_ref = params["printerRef"]
			var/body_ref
		if("resleeve")
			var/sleever_ref = params["sleeverRef"]

/obj/machinery/computer/resleeving/ui_data(mob/user, datum/tgui/ui)
	. = ..()

	var/list/resleeving_pod_datas = list()
	var/list/body_printer_datas = list()

	for(var/obj/machinery/resleeving/machine_ref in linked_resleeving_machinery)
		if(istype(machine_ref, /obj/machinery/resleeving/body_printer))
		else if(istype(machine_ref, /obj/machinery/resleeving/resleeving_pod))

#warn impl all
