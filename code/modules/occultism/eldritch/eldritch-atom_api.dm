//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/atom/proc/eldritch_rust_shielding_add(amount)
	var/datum/component/eldritch_rust_shielding/component = LoadComponent(/datum/component/eldritch_rust_shielding)
	return component.add_rust(amount)

/atom/proc/eldritch_rust_shielding_use(amount)
	var/datum/component/eldritch_rust_shielding/component = LoadComponent(/datum/component/eldritch_rust_shielding)
	return component.remove_rust(amount)
