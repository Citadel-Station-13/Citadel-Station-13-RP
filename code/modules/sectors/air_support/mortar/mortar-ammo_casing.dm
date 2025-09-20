//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * mortar rounds; uses ammo system
 */
/obj/item/ammo_casing/mortar
	name = "mortar shell"
	#warn sprite, icon, etc

	casing_caliber = /datum/ammo_caliber/mortar
	projectile_type = /obj/projectile/mortar

	/// sound to play pre-impact
	var/pre_impact_sound
	/// volume to play pre-impact
	/// * this will be modulated by impact distance
	var/pre_impact_volume = 75
	/// full volume range
	var/pre_impact_volume_inner_radius = 4
	/// no volume range
	var/pre_impact_volume_outer_radius = 16
	/// pre-impact sound duration
	var/pre_impact_sound_duration

/**
 * play pre-impact sound
 */
/obj/item/ammo_casing/mortar/proc/whzhzhhzhh(turf/epicenter)
	if(!pre_impact_sound)
		return
	#warn impl

#warn impl

/obj/item/ammo_casing/mortar/standard
	casing_caliber = /datum/ammo_caliber/mortar
