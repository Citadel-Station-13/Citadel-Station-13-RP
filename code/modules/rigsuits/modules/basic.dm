//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * straight ports of old modules
 */
/obj/item/rig_module/basic
	tgui_interface = "Basic"

	/// if set, device can be toggled
	/// * toggle triggers on_toggle(), on_toggle_enabled(), on_toggle_disabled()
	var/impl_toggle = FALSE
	/// if set, device can be selected for use with click
	/// * click triggers on_click()
	var/impl_click = FALSE
	/// if set, device can be activated
	/// * activation triggers on_trigger()
	var/impl_trigger = FALSE

	/// power use when triggered in joules
	var/trigger_power_cost
	/// cooldown between triggers
	var/trigger_cooldown = 1 SECONDS
	/// next world.time we can be triggered
	var/trigger_next_time

	/// power use per second when toggled on
	var/toggle_active_power_cost
	/// delay for toggling
	var/toggle_cooldown = 0.5 SECONDS
	/// delay for toggling off
	/// * if set to non-null, overrides [toggle_cooldown] for trying to turn off after turning on
	var/toggle_cooldown_for_disable
	/// next world.time we can be toggled
	var/toggle_next_time



#warn impl
