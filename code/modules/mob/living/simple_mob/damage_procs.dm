//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

//* Damage *//

/mob/living/simple_mob/heal_brute_loss(amount)
	amount = min(amount, bruteloss)
	. = bruteloss
	bruteloss -= amount
	return . - bruteloss

/mob/living/simple_mob/heal_fire_loss(amount)
	amount = min(amount, fireloss)
	. = fireloss
	fireloss -= amount
	return . - fireloss

/mob/living/simple_mob/heal_tox_loss(amount)
	amount = min(amount, toxloss)
	. = toxloss
	toxloss -= amount
	return . - toxloss

/mob/living/simple_mob/heal_oxy_loss(amount)
	amount = min(amount, oxyloss)
	. = oxyloss
	oxyloss -= amount
	return . - oxyloss
