//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* Damage *//

/**
 * @return amount healed
 */
/mob/living/simple_mob/heal_brute_loss(amount)
	. = bruteloss
	bruteloss -= amount
	return . - bruteloss

/**
 * @return amount healed
 */
/mob/living/simple_mob/heal_burn_loss(amount)
	. = burnloss
	burnloss -= amount
	return . - burnloss
