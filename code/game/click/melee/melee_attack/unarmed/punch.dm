/datum/melee_attack/unarmed/punch
	attack_name = "punch"
	verb_past_participle = list("punched")
	attack_verb_legacy = list("punched")
	attack_noun = list("fist")
	eye_attack_text = "fingers"
	eye_attack_text_victim = "digits"

/datum/melee_attack/unarmed/punch/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/organ = affecting.name

	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]
	var/datum/gender/TT = GLOB.gender_datums[target.get_visible_gender()]

	attack_damage = clamp(attack_damage - 5, 1, 5) // We expect damage input of 1 to 5 for this proc. But we leave this check juuust in case.

	if(target == user)
		user.visible_message("<span class='danger'>[user] [pick(attack_verb_legacy)] [TU.himself] in the [organ]!</span>")
		return 0

	if(!target.lying)
		switch(zone)
			if(BP_HEAD, O_MOUTH, O_EYES)
				// ----- HEAD ----- //
				switch(attack_damage)
					if(1 to 2)
						user.visible_message("<span class='danger'>[user] slapped [target] across [TT.his] cheek!</span>")
					if(3 to 4)
						user.visible_message(pick(
							40; "<span class='danger'>[user] [pick(attack_verb_legacy)] [target] in the head!</span>",
							30; "<span class='danger'>[user] struck [target] in the head[pick("", " with a closed fist")]!</span>",
							30; "<span class='danger'>[user] threw a hook against [target]'s head!</span>"
							))
					if(5)
						user.visible_message(pick(
							30; "<span class='danger'>[user] gave [target] a resounding [pick("slap", "punch")] to the face!</span>",
							40; "<span class='danger'>[user] smashed [TU.his] [pick(attack_noun)] into [target]'s face!</span>",
							30; "<span class='danger'>[user] gave a strong blow against [target]'s jaw!</span>"
							))
			else
				// ----- BODY ----- //
				switch(attack_damage)
					if(1 to 2)	user.visible_message("<span class='danger'>[user] threw a glancing punch at [target]'s [organ]!</span>")
					if(1 to 4)	user.visible_message("<span class='danger'>[user] [pick(attack_verb_legacy)] [target] in [TT.his] [organ]!</span>")
					if(5)
						user.visible_message(pick(
							50; "<span class='danger'>[user] smashed [TU.his] [pick(attack_noun)] into [target]'s [organ]!</span>",
							50; "<span class='danger'>[user] landed a striking [pick(attack_noun)] on [target]'s [organ]!</span>"
							))
	else
		user.visible_message("<span class='danger'>[user] [pick("punched", "threw a punch against", "struck", "slammed [TU.his] [pick(attack_noun)] into")] [target]'s [organ]!</span>") //why do we have a separate set of verbs for lying targets?
