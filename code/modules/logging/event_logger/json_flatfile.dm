//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/world_event_logger/json_flatfile
	var/version = "0.0.1"

	var/log__gun_firing_cycle

/datum/world_event_logger/json_flatfile/setup_logger(log_directory)
	for(var/varname in vars)
		if(copytext(varname, 1, 6) == "log__")
			var/path = "[log_directory]/event_logger/[copytext(varname, 6)].txt"
			vars[varname] = path
			start_log(path)
			WRITE_LOG(path, "## header-version: [version]")

/datum/world_event_logger/json_flatfile/shutdown_logger()
	// rustg_log_close_all deals with our logs

/datum/world_event_logger/json_flatfile/log__gun_firing_cycle(obj/item/gun, datum/gun_firing_cycle/cycle)
	. = list(
		"time" = cycle.cycle_start_time,
		"ref_gun" = ref(gun),
		"ref_firer" = ref(cycle.firing_atom),
		"ref_initiator" = ref(cycle.firing_actor.initiator),
		"ref_performer" = ref(cycle.firing_actor.performer),
		"ref_target" = ref(cycle.original_target),
		"angle" = cycle.original_angle,
		"iterations" = cycle.firing_iterations,
		"iterations_fired" = cycle.cycle_iterations_fired,
		"firemode_name" = cycle.firemode.name,
		"flags" = cycle.firing_flags,
		"result_last" = cycle.last_firing_result,
	)
	WRITE_LOG(log__gun_firing_cycle, json_encode(.))
