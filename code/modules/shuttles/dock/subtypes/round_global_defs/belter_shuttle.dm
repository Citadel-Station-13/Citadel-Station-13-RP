//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2026 Citadel Station Developers           *//

DECLARE_SHUTTLE_FERRY_DOCK_GLOBAL_PAIR(belter_shuttle, /belter_shuttle, "Belter Shuttle")

/obj/shuttle_dock/ferry_pair/round_global/belter_shuttle
	ferry_init_kick_to_home = TRUE

/datum/shuttle_controller/ferry/round_global/belter_shuttle
	var/belter_rebuilding = FALSE
	var/datum/shuttle_hook/belter_rebuild_hook

/datum/shuttle_controller/ferry/round_global/belter_shuttle/Destroy()
	QDEL_NULL(belter_rebuild_hook)
	return ..()

/datum/shuttle_controller/ferry/round_global/belter_shuttle/proc/belter_start_rebuild()
	if(belter_rebuilding)
		return
	belter_rebuilding = TRUE
	if(!is_at_home())
		transit_towards_home(0 SECONDS)
		if(!is_at_home())
			stack_trace("belter didn't go home immediately on rebuild start.")
	if(!belter_rebuild_hook)
		belter_rebuild_hook = new /datum/shuttle_hook/belter_shuttle_rebuild_hook
		shuttle.register_hook(belter_rebuild_hook)

/datum/shuttle_controller/ferry/round_global/belter_shuttle/proc/belter_stop_rebuild()
	if(!belter_rebuilding)
		return
	belter_rebuilding = FALSE
	QDEL_NULL(belter_rebuild_hook)

/datum/shuttle_hook/belter_shuttle_rebuild_hook/on_event(datum/event_args/shuttle/event)
	var/datum/shuttle_operation/operation_to_block
	if(istype(event, /datum/event_args/shuttle/dock))
		var/datum/event_args/shuttle/dock/casted = event
		operation_to_block = casted.operation
	else if(istype(event, /datum/event_args/shuttle/traversal))
		var/datum/event_args/shuttle/traversal/casted = event
		operation_to_block = casted.operation

	new /datum/shuttle_operation_blocker(src, operation_to_block, "Belter shuttle rebuild in progress")
