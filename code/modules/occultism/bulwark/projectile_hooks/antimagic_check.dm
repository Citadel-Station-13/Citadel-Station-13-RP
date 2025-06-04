//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/projectile_hook/antimagic_check
	hook_impact = TRUE

	/// magic potency of projectile
	var/magic_potency = MAGIC_POTENCY_BASELINE
	/// magic type of projectile
	var/magic_type = MAGIC_TYPE_GENERIC
	/// magic data of projectile
	var/list/magic_data

	/// potency of block required to entirely delete projectile; defaults to [magic_potency]
	var/threshold_delete

/datum/projectile_hook/antimagic_check/on_impact(list/impact_args)
	#warn impl
