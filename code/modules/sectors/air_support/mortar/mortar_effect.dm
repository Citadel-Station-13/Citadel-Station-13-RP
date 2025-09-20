//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * @params
 * * epicenter - where we hit
 * * projectile - (optional) if we were simmed via projectile, this is the projectile
 */
/datum/mortar_effect

/datum/mortar_effect/proc/on_detonate(turf/epicenter, obj/projectile/mortar/projectile)

/datum/mortar_effect/legacy_explosion
	var/sev_1 = 0
	var/sev_2 = 0
	var/sev_3 = 0

/datum/mortar_effect/legacy_explosion/on_detonate(turf/epicenter, obj/projectile/mortar/projectile)

/datum/mortar_effect/legacy_emp
	var/sev_1 = 0
	var/sev_2 = 0
	var/sev_3 = 0
	var/sev_4 = 0

/datum/mortar_effect/legacy_emp/on_detonate(turf/epicenter, obj/projectile/mortar/projectile)

/datum/mortar_effect/shrapnel
	var/pellet_count = 0
	var/pellet_type = /obj/projectile/bullet/pellet/fragment/strong

/datum/mortar_effect/shrapnel/on_detonate(turf/epicenter, obj/projectile/mortar/projectile)
	#warn impl
