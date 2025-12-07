//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/directional_shield_config
	var/datum/directional_shield_pattern/pattern

	//* these are only used for standalone *//

	var/health = 200
	var/health_max = 200
	var/color_depleted = "#770000"
	var/color_full = "#33cccc"

	//* these are only used for self-recharging *//

	var/recharge_delay = 5 SECONDS
	var/recharge_rate = 10
	var/recharge_ignore_gradual = TRUE
	var/recharge_rebuild_rate = 20
	var/recharge_rebuild_restore_ratio = 1

/datum/directional_shield_config/New()
	if(ispath(pattern) || IS_ANONYMOUS_TYPEPATH(pattern))
		pattern = new pattern

/datum/directional_shield_config/Destroy()
	// shields may still be using this
	pattern = null
	return ..()
