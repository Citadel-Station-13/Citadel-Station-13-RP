//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/projectile_effect/detonation/legacy_emp
	var/sev_1
	var/sev_2
	var/sev_3
	var/sev_4

/datum/projectile_effect/detonation/legacy_emp/detonation(turf/where)
	empulse(where, sev_1, sev_2, sev_3, sev_4)
