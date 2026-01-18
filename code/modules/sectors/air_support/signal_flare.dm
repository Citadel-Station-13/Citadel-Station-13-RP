//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * signal flare used for orbital marking
 * TODO: impl destroying / quenching it without using guns
 */
/obj/item/signal_flare
	name = "signal flare"
	desc = "A specialized flare used for signalling. Burns at specific frequency and projects a signal visible from high altitudes."
	icon = 'icons/modules/sectors/air_support/signal_flare.dmi'
	icon_state = "flare"
	base_icon_state = "flare"

	var/ignited = FALSE
	var/ignited_at
	var/ready = FALSE
	var/spent = FALSE

	var/warmup_time = 20 SECONDS
	var/burn_time = 5 MINUTES

	var/ignite_light_color = "#77ff77"
	var/ignite_light_range = 4
	var/ignite_light_power = 0.35

	var/ready_light_color
	var/ready_light_range
	var/ready_light_power = 0.85

	/// Greyscale flame state used; this will be added twice, once with BLEND_ADD to make it
	/// actually look good.
	var/flame_state = "flare-flame"
	/// Non-blending flame color
	var/flame_color = "#aaccaa"
	/// BLEND_ADD'd copy color
	var/flame_base_color = "#00aa00"

/obj/item/signal_flare/update_icon()
	cut_overlays()
	. = ..()
	var/append
	if(ignited)
		append = "-active"
		var/image/flame = image(icon, flame_state)
		flame.color = flame_color
		flame.appearance_flags = KEEP_APART | RESET_COLOR
		var/image/flame_base = image(icon, flame_state)
		flame_base.color = flame_base_color
		flame_base.appearance_flags = KEEP_APART | RESET_COLOR
		flame_base.blend_mode = BLEND_ADD
		flame.overlays += flame_base
		add_overlay(flame)
	else if(spent)
		append = "-spent"
	icon_state = "[base_icon_state][append]"

/obj/item/signal_flare/on_attack_self(datum/event_args/actor/actor)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	// TODO: log
	#warn feedback
	ignite()

/obj/item/signal_flare/proc/ignite()
	if(ignited)
		return
	ignited = TRUE
	ignited_at = world.time
	update_icon()
	addtimer(CALLBACK(src, PROC_REF(ready)), warmup_time)
	addtimer(CALLBACK(src, PROC_REF(fizzle)), burn_time)
	set_light(
		ignite_light_range,
		ignite_light_power,
		ignite_light_color,
	)
	AddComponent(/datum/component/spatial_grid, SSspatial_grids.signal_flares)
	// TODO: sound

/obj/item/signal_flare/proc/ready()
	if(!ignited)
		return
	ready = TRUE
	update_icon()
	set_light(
		isnull(ready_light_range) ? ignite_light_range : ready_light_range,
		isnull(ready_light_power) ? ignite_light_power : ready_light_power,
		isnull(ready_light_color) ? ignite_light_color : ready_light_color,
	)
	visible_message(SPAN_WARNING("[src] flares up, now burning at its full intensity."))
	// TODO: sound

/obj/item/signal_flare/proc/fizzle()
	visible_message(SPAN_WARNING("[src] fizzles, having burnt itself out."))
	spent = TRUE
	ignited = FALSE
	ready = FALSE
	update_icon()
	// TODO: sound
