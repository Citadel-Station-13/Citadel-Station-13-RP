//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* Damage *//

/mob/living/simple_mob/heal_brute_loss(amount)
	. = bruteloss
	bruteloss -= amount
	return . - bruteloss

/mob/living/simple_mob/heal_fire_loss(amount)
	. = fireloss
	fireloss -= amount
	return . - fireloss

/mob/living/simple_mob/heal_tox_loss(amount)
	. = toxloss
	toxloss -= amount
	return . - toxloss

/mob/living/simple_mob/heal_oxy_loss(amount)
	. = oxyloss
	oxyloss -= amount
	return . - oxyloss
