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
	/// currently active?
	var/toggle_enabled = FALSE

/obj/item/rig_module/basic

/obj/item/rig_module/basic/proc/handle_toggle(datum/event_args/actor/actor, from_console, intended_state)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/obj/item/rig_module/basic/proc/on_toggle(datum/event_args/actor/actor, from_console)
	SHOULD_NOT_SLEEP(TRUE)

/obj/item/rig_module/basic/proc/on_toggle_enabled(datum/event_args/actor/actor, from_console)
	SHOULD_NOT_SLEEP(TRUE)

/obj/item/rig_module/basic/proc/on_toggle_disabled(datum/event_args/actor/actor, from_console)
	SHOULD_NOT_SLEEP(TRUE)

/obj/item/rig_module/basic/proc/handle_trigger(datum/event_args/actor/actor, from_console)
	SHOULD_NOT_OVERRIDE(TRUE)
	SHOULD_NOT_SLEEP(TRUE)

/obj/item/rig_module/basic/proc/on_trigger(datum/event_args/actor/actor, from_console)
	SHOULD_NOT_SLEEP(TRUE)

/**
 * @return clickchain flags
 */
/obj/item/rig_module/basic/proc/handle_click(datum/event_args/actor/clickchain/clickchain, clickchain_flags, from_console)
	SHOULD_NOT_SLEEP(TRUE)
	if(lazy_on_click(clickchain.target, clickchain.performer, clickchain.using_intent, clickchain.target_zone, clickchain.attack_contact_multiplier, clickchain))
		return clickchain_flags | CLICKCHAIN_DID_SOMETHING
	. = clickchain_flags

/**
 * Lazy override for handle_click() that doesn't require you to understand how citrp's overengineered
 * clickchain system works.
 *
 * @return TRUE if handled
 */
/obj/item/rig_module/basic/proc/lazy_on_click(atom/target, mob/user, intent, zone, efficiency, datum/event_args/actor/actor)
	SHOULD_NOT_SLEEP(TRUE)

#warn impl

/obj/item/rig_module/basic/rig_static_data()
	. = ..()
	.["implToggle"] = impl_toggle
	.["implClick"] = impl_click
	.["implTrigger"] = impl_trigger

/obj/item/rig_module/basic/rig_data()
	. = ..()

/obj/item/rig_module/basic/rig_act(datum/event_args/actor/actor, control_flags, action, list/params)
	. = ..()
