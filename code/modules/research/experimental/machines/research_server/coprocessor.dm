//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/machinery/research_server/coprocessor
	name = "research coprocessing server"
	desc = "A coprocessing unit that can be connected to a research network to provide available compute."
	// TODO: NEW SPRITE PLEASE
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "server"

	/// available compute
	var/compute_capacity = 20
	/// total scheduled compute
	var/compute_scheduled = 0
	/// batch jobs on this associated to compute usage
	/// * lazy list
	var/list/datum/research_batch_job/compute_active

/obj/machinery/research_server/coprocessor/proc/add_batch_job(datum/research_batch_job/job, usage)
	if(compute_active[job])
		remove_batch_job(job)
	compute_active[job] = usage
	compute_scheduled += usage

/obj/machinery/research_server/coprocessor/proc/remove_batch_job(datum/research_batch_job/job)
	compute_scheduled -= compute_active[job]
	compute_active -= job

/obj/machinery/research_server/coprocessor/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "machines/research/server/ResearchCoprocessorServer")
		ui.set_autoupdate(FALSE)
		ui.open()

/obj/machinery/research_server/coprocessor/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["cpuCapacity"] = compute_capacity
	.["cpuScheduled"] = compute_scheduled
	var/list/serialized_jobs = list()
	for(var/datum/research_batch_job/job as anything in compute_active)
		var/job_usage = compute_active[job]
		serialized_jobs[++serialized_jobs.len] = list(
			"name" = job.name,
			"load" = job_usage,
		)
	.["jobs"] = serialized_jobs

/obj/machinery/research_server/coprocessor/on_connection_inactive(datum/research_network_connection/conn)
	..()
	for(var/datum/research_batch_job/job in compute_active)
		job.remove_processor(src)

/obj/machinery/research_server/coprocessor/proc/set_compute_capacity(capacity)
	capacity = max(0, capacity)
	src.compute_capacity = capacity
	while(compute_scheduled > compute_capacity)
		if(!length(compute_active))
			stack_trace("no compute active yet scheduled above capacity?")
			break
		var/datum/research_batch_job/popping = compute_active[length(compute_active)]
		popping.remove_processor(src)
