//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * signal flare used for orbital marking
 * TODO: impl destroying / quenching it without using guns
 */
/obj/item/signal_flare
	name = "signal flare"
	desc = "A specialized flare used for signalling. Burns at specific frequency and projects a signal visible from high altitudes."
	#warn sprite

	var/ignited = FALSE
	var/ignited_at

	var/ready = FALSE

	var/warmup_time = 20 SECONDS
	var/burn_time = 5 MINUTES

	var/ignite_light_color = "#77ff77"
	var/ignite_light_range = 4
	var/ignite_light_power = 0.35

	var/ready_light_color
	var/ready_light_range
	var/ready_light_power = 0.85

/obj/item/signal_flare/proc/ignite()
	if(ignited)
		return
	ignited = TRUE
	ignited_at = world.time
	addtimer(CALLBACK(src, PROC_REF(ready)), warmup_time)
	addtimer(CALLBACK(src, PROC_REF(fizzle)), burn_time)
	set_light(
		ignite_light_range,
		ignite_light_power,
		ignite_light_color,
	)
	AddComponent(/datum/component/spatial_grid, SSspatial_grids.signal_flares)

/obj/item/signal_flare/proc/ready()
	if(!ignited)
		return
	ready = TRUE
	set_light(
		isnull(ready_light_range) ? ignite_light_range : ready_light_range,
		isnull(ready_light_power) ? ignite_light_power : ready_light_power,
		isnull(ready_light_color) ? ignite_light_color : ready_light_color,
	)
	visible_message("[src] flares up, now burning at its full intensity.")

/obj/item/signal_flare/proc/fizzle()
	visible_message("[src] fizzles, having burnt itself out.")
	qdel(src)
