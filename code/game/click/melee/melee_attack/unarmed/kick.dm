/datum/melee_attack/unarmed/kick
	verb_past_participle = list("kicked")
	attack_verb_legacy = list("kicked", "kicked", "kicked", "kneed")
	attack_noun = list("kick", "kick", "kick", "knee strike")
	attack_sound = "swing_hit"
	attack_name = "kick"

/datum/melee_attack/unarmed/kick/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)
	if (user.legcuffed)
		return FALSE

	if(!(zone in list("l_leg", "r_leg", "l_foot", "r_foot", BP_GROIN)))
		return FALSE

	var/obj/item/organ/external/E = user.organs_by_name["l_foot"]
	if(E && !E.is_stump())
		return TRUE

	E = user.organs_by_name["r_foot"]
	if(E && !E.is_stump())
		return TRUE

	return FALSE

/datum/melee_attack/unarmed/kick/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/datum/gender/TT = GLOB.gender_datums[target.get_visible_gender()]
	var/organ = affecting.name

	attack_damage = clamp(attack_damage - 5, 1, 5)

	switch(attack_damage)
		if(1 to 2)	user.visible_message("<span class='danger'>[user] threw [target] a glancing [pick(attack_noun)] to the [organ]!</span>") //it's not that they're kicking lightly, it's that the kick didn't quite connect
		if(3 to 4)	user.visible_message("<span class='danger'>[user] [pick(attack_verb_legacy)] [target] in [TT.his] [organ]!</span>")
		if(5)		user.visible_message("<span class='danger'>[user] landed a strong [pick(attack_noun)] against [target]'s [organ]!</span>")
