/datum/melee_attack/unarmed/bite
	verb_past_participle = list("bitten")
	attack_verb_legacy = list("bit")
	attack_sound = 'sound/weapons/bite.ogg'
	damage = 3
	damage_mode = NONE
	attack_name = "bite"

/datum/melee_attack/unarmed/bite/is_usable(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone)

	if (user.is_muzzled())
		return 0
	if (user == target && (zone == BP_HEAD || zone == O_EYES || zone == O_MOUTH))
		return 0
	return TRUE

/datum/melee_attack/unarmed/bite/strong
	verb_past_participle = list("mauled")
	attack_verb_legacy = list("mauled")
	damage = 12.5
	damage_mode = DAMAGE_MODE_SHRED | DAMAGE_MODE_SHARP
	attack_name = "strong bite"

/datum/melee_attack/unarmed/bite/strong/xeno
	damage = 17
	damage_tier = 3

/datum/melee_attack/unarmed/bite/sharp //eye teeth
	verb_past_participle = list("bit")
	attack_verb_legacy = list("bit", "chomped on")
	attack_sound = 'sound/weapons/bite.ogg'
	damage_mode = DAMAGE_MODE_SHARP | DAMAGE_MODE_EDGE
	attack_name = "sharp bite"

/datum/melee_attack/unarmed/bite/sharp/numbing //Is using this against someone you are truly trying to fight a bad idea? Yes. Yes it is.
	attack_verb_legacy = list("bit")
	attack_noun = list("fangs")
	attack_sound = 'sound/weapons/bite.ogg'
	damage_mode = DAMAGE_MODE_SHARP
	attack_name = "numbing bite"

/datum/melee_attack/unarmed/bite/sharp/numbing/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)

	attack_damage = clamp(attack_damage, 1, 5)
	if(target == user)
		user.visible_message("<span class='danger'>[user] [pick(attack_verb_legacy)] \himself in the [affecting.name]!</span>")
		return 0 //No venom for you.
	switch(zone)
		if(BP_HEAD, O_MOUTH, O_EYES)
			// ----- HEAD ----- //
			switch(attack_damage)
				if(1 to 2)
					user.visible_message("<span class='danger'>[user]'s fangs scrape across [target]'s cheek!</span>")
					to_chat(target, "<font color='red'><b>Your face feels tingly!</b></font>")
					target.bloodstr.add_reagent("numbenzyme",attack_damage) //Have to add this here, otherwise the swtich fails.
				if(3 to 4)
					user.visible_message("<span class='danger'>[user]'s fangs pierce into [target]'s neck at an odd, awkward angle!</span>")
					to_chat(target, "<font color='red'><b>Your neck feels like it's on fire before going numb!</b></font>")
					target.bloodstr.add_reagent("numbenzyme",attack_damage)
				if(5)
					user.visible_message("<span class='danger'>[user] sinks \his [pick(attack_noun)] <b><i>deep</i></b> into [target]'s neck, causing the vein to bulge outwards at some type of chemical is pumped into it!</span>")
					to_chat(target, "<font color='red'><b>Your neck feels like it's going to burst! Moments later, you simply can't feel your neck any longer, the numbness beginning to spread throughout your body!</b></font>")
					target.bloodstr.add_reagent("numbenzyme",attack_damage)
		else
			// ----- BODY ----- //
			switch(attack_damage)
				if(1 to 2)
					user.visible_message("<span class='danger'>[user]'s fangs scrape across [target]'s [affecting.name]!</span>")
					to_chat(target, "<font color='red'><b>Your [affecting.name] feels tingly!</b></font>")
					target.bloodstr.add_reagent("numbenzyme",attack_damage)
				if(3 to 4)
					user.visible_message("<span class='danger'>[user]'s fangs pierce [pick("", "", "the side of")] [target]'s [affecting.name]!</span>")
					to_chat(target, "<font color='red'><b>Your [affecting.name] feels like it's on fire before going numb!</b></font>")
					target.bloodstr.add_reagent("numbenzyme",attack_damage)
				if(5)
					user.visible_message("<span class='danger'>[user]'s fangs sink deep into [target]'s [affecting.name], one of their veins bulging outwards from the sudden fluid pumped into it!</span>")
					to_chat(target, "<font color='red'><b>Your [affecting.name] feels like it's going to burst! Moments later, you simply can't feel your [affecting.name] any longer, the numbness slowly spreading throughout your body!</b></font>")
					target.bloodstr.add_reagent("numbenzyme",attack_damage)

/datum/melee_attack/unarmed/bite/sharp/shadekin
	var/energy_gain = 3

/datum/melee_attack/unarmed/bite/sharp/shadekin/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	..()
	user.shadekin_adjust_energy(energy_gain)

//Traits attack
/datum/melee_attack/unarmed/bite/sharp/good
	damage = 10

/datum/melee_attack/unarmed/bite/sharp/good/venom

/datum/melee_attack/unarmed/bite/sharp/good/venom/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	..()
	if(target.can_inject(null,FALSE,zone,FALSE))
		target.bloodstr.add_reagent("toxin",2) //8 extra damage per hit over time
