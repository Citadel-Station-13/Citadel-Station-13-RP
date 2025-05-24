/datum/melee_attack/unarmed/slime_glomp
	attack_verb_legacy = list("glomped")
	attack_noun = list("body")
	attack_name = "glomp"

/datum/melee_attack/unarmed/slime_glomp/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/armour,var/attack_damage,var/zone)
	..()
	// user.apply_stored_shock_to(target)
