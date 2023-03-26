#warn impl

/obj/machinery/nanite_chamber

	idle_power_usage = POWER_USAGE_NANITE_CHAMBER_IDLE
	active_power_usage = POWER_USAGE_NANITE_CHAMBER_ACTIVE

	/// linked computer
	var/obj/machinery/computer/nanite_chamber/linked

	/// opened?
	var/open = FALSE
	/// occupant person
	var/mob/living/occupant
	/// occupant nanoswarm brain
	var/obj/item/mmi/digital/posibrain/nano/protean_core

/obj/machinery/nanite_chamber/Initialize(mapload)
	. = ..()

/obj/machinery/nanite_chamber/Destroy()

	return ..()

/obj/machinery/nanite_chamber/Moved(atom/old_loc, direction, forced)
	. = ..()

/obj/machinery/nanite_chamber/proc/reassert_connection()

/obj/machinery/nanite_chamber/proc/detect_connection()
