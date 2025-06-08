/datum/melee_attack/unarmed/stomp
	attack_name = "stomp"

/datum/melee_attack/unarmed/stomp/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)

	if (user.legcuffed)
		return FALSE

	if(!istype(target))
		return FALSE

	if (!user.lying && (target.lying || (zone in list("l_foot", "r_foot"))))
		if(target.grabbed_by == user && target.lying)
			return FALSE
		var/obj/item/organ/external/E = user.organs_by_name["l_foot"]
		if(E && !E.is_stump())
			return TRUE

		E = user.organs_by_name["r_foot"]
		if(E && !E.is_stump())
			return TRUE

		return FALSE

/datum/melee_attack/unarmed/stomp/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/organ = affecting.name
	var/obj/item/clothing/shoes = user.shoes
	var/datum/gender/TU = GLOB.gender_datums[user.get_visible_gender()]

	attack_damage = clamp(attack_damage - 5, 1, 5)

	switch(attack_damage)
		if(1 to 4)	user.visible_message("<span class='danger'>[pick("[user] stomped on", "[user] slammed [TU.his] [shoes ? copytext(shoes.name, 1, -1) : "foot"] down onto")] [target]'s [organ]!</span>")
		if(5)		user.visible_message("<span class='danger'>[pick("[user] landed a powerful stomp on", "[user] stomped down hard on", "[user] slammed [TU.his] [shoes ? copytext(shoes.name, 1, -1) : "foot"] down hard onto")] [target]'s [organ]!</span>") //Devastated lol. No. We want to say that the stomp was powerful or forceful, not that it /wrought devastation/

/datum/melee_attack/unarmed/stomp/weak
	attack_verb_legacy = list("jumped on")
	attack_name = "weak stomp"

/datum/melee_attack/unarmed/stomp/weak/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	user.visible_message("<span class='warning'>[user] jumped up and down on \the [target]'s [affecting.name]!</span>")
	playsound(user.loc, attack_sound, 25, 1, -1)
