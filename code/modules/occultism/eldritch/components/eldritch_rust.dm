//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * dynamic eldritch rust component
 *
 * * 100 strength is the standard, and will cause Problems for like, a minute or two at most
 */
/datum/component/eldritch_rust
	var/amount = 0

	/// tick chance per second
	var/tick_chance = 10
	var/tick_ratio_low = 0.02
	var/tick_ratio_high = 0.10

/datum/component/eldritch_rust/Initialize(strength)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return

/datum/component/eldritch_rust/RegisterWithParent()
	START_PROCESSING(SSobj, src)

/datum/component/eldritch_rust/UnregisterFromParent()
	STOP_PROCESSING(SSobj, src)

#warn impl vfx

/datum/component/eldritch_rust/proc/add_rust(amount)
	. = amount
	src.amount += amount

/datum/component/eldritch_rust/proc/remove_rust(amount)
	. = min(src.amount, amount)
	src.amount -= .
	if(!src.amount)
		addtimer(CALLBACK(src, PROC_REF(check_delete)), 0)

/datum/component/eldritch_rust/proc/check_delete()
	if(!amount)
		qdel(src)

/datum/component/eldritch_rust/proc/inflict_rust_to_parent(amount)
	var/atom/atom_parent = parent
	atom_parent.eldritch_rust_act(remove_rust(amount))

/datum/component/eldritch_rust/process(delta_time)
	// not perfect.
	if(!prob(tick_chance * delta_time))
		return
	inflict_rust_to_parent(amount * rand(tick_ratio_low * 100, tick_ratio_high * 100) * 0.01)
