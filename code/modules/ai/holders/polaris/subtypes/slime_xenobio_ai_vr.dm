/datum/ai_holder/polaris/simple_mob/xenobio_slime/post_melee_attack(atom/A)
	var/mob/living/simple_mob/slime/xenobio/my_slime = holder
	my_slime.a_intent = INTENT_HELP		// Return back to help after attacking
