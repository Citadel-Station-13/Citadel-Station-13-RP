/datum/unarmed_attack/bite/sharp //eye teeth
	attack_verb = list("bit", "chomped on")
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = 0
	sharp = 1
	edge = 1

/datum/unarmed_attack/diona
	attack_verb = list("lashed", "bludgeoned")
	attack_noun = list("tendril")
	eye_attack_text = "a tendril"
	eye_attack_text_victim = "a tendril"

/datum/unarmed_attack/claws
	attack_verb = list("scratched", "clawed", "slashed")
	attack_noun = list("claws")
	eye_attack_text = "claws"
	eye_attack_text_victim = "sharp claws"
	attack_sound = 'sound/weapons/slice.ogg'
	miss_sound = 'sound/weapons/slashmiss.ogg'
	sharp = 1
	edge = 1

/datum/unarmed_attack/claws/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/skill = user.skills["combat"]
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	var/datum/gender/T = gender_datums[user.get_visible_gender()]
	var/datum/gender/TT = gender_datums[target.get_visible_gender()]
	if(!skill)	skill = 1
	attack_damage = clamp(attack_damage, 1, 5)

	if(target == user)
		user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [T.himself] in the [affecting.name]!</span>")
		return 0

	switch(zone)
		if(BP_HEAD, O_MOUTH, O_EYES)
			// ----- HEAD ----- //
			switch(attack_damage)
				if(1 to 2)
					user.visible_message("<span class='danger'>[user] scratched [target] across [TT.his] cheek!</span>")
				if(3 to 4)
					user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [target]'s [pick("head", "neck")]!</span>") //'with spread claws' sounds a little bit odd, just enough that conciseness is better here I think
				if(5)
					user.visible_message(pick(
						"<span class='danger'>[user] rakes [T.his] [pick(attack_noun)] across [target]'s face!</span>",
						"<span class='danger'>[user] tears [T.his] [pick(attack_noun)] into [target]'s face!</span>",
						))
		else
			// ----- BODY ----- //
			switch(attack_damage)
				if(1 to 2)	user.visible_message("<span class='danger'>[user] scratched [target]'s [affecting.name]!</span>")
				if(3 to 4)	user.visible_message("<span class='danger'>[user] [pick(attack_verb)] [pick("", "", "the side of")] [target]'s [affecting.name]!</span>")
				if(5)		user.visible_message("<span class='danger'>[user] tears [T.his] [pick(attack_noun)] [pick("deep into", "into", "across")] [target]'s [affecting.name]!</span>")

/datum/unarmed_attack/claws/strong
	attack_verb = list("slashed")
	damage = 5
	shredding = 1

/datum/unarmed_attack/claws/strong/xeno
	attack_verb = list("slashed", "gouged", "stabbed")
	damage = 10

/datum/unarmed_attack/claws/strong/xeno/queen
	attack_verb = list("slashed", "gouged", "stabbed", "gored")
	damage = 15

/datum/unarmed_attack/bite/strong
	attack_verb = list("mauled")
	damage = 8
	shredding = 1

/datum/unarmed_attack/bite/strong/xeno
	damage = 10

/datum/unarmed_attack/slime_glomp
	attack_verb = list("glomped")
	attack_noun = list("body")
	damage = 2

/datum/unarmed_attack/slime_glomp/apply_effects(var/mob/living/carbon/human/user,var/mob/living/carbon/human/target,var/armour,var/attack_damage,var/zone)
	..()
	user.apply_stored_shock_to(target)

/datum/unarmed_attack/stomp/weak
	attack_verb = list("jumped on")

/datum/unarmed_attack/stomp/weak/get_unarmed_damage()
	return damage

/datum/unarmed_attack/stomp/weak/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)
	user.visible_message("<span class='warning'>[user] jumped up and down on \the [target]'s [affecting.name]!</span>")
	playsound(user.loc, attack_sound, 25, 1, -1)

/datum/unarmed_attack/bite/sharp/numbing //Is using this against someone you are truly trying to fight a bad idea? Yes. Yes it is.
	attack_verb = list("bit")
	attack_noun = list("fangs")
	attack_sound = 'sound/weapons/bite.ogg'
	shredding = 0
	sharp = 1
	edge = 1

/datum/unarmed_attack/bite/sharp/numbing/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	var/obj/item/organ/external/affecting = target.get_organ(zone)

	attack_damage = clamp(attack_damage, 1, 5)
	if(target == user)
		user.visible_message("<span class='danger'>[user] [pick(attack_verb)] \himself in the [affecting.name]!</span>")
		return 0 //No venom for you.
	switch(zone)
		if(BP_HEAD, O_MOUTH, O_EYES)
			// ----- HEAD ----- //
			switch(attack_damage)
				if(1 to 2)
					user.visible_message("<span class='danger'>[user]'s fangs scrape across [target]'s cheek!</span>")
					to_chat(target, "<span class='danger'><b>Your face feels tingly!</b></span>")
					target.bloodstr.add_reagent("numbenzyme",attack_damage) //Have to add this here, otherwise the swtich fails.
				if(3 to 4)
					user.visible_message("<span class='danger'>[user]'s fangs pierce into [target]'s neck at an odd, awkward angle!</span>")
					to_chat(target, "<span class='danger'><b>Your neck feels like it's on fire before going numb!</b></span>")
					target.bloodstr.add_reagent("numbenzyme",attack_damage)
				if(5)
					user.visible_message("<span class='danger'>[user] sinks \his [pick(attack_noun)] <b><i>deep</i></b> into [target]'s neck, causing the vein to bulge outwards at some type of chemical is pumped into it!</span>")
					to_chat(target, "<span class='danger'><b>Your neck feels like it's going to burst! Moments later, you simply can't feel your neck any longer, the numbness beginning to spread throughout your body!</b></span>")
					target.bloodstr.add_reagent("numbenzyme",attack_damage)
		else
			// ----- BODY ----- //
			switch(attack_damage)
				if(1 to 2)
					user.visible_message("<span class='danger'>[user]'s fangs scrape across [target]'s [affecting.name]!</span>")
					to_chat(target, "<span class='danger'><b>Your [affecting.name] feels tingly!</b></span>")
					target.bloodstr.add_reagent("numbenzyme",attack_damage)
				if(3 to 4)
					user.visible_message("<span class='danger'>[user]'s fangs pierce [pick("", "", "the side of")] [target]'s [affecting.name]!</span>")
					to_chat(target, "<span class='danger'><b>Your [affecting.name] feels like it's on fire before going numb!</b></span>")
					target.bloodstr.add_reagent("numbenzyme",attack_damage)
				if(5)
					user.visible_message("<span class='danger'>[user]'s fangs sink deep into [target]'s [affecting.name], one of their veins bulging outwards from the sudden fluid pumped into it!</span>")
					to_chat(target, "<span class='danger'><b>Your [affecting.name] feels like it's going to burst! Moments later, you simply can't feel your [affecting.name] any longer, the numbness slowly spreading throughout your body!</b></span>")
					target.bloodstr.add_reagent("numbenzyme",attack_damage)

/datum/unarmed_attack/claws/shadekin
	var/energy_gain = 3

/datum/unarmed_attack/claws/shadekin/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	..()
	user.shadekin_adjust_energy(energy_gain)

/datum/unarmed_attack/bite/sharp/shadekin
	var/energy_gain = 3

/datum/unarmed_attack/bite/sharp/shadekin/show_attack(var/mob/living/carbon/human/user, var/mob/living/carbon/human/target, var/zone, var/attack_damage)
	..()
	user.shadekin_adjust_energy(energy_gain)
