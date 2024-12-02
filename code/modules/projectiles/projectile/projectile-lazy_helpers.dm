//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * Imprint data from a clickchain
 *
 * Set 'use_firer' to not use the performer as the firer. This affects where the projectile raycasts from.
 */
/obj/projectile/proc/lazy_imprint_from_clickchain(datum/event_args/actor/clickchain/clickchain, clickchain_flags, atom/use_firer)
	clickchain.unpack_click_params()

	original_target = clickchain.target

	//! legacy
	firer = use_firer ? use_firer : clickchain.performer
	def_zone = clickchain.legacy_get_target_zone()
	p_x = clickchain.click_params_tile_px
	p_x = clickchain.click_params_tile_py
	//! end

	set_angle(clickchain.resolve_click_angle(use_firer))

/**
 * Fire from a clickchain
 *
 * Set 'use_firer' to not use the performer as the firer. This affects where the projectile raycasts from.
 */
/obj/projectile/proc/lazy_fire_from_clickchain(datum/event_args/actor/clickchain/clickchain, clickchain_flags, atom/use_firer)
	if(isnull(use_firer))
		use_firer = clickchain.performer
	lazy_imprint_from_clickchain(clickchain, clickchain_flags)
	fire()
