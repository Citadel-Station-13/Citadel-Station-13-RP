//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/mortar_effect

/**
 * * This should never qdel() the mortar round, and optimally should not modify it either.
 *
 * @params
 * * epicenter - where we hit
 */
/datum/mortar_effect/proc/on_detonate(turf/epicenter)
	return

/datum/mortar_effect/legacy_explosion
	var/sev_1 = 0
	var/sev_2 = 0
	var/sev_3 = 0
	var/flash_range = 0

/datum/mortar_effect/legacy_explosion/on_detonate(turf/epicenter, obj/projectile/mortar/projectile)
	explosion(epicenter, sev_1, sev_2, sev_3, flash_range)

/datum/mortar_effect/legacy_emp
	var/sev_1 = 0
	var/sev_2 = 0
	var/sev_3 = 0
	var/sev_4 = 0

/datum/mortar_effect/legacy_emp/on_detonate(turf/epicenter, obj/projectile/mortar/projectile)
	empulse(epicenter, sev_1, sev_2, sev_3, sev_4)

/datum/mortar_effect/shrapnel
	var/pellet_count = 0
	var/pellet_type = /obj/projectile/bullet/pellet/fragment/strong

/datum/mortar_effect/shrapnel/on_detonate(turf/epicenter, obj/projectile/mortar/projectile)
	epicenter.shrapnel_explosion(pellet_count, 7, pellet_type)
