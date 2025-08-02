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
	/// total used compute
	var/compute_used = 0
	/// batch jobs on this associated to compute usage
	/// * lazy list
	var/list/datum/research_batch_job/compute_active

/obj/machinery/research_server/coprocessor/proc/add_batch_job(datum/research_batch_job/job, usage)
	if(compute_active[job])
		remove_batch_job(job)
	compute_active[job] = usage
	compute_used += usage

/obj/machinery/research_server/coprocessor/proc/remove_batch_job(datum/research_batch_job/job)
	compute_used -= compute_active[job]
	compute_active -= job

#warn impl

/obj/machinery/research_server/coprocessor/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "machines/research/server/ResearchCoprocessorServer")
		ui.set_autoupdate(FALSE)
		ui.open()

/obj/machinery/research_server/coprocessor/ui_data(mob/user, datum/tgui/ui)
	. = ..()
	.["cpuCapacity"] = compute_capacity
	.["cpuUsed"] = compute_used
	var/list/serialized_jobs = list()
	for(var/datum/research_batch_job/job as anything in compute_active)
		var/job_usage = compute_active[job]
		serialized_jobs[++serialized_jobs.len] = list(
			"name" = job.name,
			"load" = job_usage,
		)
	.["jobs"] = serialized_jobs

/obj/machinery/research_server/coprocessor/on_leave_network(datum/research_network/network)
	..()
	#warn evict jobs

/obj/machinery/research_server/coprocessor/proc/set_compute_capacity(capacity)
	src.compute_capacity = capacity
	#warn inform network
