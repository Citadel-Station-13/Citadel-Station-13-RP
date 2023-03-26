#warn impl

/obj/machinery/computer/nanite_chamber

	idle_power_usage = POWER_USAGE_COMPUTER_MID_IDLE
	active_power_usage = POWER_USAGE_COMPUTER_MID_ACTIVE

	/// linked chamber
	var/obj/machinery/nanite_chamber/linked

/obj/machinery/computer/nanite_chamber/Initialize(mapload)
	. = ..()

/obj/machinery/computer/nanite_chamber/Destroy()

	return ..()

/obj/machinery/computer/nanite_chamber/proc/link_chamber(obj/machinery/nanite_chamber/chamber)

/obj/machinery/computer/nanite_chamber/proc/unlink_chamber()

/obj/machinery/computer/nanite_chamber/proc/relink()

/obj/machinery/computer/nanite_chamber/proc/nearby_chamber()
	RETURN_TYPE(/obj/machinery/nanite_chamber/chamber)
	return locate(/obj/machinery/nanite_chamber) in orange(1, src)

/obj/machinery/computer/nanite_chamber/ui_act(action, list/params, datum/tgui/ui)
	. = ..()

/obj/machinery/computer/nanite_chamber/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/obj/machinery/computer/nanite_chamber/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

