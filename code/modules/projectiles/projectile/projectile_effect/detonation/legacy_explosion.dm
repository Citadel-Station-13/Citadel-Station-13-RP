//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/projectile_effect/detonation/legacy_explosion
	var/sev_1
	var/sev_2
	var/sev_3

/datum/projectile_effect/detonation/legacy_explosion/detonation(turf/where)
	explosion(where, sev_1, sev_2, sev_3)
