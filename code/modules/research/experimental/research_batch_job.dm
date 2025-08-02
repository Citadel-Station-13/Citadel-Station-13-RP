//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * tasks able to be ran on a network's coprocessors
 */
/datum/research_batch_job
	/// name
	var/name = "???"

	/// requested compute amount
	var/compute_requested = 0
	/// scheduled compute amount
	var/compute_scheduled = 0
	/// active compute amount
	var/compute_active = 0
	/// coprocessors associated to amount used
	/// * lazy list
	var/list/obj/machinery/research_server/coprocessor/processors
	/// network we're processing in
	var/datum/research_network/network

	/// are we running?
	var/is_running = FALSE

/datum/research_batch_job/New(request_compute)
	src.compute_requested = request_compute

/datum/research_batch_job/Destroy()
	for(var/obj/machinery/research_server/coprocessor/processor in processors)
		remove_processor(processor)
	#warn interrupt?
	return ..()

#warn impl

/**
 * * Calling when already on processor will update it
 */
/datum/research_batch_job/proc/add_processor(obj/machinery/research_server/coprocessor/processor, amount)
	processor.add_batch_job(src, amount)

/datum/research_batch_job/proc/remove_processor(obj/machinery/research_server/coprocessor/processor)
	processor.remove_batch_job(src)

/**
 * @params
 * * work - work done in compute-seconds
 */
/datum/research_batch_job/proc/on_work_done(work)

/datum/research_batch_job/task
	/// work required in compute-seconds (world.time * compute * 0.1)
	var/work_needed = 0
	/// work completed
	var/work_completed = 0

/datum/research_batch_job/task/on_work_done(work)
	work_completed += work
	if(work_completed > work_needed)
		#warn finish

