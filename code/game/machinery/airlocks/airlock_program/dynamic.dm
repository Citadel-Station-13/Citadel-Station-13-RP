//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Default airlock program. Can handle quite a lot, but not everything.
 */
/datum/airlock_program/dynamic
	tgui_airlock_component = "Dynamic"

	/// inside air --> vent, instead of waste buffer
	/// * vacuum (non-curtain) mode only
	var/vacuum_vent_inside_air = FALSE
	/// outside air --> vent, instead of waste buffer
	/// * vacuum (non-curtain) mode only
	var/vacuum_vent_outside_air = TRUE

	/// curtain mode
	/// * turns off vacuum cycle, enables additional options
	/// * **always leaky**
	var/curtain_mode = TRUE

	/// * curtain mode only
	var/curtain_minimum_pressure = 0
	/// * curtain mode only
	var/curtain_maximum_pressure = ONE_ATMOSPHERE * 3
	/// scrub out these gases when going inside
	/// * curtain mode only
	var/curtain_scrubbing_ids
	/// scrub out these gases when going inside
	/// * curtain mode only
	var/curtain_scrubbing_groups
	/// vent cycling air instead of sending to scrubbing system
	/// * curtain mode only
	var/curtain_use_vent = TRUE

/datum/airlock_program/dynamic/ui_program_data()

/datum/airlock_program/dynamic/ui_program_act(datum/airlock_gasnet/network, datum/event_args/actor/actor, action, list/params)
	. = ..()
	if(.)
		return
	switch(action)
		if("confCurtainMode")
			if(ui_config_standard_reject(network, actor))
				return TRUE
		if("confVacuumVentInside")
			if(ui_config_standard_reject(network, actor))
				return TRUE
		if("confVacuumVentOutside")
			if(ui_config_standard_reject(network, actor))
				return TRUE
		if("confCurtainMinPressure")
			if(ui_config_standard_reject(network, actor))
				return TRUE
		if("confCurtainMaxPressure")
			if(ui_config_standard_reject(network, actor))
				return TRUE
			if(ui_config_standard_reject(network, actor))
				return TRUE
		if("confCurtainVent")
			if(ui_config_standard_reject(network, actor))
				return TRUE
		if("confCurtainScrubIdAdd")
			if(ui_config_standard_reject(network, actor))
				return TRUE
		if("confCurtainScrubIdRemove")
			if(ui_config_standard_reject(network, actor))
				return TRUE
		if("confCurtainScrubGroupAdd")
			if(ui_config_standard_reject(network, actor))
				return TRUE
		if("confCurtainScrubGroupRemove")
			if(ui_config_standard_reject(network, actor))
				return TRUE

/datum/airlock_program/dynamic/proc/ui_config_standard_reject(datum/airlock_gasnet/network, datum/event_args/actor/actor)
	#warn reject if operating

/datum/airlock_program/dynamic/tick_cycle(datum/airlock_cycle/cycle, datum/airlock_gasnet/network)
	if(curtain_mode)
		// curtain mode //
	else
		// vacuum mode //

#warn impl

#warn tgui
