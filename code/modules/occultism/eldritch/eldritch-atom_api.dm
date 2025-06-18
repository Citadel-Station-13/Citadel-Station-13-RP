//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/atom/proc/eldritch_apply_rust(amount, instant_act_ratio = 0.2)
	var/datum/component/eldritch_rust/rust = LoadComponent(/datum/component/eldritch_rust)
	rust.add_rust(amount * (1 - instant_act_ratio))
	eldritch_rust_act(amount * instant_act_ratio)
	return amount

/atom/proc/eldritch_remove_rust(amount)
	var/datum/component/eldritch_rust/rust = GetComponent(/datum/component/eldritch_rust)
	if(!rust)
		return 0
	return rust.remove_rust(amount)

/atom/proc/eldritch_clear_rust()
	var/datum/component/eldritch_rust/rust = GetComponent(/datum/component/eldritch_rust)
	if(!rust)
		return 0
	. = rust.amount
	qdel(rust)

#warn impl on things
/atom/proc/eldritch_rust_act(amount)
	return

/atom/proc/eldritch_apply_rust_shielding(amount)
	var/datum/component/eldritch_rust_shielding/component = LoadComponent(/datum/component/eldritch_rust_shielding)
	return component.add_rust(amount)

/atom/proc/eldritch_remove_rust_shielding(amount)
	var/datum/component/eldritch_rust_shielding/component = LoadComponent(/datum/component/eldritch_rust_shielding)
	return component.remove_rust(amount)
