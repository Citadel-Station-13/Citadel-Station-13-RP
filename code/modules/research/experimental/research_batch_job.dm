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
	/// active compute amount
	var/compute_active = 0
	/// coprocessors associated to amount used
	/// * lazy list
	var/list/obj/machinery/research_server/coprocessor/processors
	/// network we're processing in
	var/datum/research_network/network

	/// work required in compute-seconds (world.time * compute * 0.1)
	var/work = 0
	/// work completed
	var/work_completed = 0

	/// are we running?
	var/is_running = FALSE

/datum/research_batch_job/New(request_compute)
	src.compute_requested = request_compute

/datum/research_batch_job/Destroy()

	return ..()
