//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/**
 * NT Protomag calibers.
 *
 * These share specifications with NT Expeditionary calibers, and are cross compatible.
 */
/datum/ammo_caliber/nt_protomag
	caliber = "nt-protomag"
	diameter = /datum/ammo_caliber/nt_expedition/heavy_rifle::diameter
	length = /datum/ammo_caliber/nt_expedition/heavy_rifle::length

/datum/ammo_caliber/nt_protomag/antimaterial
	caliber = "nt-protomag-antimaterial"
	diameter = /datum/ammo_caliber/nt_expedition/antimaterial::diameter
	length = /datum/ammo_caliber/nt_expedition/antimaterial::length
