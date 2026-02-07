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

	var/last_relink
	var/last_relink_throttle = 3 SECONDS

/obj/machinery/computer/resleeving/Initialize(mapload)
	. = ..()
	rescan_nearby_machines()

/obj/machinery/computer/resleeving/Destroy()
	for(var/obj/machinery/resleeving/linked as anything in linked_resleeving_machinery)
		unlink_resleeving_machine(linked)
	remove_held_mirror(drop_location())
	return ..()

/obj/machinery/computer/resleeving/drop_products(method, atom/where)
	. = ..()
	remove_held_disk(where)
	remove_held_mirror(where)

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
		ui = new(user, src, "computers/ResleevingConsole")
		ui.open()

/obj/machinery/computer/resleeving/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return

	switch(action)
		if("relink")
			if(world.time > (last_relink + last_relink_throttle))
				return TRUE
			last_relink = world.time
			rescan_nearby_machines()
			return TRUE
		if("unlink")
			var/unlink_ref = params["unlinkRef"]
			if(!istext(unlink_ref))
				return TRUE
			var/obj/machinery/resleeving/maybe_linked = locate(unlink_ref) in linked_resleeving_machinery
			unlink_resleeving_machine(maybe_linked)
			return TRUE
		if("printBody")
			var/printer_ref = params["printerRef"]
			var/body_ref = params["bodyRef"]
			if(!istext(printer_ref) || istext(body_ref))
				return TRUE
			var/obj/machinery/resleeving/body_printer/printer = locate(printer_ref) in linked_resleeving_machinery
			if(!printer)
				return TRUE
			var/datum/resleeving_body_backup/body = locate_stored_body_ref(body_ref)
			if(!body)
				return TRUE
			printer.start_body(body)
			return TRUE
		if("resleeve")
			var/sleever_ref = params["sleeverRef"]
			if(!istext(sleever_ref))
				return TRUE
			var/obj/machinery/resleeving/resleeving_pod/sleever = locate(sleever_ref) in linked_resleeving_machinery
			if(!sleever)
				return TRUE
			if(!sleever.held_mirror)
				return TRUE
			if(!sleever.machine_occupant_pod?.occupant)
				return TRUE
			sleever.perform_resleeve(sleever.machine_occupant_pod.occupant, sleever.held_mirror)
			return TRUE
		if("removeMirror")
			user_yank_mirror(actor, TRUE)
			return TRUE
		if("removeDisk")
			user_yank_disk(actor, TRUE)
			return TRUE

/obj/machinery/computer/resleeving/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["relinkOnCooldown"] = world.time > (last_relink + last_relink_throttle)
	.["insertedDisk"] = inserted_disk ? list(
		"name" = inserted_disk.name,
		"valid" = attempt_adapt_old_dna2_disk_to_body_record(inserted_disk),
	) : null
	.["insertedMirror"] = inserted_mirror?.ui_serialize()

	/**
	 * Special format;
	 * name: str
	 * synthetic: booleanlike
	 * ref: str
	 * source: str
	 */
	var/list/body_record_datas = list()
	.["bodyRecords"] = body_record_datas
	if(inserted_disk)
		if(inserted_disk.buf.dna)
			body_record_datas[++body_record_datas.len] = list(
				"name" = inserted_disk.buf.dna.real_name,
				"synthetic" = FALSE,
				"ref" = ref(inserted_disk),
				"source" = "DNA Disk (Console)",
			)
	if(inserted_mirror?.recorded_body)
		var/datum/resleeving_body_backup/body_rec = inserted_mirror?.recorded_body
		body_record_datas[++body_record_datas.len] = list(
			"name" = body_rec.legacy_dna.name || "Unknown",
			"synthetic" = body_rec.legacy_synthetic,
			"ref" = ref(inserted_mirror),
			"source" = "Mirror (Console)"
		)

	var/list/resleeving_pod_datas = list()
	var/list/body_printer_datas = list()
	.["sleevePods"] = resleeving_pod_datas
	.["bodyPrinters"] = body_printer_datas

	for(var/obj/machinery/resleeving/machine_ref in linked_resleeving_machinery)
		if(istype(machine_ref, /obj/machinery/resleeving/body_printer))
			var/obj/machinery/resleeving/body_printer/casted = machine_ref
			body_printer_datas[++body_printer_datas.len] = list(
				"ref" = ref(casted),
				"name" = casted.name,
				"busy" = casted.currently_growing ? list(
					"record" = casted.currently_growing.ui_serialize(),
					"progressRatio" = casted.currently_growing_progress_estimate_ratio,
				) : null,
				"allowOrganic" = casted.allow_organic,
				"allowSynthetic" = casted.allow_synthetic,
			)
		else if(istype(machine_ref, /obj/machinery/resleeving/resleeving_pod))
			var/obj/machinery/resleeving/resleeving_pod/casted = machine_ref
			var/datum/mind/held_mind = casted.held_mirror?.recorded_mind?.mind_ref?.resolve()
			var/mob/occupant = casted.machine_occupant_pod?.occupant
			resleeving_pod_datas[++resleeving_pod_datas.len] = list(
				"ref" = ref(casted),
				"name" = casted.name,
				"occupied" = occupant ? list(
					"name" = occupant.name,
					"hasMind" = !!occupant.mind,
					"stat" = occupant.stat == CONSCIOUS ? "conscious" : (occupant.stat == DEAD ? "dead" : "unconscious"),
					"compatibleWithMirror" = held_mind && occupant.resleeving_check_mind_belongs(held_mind),
				) : null,
				"mirror" = casted.held_mirror?.ui_serialize(),
			)

/obj/machinery/computer/resleeving/Exited(atom/movable/AM, atom/newLoc)
	..()
	if(AM == inserted_mirror)
		remove_held_mirror()
	else if(AM == inserted_disk)
		remove_held_disk()

/obj/machinery/computer/resleeving/proc/remove_held_mirror(atom/move_to) as /obj/item/organ/internal/mirror
	if(!inserted_mirror)
		return
	var/obj/item/organ/internal/mirror/removed = inserted_mirror
	inserted_mirror = null
	if(move_to)
		removed.forceMove(move_to)
	return removed

/obj/machinery/computer/resleeving/proc/remove_held_disk(atom/move_to) as /obj/item/disk/data
	if(!inserted_disk)
		return
	var/obj/item/disk/data/removed = inserted_disk
	inserted_disk = null
	if(move_to)
		removed.forceMove(move_to)
	return removed

/obj/machinery/computer/resleeving/proc/user_yank_mirror(datum/event_args/actor/actor, put_in_hands, silent)
	if(!inserted_mirror)
		return FALSE
	remove_held_mirror(actor.performer)
	var/was_put_in_hands = yank_item_out(inserted_mirror, actor.performer)
	if(!silent)
		if(was_put_in_hands)
			visible_message(
				SPAN_NOTICE("[actor.performer] removes [inserted_mirror] from [src]."),
			)
		else
			visible_message(
				SPAN_WARNING("[src] ejects [inserted_mirror]!"),
			)
	return TRUE

/obj/machinery/computer/resleeving/proc/user_yank_disk(datum/event_args/actor/actor, put_in_hands, silent)
	if(!inserted_disk)
		return FALSE
	remove_held_disk(actor.performer)
	var/was_put_in_hands = yank_item_out(inserted_disk, actor.performer)
	if(!silent)
		if(was_put_in_hands)
			visible_message(
				SPAN_NOTICE("[actor.performer] removes [inserted_disk] from [src]."),
			)
		else
			visible_message(
				SPAN_WARNING("[src] ejects [inserted_disk]!"),
			)
	inserted_disk = null
	return TRUE

/obj/machinery/computer/resleeving/proc/locate_stored_body_ref(ref_text)
	// sometimes i think about the fact that this is just memory address checks lmfao
	// maybe we should stop leaking refs to players but i don't really care
	// what are they gonna do, topic() bomb/brute force?? just don't take ref input
	// from players 4head..
	if(inserted_mirror && ref_text == ref(inserted_mirror))
		// is mirror body, just use it
		return inserted_mirror.recorded_body
	if(inserted_disk && ref_text == ref(inserted_disk))
		// is inserted disk, we need to create one with it
		return attempt_adapt_old_dna2_disk_to_body_record(inserted_disk)

/obj/machinery/computer/resleeving/proc/attempt_adapt_old_dna2_disk_to_body_record(obj/item/disk/data/disk)
	var/datum/dna2/record/buffer = disk.buf
	if(!buffer)
		return
	var/datum/resleeving_body_backup/transforming = new
	transforming.legacy_dna = buffer
	var/datum/species/resolved_species = SScharacters.resolve_species_name(buffer.dna.species) || SScharacters.resolve_species_path(/datum/species/human)
	transforming.legacy_species_uid = resolved_species.uid
	transforming.legacy_gender = buffer.gender || MALE
	return transforming
