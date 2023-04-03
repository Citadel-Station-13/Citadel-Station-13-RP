/obj/item/circuitboard/computer/nanite_chamber
	name = T_BOARD("nanite chamber control")
	build_path = /obj/machinery/computer/nanite_chamber

/obj/machinery/computer/nanite_chamber
	name = "nanite chamber control"
	desc = "A control console for nanite chambers. Automatically links to adjacent chambers."
	#warn sprite
	circuit = /obj/item/circuitboard/computer/nanite_chamber

	idle_power_usage = POWER_USAGE_COMPUTER_MID_IDLE
	active_power_usage = POWER_USAGE_COMPUTER_MID_ACTIVE

	/// linked chamber
	var/obj/machinery/nanite_chamber/linked

/obj/machinery/computer/nanite_chamber/Initialize(mapload)
	. = ..()
	relink()

/obj/machinery/computer/nanite_chamber/Destroy()

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

/obj/machinery/computer/nanite_chamber/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

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
		.["hasOccupant"] = TRUE
		.["occupant"] = list(
			linked.occupant.name,
		)
	else
		.["hasOccupant"] = FALSE
	if(!isnull(linked.protean_core))
		.["hasProtean"] = TRUE
		.["protean"] = list(
			#warn impl
		)
	else
		.["hasProtean"] = FALSE
