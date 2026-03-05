//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

/obj/item/airlock_component/interface/shuttle
	name = /obj/machinery/airlock_component/interface/shuttle::name + " (detached)"
	desc = /obj/machinery/airlock_component/interface/shuttle::desc
	machine_type = /obj/machinery/airlock_component/interface/shuttle
	icon = /obj/machinery/airlock_component/interface/shuttle::icon
	icon_state = /obj/machinery/airlock_component/interface/shuttle::icon_state
	base_icon_state = /obj/machinery/airlock_component/interface/shuttle::base_icon_state

#warn impl all

/**
 * Interface entity; allows airlocks to be controlled by external factors, like docking.
 */
/obj/machinery/airlock_component/interface/shuttle
	abstract_type = /obj/machinery/airlock_component/interface/shuttle
	name = "airlock shuttle interface"
	desc = "An adapter for an airlock that integrates it with.. nothing, actually, because this shouldn't exist."

	detached_item_type = /obj/item/airlock_component/interface/shuttle

/obj/machinery/airlock_component/interface/shuttle/proc/handle_event(datum/event_args/shuttle/dock/event)

#warn impl all

/obj/machinery/airlock_component/interface/shuttle/port
	var/obj/shuttle_port/bound_port
	var/bind_range = 0


/obj/machinery/airlock_component/interface/shuttle/port/Initialize(mapload, set_dir, obj/item/airlock_component/interface/shuttle/port/from_item)
	. = ..()

/obj/machinery/airlock_component/interface/shuttle/port/Destroy()
	return ..()

/obj/machinery/airlock_component/interface/shuttle/port/proc/bind(obj/shuttle_port/port)

/obj/machinery/airlock_component/interface/shuttle/port/proc/unbind()

/obj/machinery/airlock_component/interface/shuttle/port/proc/detect_port_To_bind() as /obj/shuttle_port

/obj/machinery/airlock_component/interface/shuttle/port/proc/rebind()

/obj/machinery/airlock_component/interface/shuttle/port/Moved(atom/old_loc, direction, forced, list/old_locs, momentum_change)
	..()
	addtimer(CALLBACK(src, PROC_REF(rebind)), 0, TIMER_UNIQUE)

/obj/machinery/airlock_component/interface/shuttle/port/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	hardmapped = TRUE

/obj/machinery/airlock_component/interface/shuttle/dock
	var/obj/shuttle_dock/bound_dock
	var/bind_range = 0

/obj/machinery/airlock_component/interface/shuttle/dock/Initialize(mapload, set_dir, obj/item/airlock_component/interface/shuttle/dock/from_item)
	. = ..()

/obj/machinery/airlock_component/interface/shuttle/dock/Destroy()
	return ..()

/obj/machinery/airlock_component/interface/shuttle/dock/proc/bind(obj/shuttle_dock/dock)

/obj/machinery/airlock_component/interface/shuttle/dock/proc/unbind()

/obj/machinery/airlock_component/interface/shuttle/dock/proc/detect_dock_To_bind() as /obj/shuttle_dock

/obj/machinery/airlock_component/interface/shuttle/dock/proc/rebind()

/obj/machinery/airlock_component/interface/shuttle/dock/Moved(atom/old_loc, direction, forced, list/old_locs, momentum_change)
	..()
	addtimer(CALLBACK(src, PROC_REF(rebind)), 0, TIMER_UNIQUE)

/obj/machinery/airlock_component/interface/shuttle/dock/hardmapped
	integrity_flags = INTEGRITY_INDESTRUCTIBLE
	hardmapped = TRUE
