//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* Raw Damage *//

/mob/living/silicon/robot/drone/take_overall_damage(brute, burn, damage_mode, weapon_descriptor, defer_updates)
	// for now, we don't do anything other than give raw damage as drones don't simulate like robots do
	bruteloss += brute
	fireloss += burn
	if(!defer_updates)
		update_health()
	return brute + burn

/mob/living/silicon/robot/drone/take_targeted_damage(brute, burn, damage_mode, body_zone, weapon_descriptor, defer_updates)
	return take_overall_damage(brute, burn, damage_mode, weapon_descriptor, defer_updates)
