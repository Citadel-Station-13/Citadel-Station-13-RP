//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/firemode/sealant_gun
	cycle_cooldown = 0.4 SECONDS

/obj/item/gun/projectile/sealant_gun
	#warn name/desc
	icon = 'icons/items/misc/sealant_gun.dmi'
	icon_state = "gun"

	firemodes = list(
		/datum/firemode/sealant_gun
	)

	render_wielded = TRUE

	var/obj/item/sealant_tank/tank
	var/tank_insert_sound
	var/tank_remove_sound
	var/tank_insert_delay = 0
	var/tank_remove_delay = 0




#warn impl
