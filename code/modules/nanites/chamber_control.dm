/obj/item/circuitboard/computer/nanite_chamber
	name = T_BOARD("nanite chamber control")
	build_path = /obj/machinery/computer/nanite_chamber

/obj/machinery/computer/nanite_chamber
	name = "nanite chamber control"
	desc = "A control console for nanite chambers. Automatically links to adjacent chambers."
	circuit = /obj/item/circuitboard/computer/nanite_chamber
	icon_screen = "nanite_chamber"

	idle_power_usage = POWER_USAGE_COMPUTER_MID_IDLE
	active_power_usage = POWER_USAGE_COMPUTER_MID_ACTIVE

	/// linked chamber
	var/obj/machinery/nanite_chamber/linked

/obj/machinery/computer/nanite_chamber/Initialize(mapload)
	. = ..()
	relink()

/obj/machinery/computer/nanite_chamber/Destroy()
	unlink_chamber()
	return ..()

/obj/machinery/computer/nanite_chamber/proc/link_chamber(obj/machinery/nanite_chamber/chamber)
	ASSERT(!isnull(chamber))
	if(!isnull(linked))
		unlink_chamber()
	linked = chamber

/obj/machinery/computer/nanite_chamber/proc/unlink_chamber()
	if(isnull(linked))
		return
	linked = null
	update_static_data()

/obj/machinery/computer/nanite_chamber/proc/check_chamber()
	if(!linked)
		return
	if(get_dist(linked, src) > 1)
		unlink_chamber()

/obj/machinery/computer/nanite_chamber/proc/relink()
	check_chamber()
	if(linked)
		return
	var/obj/machinery/nanite_chamber/chamber = nearby_chamber()
	if(!chamber || chamber.linked)
		return
	link_chamber(chamber)

/obj/machinery/computer/nanite_chamber/proc/nearby_chamber()
	RETURN_TYPE(/obj/machinery/nanite_chamber)
	return locate(/obj/machinery/nanite_chamber) in orange(1, src)

/obj/machinery/computer/nanite_chamber/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NaniteChamberControl")
		ui.open()

/obj/machinery/computer/nanite_chamber/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	switch(action)
		if("lock")
			linked?.toggle_locked()
			return TRUE
		if("protean_reconstruct")
			if(!linked.protean_core || !linked.check_reconstruction_costs())
				return TRUE
			linked.consume_reconstruction_costs()
			linked.rebuild_protean()
			return TRUE
		if("protean_refresh")
			linked.try_refresh_protean()
			return TRUE

/obj/machinery/computer/nanite_chamber/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(isnull(linked))
		return
	.["open"] = linked.open
	.["locked"] = linked.locked
	.["operating"] = linked.operating

/obj/machinery/computer/nanite_chamber/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(isnull(linked))
		.["hasChamber"] = FALSE
		return
	.["hasChamber"] = TRUE
	if(!isnull(linked.occupant))
		var/is_protean = FALSE
		if(ishuman(linked.occupant))
			var/mob/living/carbon/human/H = linked.occupant
			is_protean = istype(H.species, /datum/species/protean)
		.["hasOccupant"] = TRUE
		.["occupant"] = list(
			"name" = linked.occupant.name,
			"isProtean" = is_protean,
		)
	else
		.["hasOccupant"] = FALSE
	if(!isnull(linked.protean_core))
		var/list/intact_organs = list()
		var/list/missing_organs = list()
		if(locate(/obj/item/organ/internal/nano/refactory) in linked.held_items)
			intact_organs += "refactory"
		else
			missing_organs += "refactory"
		if(locate(/obj/item/organ/internal/nano/orchestrator) in linked.held_items)
			intact_organs += "orchestrator"
		else
			missing_organs += "orchestrator"
		.["hasProtean"] = TRUE
		.["protean"] = list(
			"name" = linked.protean_core.name,
			"organs" = list(
				"intact" = intact_organs,
				"missing" = missing_organs,
				"cost" = linked.protean_reconstruction_costs(),
			),
			"materials" = linked.available_materials(),
		)
	else
		.["hasProtean"] = FALSE
